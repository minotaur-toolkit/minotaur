// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "AliveInterface.h"
#include "Config.h"
#include "EnumerativeSynthesis.h"
#include "Expr.h"
#include "LLVMGen.h"
#include "MachineCost.h"
#include "Utils.h"

#include "Type.h"
#include "ir/globals.h"
#include "ir/instr.h"
#include "smt/smt.h"
#include "tools/transform.h"
#include "util/compiler.h"
#include "util/symexec.h"
#include "util/config.h"
#include "util/dataflow.h"
#include "util/version.h"
#include "llvm_util/llvm2alive.h"
#include "llvm_util/utils.h"

#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Support/KnownBits.h"

#include <algorithm>
#include <iostream>
#include <queue>
#include <vector>
#include <set>
#include <map>

using namespace tools;
using namespace util;
using namespace std;
using namespace IR;

bool DISABLE_AVX512 = false;

namespace minotaur {

void
EnumerativeSynthesis::findInputs(llvm::Function &F,
                                 llvm::Instruction *root,
                                 llvm::DominatorTree &DT) {
  // breadth-first search
  for (auto &A : F.args()) {
    if (A.getType()->isIntOrIntVectorTy()) {
      auto T = make_unique<Var>(&A);
      Values.insert(T.get());
      exprs.emplace_back(move(T));
    }
  }
  for (auto &BB : F) {
    for (auto &I : BB) {
      if (&I == root)
        continue;
      if (!DT.dominates(&I, root))
        continue;

      auto ty = I.getType();
      if (ty->isIntOrIntVectorTy()) {
        auto T = make_unique<Var>(&I);
        Values.insert(T.get());
        exprs.emplace_back(move(T));
      }
      else if (ty->isPointerTy()) {
        auto T = make_unique<Pointer>(&I);
        Pointers.insert(T.get());
        exprs.emplace_back(move(T));
      }
      else if (ty->isVectorTy() && ty->getScalarType()->isPointerTy()) {
        auto T = make_unique<PointerVector>(&I);
        PointerVectors.insert(T.get());
        exprs.emplace_back(move(T));
      }
    }
  }
}

bool
EnumerativeSynthesis::getSketches(llvm::Value *V,
                                  vector<Sketch> &sketches) {
  vector<Value*> Comps;
  for (auto &I : Values) {
    Comps.emplace_back(I);
  }

  auto RC1 = make_unique<ReservedConst>(type(-1, -1, false));
  Comps.emplace_back(RC1.get());

  // handle Memory in other function.
  if (V->getType()->isPointerTy())
    return true;

  unsigned expected = V->getType()->getPrimitiveSizeInBits();

  for (auto Comp = Comps.begin(); Comp != Comps.end(); ++Comp) {
    auto Op = dynamic_cast<Var*>(*Comp);
    if (!Op) continue;
    vector<type> tys;
    auto op_w = Op->getWidth();
    tys = type::getBinaryInstWorkTypes(op_w);
    for (auto workty : tys) {
      unsigned op_bits = workty.getBits();
      unsigned lane = workty.getLane();

      if (expected % lane != 0)
        continue;

      if (expected > op_w) {
        if (expected % op_w)
          continue;
        unsigned nb = (expected / op_w) * op_bits;
        set<ReservedConst*> RCs1;
        auto SI = make_unique<ConversionInst>(ConversionInst::sext, *Op, lane,
                                              op_bits, nb);
        sketches.push_back(make_pair(SI.get(), move(RCs1)));
        exprs.emplace_back(move(SI));
        set<ReservedConst*> RCs2;
        auto ZI = make_unique<ConversionInst>(ConversionInst::zext, *Op, lane,
                                              op_bits, nb);
        sketches.push_back(make_pair(ZI.get(), move(RCs2)));
        exprs.emplace_back(move(ZI));
      } else if (expected < op_w){
        if (op_w % expected != 0)
          continue;

        unsigned nb = expected * op_bits / op_w;
        if (nb == 0)
          continue;
        set<ReservedConst*> RCs1;
        auto SI = make_unique<ConversionInst>(ConversionInst::trunc, *Op, lane,
                                              op_bits, nb);
        sketches.push_back(make_pair(SI.get(), move(RCs1)));
        exprs.emplace_back(move(SI));
      }
    }
  }

  // unop
  for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
    if ((*Op0)->getWidth() != expected)
      continue;
    if (dynamic_cast<ReservedConst *>(*Op0))
      continue;
    for (unsigned K = UnaryInst::Op::bitreverse; K <= UnaryInst::Op::ctpop; ++K) {
      UnaryInst::Op Op = static_cast<UnaryInst::Op>(K);
      vector<type> tys = type::getBinaryInstWorkTypes(expected);

      for (auto workty : tys) {
        unsigned bits = workty.getBits();
        if (K == UnaryInst::Op::bswap && (bits < 16 || bits % 8))
          continue;
        set<ReservedConst*> RCs;
        auto U = make_unique<UnaryInst>(Op, **Op0, workty);
        sketches.push_back(make_pair(U.get(), move(RCs)));
        exprs.emplace_back(move(U));
      }
    }
  }

  // binop
  for (unsigned K = BinaryInst::Op::band; K <= BinaryInst::Op::mul; ++K) {
    BinaryInst::Op Op = static_cast<BinaryInst::Op>(K);
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      auto Op1 = BinaryInst::isCommutative(Op) ? Op0 : Comps.begin();
      for (; Op1 != Comps.end(); ++Op1) {
        vector<type> tys;
        if (BinaryInst::isLaneIndependent(Op)) {
          tys.push_back(type(1, expected, false));
        } else {
          tys = type::getBinaryInstWorkTypes(expected);
        }
        for (auto workty : tys) {
          Value *I = nullptr, *J = nullptr;
          set<ReservedConst*> RCs;

          // (op rc, var)
          if (dynamic_cast<ReservedConst *>(*Op0)) {
            if (auto R = dynamic_cast<Var *>(*Op1)) {
              if (R->getWidth() != expected)
                continue;
              auto T = make_unique<ReservedConst>(workty);
              I = T.get();
              RCs.insert(T.get());
              exprs.emplace_back(move(T));
              J = R;
              if (BinaryInst::isCommutative(Op)) {
                swap(I, J);
              }
            } else continue;
          }
          // (op var, rc)
          else if (dynamic_cast<ReservedConst *>(*Op1)) {
            if (auto L = dynamic_cast<Var *>(*Op0)) {
              // do not generate (- x 3) which can be represented as (+ x -3)
              if (Op == BinaryInst::Op::sub)
                continue;
              if (L->getWidth() != expected)
                continue;
              I = L;
              auto T = make_unique<ReservedConst>(workty);
              J = T.get();
              RCs.insert(T.get());
              exprs.emplace_back(move(T));
            } else continue;
          }
          // (op var, var)
          else {
            if (auto L = dynamic_cast<Var *>(*Op0)) {
              if (auto R = dynamic_cast<Var *>(*Op1)) {
                if (L->getWidth() != expected || R->getWidth() != expected)
                  continue;
              };
            };
            I = *Op0;
            J = *Op1;
          }
          auto BO = make_unique<BinaryInst>(Op, *I, *J, workty);
          sketches.push_back(make_pair(BO.get(), move(RCs)));
          exprs.emplace_back(move(BO));
        }
      }
    }
  }

  //icmps
  if (expected <= 64) {
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
        // skip (icmp rc, rc)
        if (dynamic_cast<ReservedConst*>(*Op0) &&
            dynamic_cast<ReservedConst*>(*Op1))
          continue;
        // skip (icmp rc, var)
        if (dynamic_cast<ReservedConst*>(*Op0) && dynamic_cast<Var*>(*Op1))
          continue;
        for (unsigned C = ICmpInst::Cond::eq; C <= ICmpInst::Cond::sle; ++C) {
          ICmpInst::Cond Cond = static_cast<ICmpInst::Cond>(C);
          set<ReservedConst*> RCs;
          Value *I = nullptr, *J = nullptr;

          if (auto L = dynamic_cast<Var*>(*Op0)) {
            if (L->getWidth() % expected)
              continue;

            unsigned elem_bits = L->getWidth() / expected;
            if (elem_bits != 8 && elem_bits != 16 && elem_bits != 32 && elem_bits != 64)
              continue;
            // (icmp var, rc)
            if (dynamic_cast<ReservedConst*>(*Op1)) {
              if (Cond == ICmpInst::sle || Cond == ICmpInst::ule)
                continue;
              I = L;
              auto jty = type(expected, elem_bits, false);
              auto T = make_unique<ReservedConst>(jty);
              J = T.get();
              RCs.insert(T.get());
              exprs.emplace_back(move(T));
            // (icmp var, var)
            } else if (auto R = dynamic_cast<Var*>(*Op1)) {
              if (L->getWidth() != R->getWidth())
                continue;
              I = *Op0;
              J = *Op1;
            } else UNREACHABLE();
          } else UNREACHABLE();
          auto BO = make_unique<ICmpInst>(Cond, *I, *J, expected);
          sketches.push_back(make_pair(BO.get(), move(RCs)));
          exprs.emplace_back(move(BO));
        }
      }
    }
  }

  // BinaryIntrinsics
  for (unsigned K = 0; K < X86IntrinBinOp::numOfX86Intrinsics; ++K) {
    // typecheck for return val
    X86IntrinBinOp::Op op = static_cast<X86IntrinBinOp::Op>(K);
    if (DISABLE_AVX512 && SIMDBinOpInst::is512(op))
      continue;
    type ret_ty = type::getIntrinsicRetTy(op);
    type op0_ty = type::getIntrinsicOp0Ty(op);
    type op1_ty = type::getIntrinsicOp1Ty(op);

    if (ret_ty.getWidth() != expected)
      continue;

    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
        if (dynamic_cast<ReservedConst *>(*Op0) && dynamic_cast<ReservedConst *>(*Op1))
          continue;

        Value *I = nullptr;
        set<ReservedConst*> RCs;

        if (auto L = dynamic_cast<Var *> (*Op0)) {
          // typecheck for op0
          if (L->getWidth() != op0_ty.getWidth())
            continue;
          I = L;
        } else if (dynamic_cast<ReservedConst *>(*Op0)) {
          auto T = make_unique<ReservedConst>(op0_ty);
          I = T.get();
          RCs.insert(T.get());
          exprs.emplace_back(move(T));
        }
        Value *J = nullptr;
        if (auto R = dynamic_cast<Var *>(*Op1)) {
          // typecheck for op1
          if (R->getWidth() != op1_ty.getWidth())
            continue;
          J = R;
        } else if (dynamic_cast<ReservedConst *>(*Op1)) {
          auto T = make_unique<ReservedConst>(op1_ty);
          J = T.get();
          RCs.insert(T.get());
          exprs.emplace_back(move(T));
        }
        auto B = make_unique<SIMDBinOpInst>(op, *I, *J);
        sketches.push_back(make_pair(B.get(), move(RCs)));
        exprs.emplace_back(move(B));
      }
    }
  }
  // shufflevector
  for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
    // skip (sv rc, *, mask)
    if (dynamic_cast<ReservedConst *>(*Op0))
      continue;

    auto tys = type::getVectorTypes(expected);
    for (auto ty : tys) {
      if ((*Op0)->getWidth() % ty.getBits())
        continue;
      if ((*Op0)->getWidth() == ty.getBits())
        continue;
      // (sv var, poison, mask)
      {
        set<ReservedConst*> RCs;
        auto m = make_unique<ReservedConst>(type(ty.getLane(), 8, false));
        RCs.insert(m.get());
        auto sv = make_unique<FakeShuffleInst>(**Op0, nullptr, *m.get(), ty);
        exprs.emplace_back(move(m));
        sketches.push_back(make_pair(sv.get(), move(RCs)));
        exprs.emplace_back(move(sv));
      }
      // (sv var1, var2, mask)
      for (auto Op1 = Op0 + 1; Op1 != Comps.end(); ++Op1) {
        set<ReservedConst*> RCs;
        Value *J = nullptr;
        if (auto R = dynamic_cast<Var *>(*Op1)) {
          // typecheck for op1
          if (R->getWidth() != (*Op0)->getWidth())
            continue;
          J = R;
        } else if (dynamic_cast<ReservedConst *>(*Op1)) {
          type op_ty =
            type((*Op0)->getWidth() / ty.getBits(), ty.getBits(), false);
          auto T = make_unique<ReservedConst>(op_ty);
          J = T.get();
          RCs.insert(T.get());
          exprs.emplace_back(move(T));
        }
        auto m = make_unique<ReservedConst>(type(ty.getLane(), 8, false));
        RCs.insert(m.get());
        auto sv2 = make_unique<FakeShuffleInst>(**Op0, J, *m.get(), ty);
        exprs.emplace_back(move(m));
        sketches.push_back(make_pair(sv2.get(), move(RCs)));
        exprs.emplace_back(move(sv2));
      }
    }
  }

/*
  for (auto &P : Pointers) {
    auto tys = type::getVectorTypes(expected);
    for (auto ty : tys) {
      auto L = make_unique<Load>(*P, ty);
      set<ReservedConst*> RCs;
      sketches.push_back(make_pair(L.get(), move(RCs)));
      exprs.emplace_back(move(L));
    }
  }
  */
  return true;
}

tuple<Inst*, unsigned, unsigned>
EnumerativeSynthesis::synthesize(llvm::Function &F, llvm::TargetLibraryInfo &TLI) {
  if (config::debug_enumerator) {
    config::dbg()<<"working on sliced function\n";
    F.dump();
  }
  clock_t start = std::clock();
  llvm::DominatorTree DT(F);
  DT.recalculate(F);

  unsigned machinecost = get_machine_cost(&F);


  bool changed = false;

  std::unordered_set<llvm::Function *> IntrinsicDecls;

  unsigned src_cost = get_approx_cost(&F);

  auto DL = F.getParent()->getDataLayout();

  AliveEngine AE;

  for (auto &BB : F) {
    auto T = BB.getTerminator();
    if(!llvm::isa<llvm::ReturnInst>(T))
      continue;
    llvm::Value *S = llvm::cast<llvm::ReturnInst>(T)->getReturnValue();
    if (!llvm::isa<llvm::Instruction>(S))
      continue;
    llvm::Instruction *I = cast<llvm::Instruction>(S);

    unsigned Width = I->getType()->getScalarSizeInBits();
    llvm::KnownBits KnownI(Width);
    computeKnownBits(I, KnownI, DL);

    findInputs(F, I, DT);

    vector<Sketch> Sketches;

    // immediate constant synthesis
    if (!I->getType()->isPointerTy()) {
      set<ReservedConst*> RCs;
      auto RC = make_unique<ReservedConst>(type(I->getType()));
      auto CI = make_unique<CopyInst>(*RC.get());
      RCs.insert(RC.get());
      Sketches.push_back(make_pair(CI.get(), move(RCs)));
      exprs.emplace_back(move(CI));
      exprs.emplace_back(move(RC));
    }
    // nops
    {
      for (auto &V : Values) {
        auto vty = V->V()->getType();
        if (vty->isPointerTy())
          continue;
        if (V->getWidth() != I->getType()->getPrimitiveSizeInBits())
          continue;
        set<ReservedConst*> RCs;
        auto VA = make_unique<Var>(V->V());
        Sketches.push_back(make_pair(VA.get(), move(RCs)));
        exprs.emplace_back(move(VA));
      }
    }
    getSketches(&*I, Sketches);

    if (config::debug_enumerator) {
      config::dbg() << "---------sketches------------\n";
      for (auto &Sketch : Sketches) {
        config::dbg() << *Sketch.first << endl;
      }
      config::dbg() << "-----------------------------\n";
    }
    unordered_map<string, ReservedConst*> constants;
    unsigned CI = 0;
    /*
    priority_queue<tuple<llvm::Function*, llvm::Function*, Inst*, bool>,
                   vector<tuple<llvm::Function*, llvm::Function*, Inst*, bool>>,
                   MCComparator> Fns;*/
    vector<tuple<llvm::Function*, llvm::Function*, Inst*, bool>> Fns;
    auto FT = F.getFunctionType();
    // sketches -> llvm functions

    for (auto &Sketch : Sketches) {
      bool HaveC = !Sketch.second.empty();
      auto &G = Sketch.first;
      llvm::ValueToValueMapTy VMap;


      llvm::SmallVector<llvm::Type *, 8> Args;
      for (auto I: FT->params()) {
        Args.push_back(I);
      }

      for (auto &C : Sketch.second) {
        Args.push_back(C->getType().toLLVM(F.getContext()));
      }

      auto nFT =
        llvm::FunctionType::get(FT->getReturnType(), Args, FT->isVarArg());

      llvm::Function *Tgt =
        llvm::Function::Create(nFT, F.getLinkage(), F.getName(), F.getParent());

      llvm::SmallVector<llvm::ReturnInst *, 8> TgtReturns;
      llvm::Function::arg_iterator TgtArgI = Tgt->arg_begin();

      for (auto I = F.arg_begin(), E = F.arg_end(); I != E; ++I, ++TgtArgI) {
        VMap[I] = TgtArgI;
        TgtArgI->setName(I->getName());
      }

      // sketches with constants, duplicate F
      for (auto &C : Sketch.second) {
        string arg_name = "_reservedc_" + std::to_string(CI);
        TgtArgI->setName(arg_name);
        constants[arg_name] = C;
        C->setA(TgtArgI);
        ++CI;
        ++TgtArgI;
      }

      llvm::CloneFunctionInto(Tgt, &F, VMap,
        llvm::CloneFunctionChangeType::LocalChangesOnly, TgtReturns);

      llvm::Function *Src;
      if (HaveC) {
        llvm::ValueToValueMapTy _vs;
        Src = llvm::CloneFunction(Tgt, _vs);
      } else {
        Src = &F;
      }

      llvm::Instruction *PrevI = llvm::cast<llvm::Instruction>(VMap[&*I]);
      llvm::Value *V =
         LLVMGen(PrevI, IntrinsicDecls).codeGen(G, VMap);
      V = llvm::IRBuilder<>(PrevI).CreateBitCast(V, PrevI->getType());
      PrevI->replaceAllUsesWith(V);

      eliminate_dead_code(*Tgt);
      unsigned tgt_cost = get_approx_cost(Tgt);
      llvm::KnownBits KnownV(Width);

      bool skip = false;
      string err;
      llvm::raw_string_ostream err_stream(err);
      bool illformed = llvm::verifyFunction(*Tgt, &err_stream);

      if (illformed) {
        llvm::errs()<<"Error tgt found: "<<err<<"\n";
        Tgt->dump();
        skip = true;
        goto push;
      }

      // check cost
      if (tgt_cost >= src_cost) {
        skip = true;
        goto push;
      }

      // pruning by knownbits
      computeKnownBits(V, KnownV, DL);
      if ((KnownV.Zero & KnownI.One) != 0 || (KnownV.One & KnownI.Zero) != 0) {
        skip = true;
        goto push;
      }
push:
      if (skip) {
        Tgt->eraseFromParent();
        if (HaveC)
          Src->eraseFromParent();
      } else {
        Fns.push_back(make_tuple(Tgt, Src, G, !Sketch.second.empty()));
      }
    }
    std::stable_sort(Fns.begin(), Fns.end(), approx_cmp);
    // llvm functions -> alive2 functions
    auto iter = Fns.begin();
    Inst *R;
    bool success = false;
    for (;iter != Fns.end();) {
      auto &[Tgt, Src, G, HaveC] = *iter;
      unsigned tgt_cost = get_approx_cost(Tgt);
      if (config::debug_enumerator) {
        config::dbg() << "-- candidate approx_cost(tgt) = " << tgt_cost
                      << ", approx_cost(src) = " << src_cost <<" --\n";
        Tgt->dump();
      }
      auto Func1 = llvm_util::llvm2alive(*Src, TLI, true);
      auto Func2 = llvm_util::llvm2alive(*Tgt, TLI, true);

      unsigned goodCount = 0, badCount = 0, errorCount = 0;
      if (!Func1.has_value() || !Func2.has_value()) {
        if (config::debug_tv) {
          llvm::errs()<<"error found when converting llvm to alive2\n";
        }
        return {nullptr, 0, 0};
      }

      if (!HaveC) {
        try {
          AE.compareFunctions(*Func1, *Func2,
                              goodCount, badCount, errorCount);
        } catch (AliveException e) {
          if (config::debug_tv) {
            llvm::errs()<<e.msg<<"\n";
          }
          if (e.msg == "slow vcgen") {
             return {nullptr, 0, 0};
          }
        }
      } else {
        unordered_map<const IR::Value *, ReservedConst *> inputMap;
        for (auto &I : Func2->getInputs()) {
          string input_name = I.getName();
          // remove "%"
          input_name.erase(0, 1);
          if (constants.count(input_name)) {
            inputMap[&I] = constants[input_name];
          }
        }
        try {
          AE.constantSynthesis(*Func1, *Func2,
                               goodCount, badCount, errorCount, inputMap);
        } catch (AliveException e) {
          if (config::debug_tv) {
            llvm::errs()<<e.msg<<"\n";
          }
          if (e.msg == "slow vcgen") {
            return {nullptr, 0, 0};
          }
        }
      }

      if (HaveC)
        Src->eraseFromParent();
      Tgt->eraseFromParent();
      if (goodCount) {
        R = G;
        success = true;
      }
      iter = Fns.erase(iter);
      unsigned duration = ( std::clock() - start ) / CLOCKS_PER_SEC;
      if (goodCount || duration > 1200) {
        break;
      }
    }

    for (;iter != Fns.end(); ++iter) {
      auto &[Tgt, Src, _, HaveC] = *iter;
      if (HaveC)
        Src->eraseFromParent();
      Tgt->eraseFromParent();
    }

    // replace
    if (success) {
      if (config::debug_enumerator) {
        llvm::errs()<<"=== original ir (uops="<<machinecost<<") ===\n";
        F.dump();
      }
      llvm::ValueToValueMapTy VMap;
      llvm::Value *V = LLVMGen(&*I, IntrinsicDecls).codeGen(R, VMap);
      V = llvm::IRBuilder<>(I).CreateBitCast(V, I->getType());
      I->replaceAllUsesWith(V);
      unsigned newcost = get_machine_cost(&F);
      if (config::debug_enumerator) {
        llvm::errs()<<"=== optimized ir (uops="<<newcost<<") ===\n";
        F.dump();
      }
      if (config::ignore_machine_cost ||
          !machinecost || !newcost || newcost < machinecost) {
        if (config::debug_enumerator) {
          llvm::errs()<<"=== successfully synthesized rhs ===\n";
        }
        return {R, machinecost, newcost};
      } else {
        if (config::debug_enumerator) {
          llvm::errs()<<"!!! fails machine cost check, keep searching !!!\n";
        }
      }
    }
  }
  return {nullptr, 0, 0};
}

};
