// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "EnumerativeSynthesis.h"
#include "ConstantSynthesis.h"
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

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Transforms/Utils/Cloning.h"

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

void calculateAndInitConstants(Transform &t);

namespace minotaur {

void
EnumerativeSynthesis::findInputs(llvm::Value *Root,
                                 set<Var*> &Cands,
                                 set<Addr*> &Pointers,
                                 unsigned Max) {
  // breadth-first search
  unordered_set<llvm::Value *> Visited;
  queue<llvm::Value *> Q;
  Q.push(Root);

  while (!Q.empty()) {
    llvm::Value *V = Q.front();
    Q.pop();
    if (Visited.insert(V).second) {
      if (auto I = llvm::dyn_cast<llvm::Instruction>(V)) {
        for (auto &Op : I->operands()) {
          Q.push(Op);
        }
      }

      if (llvm::isa<llvm::Constant>(V))
        continue;
      if (V == Root)
        continue;
      if (V->getType()->isIntOrIntVectorTy()) {
        auto T = make_unique<Var>(V);
        Cands.insert(T.get());
        exprs.emplace_back(move(T));
      }
      else if (V->getType()->isPointerTy()) {
        auto T = make_unique<Addr>(V);
        Pointers.insert(T.get());
        exprs.emplace_back(move(T));
      } if (Cands.size() >= Max)
        return;
    }
  }
}

bool
EnumerativeSynthesis::getSketches(llvm::Value *V,
                                  set<Var*> &Inputs,
                                  set<Addr*> &Pointers,
                                  vector<pair<Inst*, set<ReservedConst*>>> &sketches) {
  vector<Inst*> Comps;
  for (auto &I : Inputs) {
    Comps.emplace_back(I);
  }

  auto RC1 = make_unique<ReservedConst>(type(-1, -1, false));
  Comps.emplace_back(RC1.get());

  // handle Memory in other function.
  if (V->getType()->isPointerTy())
    return true;

  unsigned expected = V->getType()->getPrimitiveSizeInBits();

  for (auto Comp = Comps.begin(); Comp != Comps.end(); ++Comp) {
    auto Op = dynamic_cast<Var *>(*Comp);
    if (!Op) continue;
    vector<type> tys;
    auto prev_width = Op->getWidth();
    tys = type::getBinaryInstWorkTypes(prev_width);
    for (auto workty : tys) {
      unsigned prev_bits = workty.getBits();
      unsigned lane = workty.getLane();

      if (expected > prev_width) {
        if (expected % prev_width)
          continue;
        unsigned nb = (expected / prev_width) * prev_bits;
        set<ReservedConst*> RCs1;
        auto SI = make_unique<ConversionInst>(ConversionInst::sext, *Op, lane, prev_bits, nb);
        sketches.push_back(make_pair(SI.get(), move(RCs1)));
        exprs.emplace_back(move(SI));
        set<ReservedConst*> RCs2;
        auto ZI = make_unique<ConversionInst>(ConversionInst::zext, *Op, lane, prev_bits, nb);
        sketches.push_back(make_pair(ZI.get(), move(RCs2)));
        exprs.emplace_back(move(ZI));
      } else if (expected < prev_width){
        if (prev_width % expected)
          continue;

        unsigned nb = expected * prev_bits / prev_width;
        if (nb == 0)
          continue;
        set<ReservedConst*> RCs1;
        auto SI = make_unique<ConversionInst>(ConversionInst::trunc, *Op, lane, prev_bits, nb);
        sketches.push_back(make_pair(SI.get(), move(RCs1)));
        exprs.emplace_back(move(SI));
      }
    }
  }

  // Unary operators

  for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
    if ((*Op0)->getWidth() != expected)
      continue;
    if (dynamic_cast<ReservedConst *>(*Op0))
      continue;
    for (unsigned K = UnaryInst::Op::bitreverse; K <= UnaryInst::Op::cttz; ++K) {
      UnaryInst::Op Op = static_cast<UnaryInst::Op>(K);
      vector<type> tys = type::getBinaryInstWorkTypes(expected);

      for (auto workty : tys) {
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
          Inst *I = nullptr, *J = nullptr;
          set<ReservedConst*> RCs;

          // (op rc, var)
          if (dynamic_cast<ReservedConst *>(*Op0)) {
            if (auto R = dynamic_cast<Var *>(*Op1)) {
              // ignore icmp temporarily
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
          Inst *I = nullptr, *J = nullptr;

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
    type ret_ty = type::getIntrinsicRetTy(op);
    type op0_ty = type::getIntrinsicOp0Ty(op);
    type op1_ty = type::getIntrinsicOp1Ty(op);

    if (ret_ty.getWidth() != expected)
      continue;

    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
        if (dynamic_cast<ReservedConst *>(*Op0) && dynamic_cast<ReservedConst *>(*Op1))
          continue;

        Inst *I = nullptr;
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
        Inst *J = nullptr;
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
        auto B = make_unique<SIMDBinOpInst>(op, *I, *J, expected);
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
        Inst *J = nullptr;
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
    auto elemTy = P->getType();
    if (elemTy != expected)
      continue;
    set<unique_ptr<ReservedConst>> RCs;
    auto V = make_unique<Load>(*P);
    R.push_back(make_pair(move(V), move(RCs)));
  }*/
  return true;
}

static optional<smt::smt_initializer> smt_init;
static bool
compareFunctions(IR::Function &Func1, IR::Function &Func2,
                 unsigned &goodCount, unsigned &badCount, unsigned &errorCount){
  TransformPrintOpts print_opts;
  smt_init->reset();
  Transform t;
  t.src = move(Func1);
  t.tgt = move(Func2);

  t.preprocess();
  t.tgt.syncDataWithSrc(t.src);
  calculateAndInitConstants(t);
  TransformVerify verifier(t, false);
  //t.print(cout, print_opts);
  {
    auto types = verifier.getTypings();
    if (!types) {
      cerr << "Transformation doesn't verify!\n"
              "ERROR: program doesn't type check!\n\n";
      ++errorCount;
      return true;
    }
    assert(types.hasSingleTyping());
  }

  Errors errs = verifier.verify();
  bool result(errs);
  if (result) {
    if (errs.isUnsound()) {
      cerr << "Transformation doesn't verify!\n" << endl;
      ++badCount;
    } else {
      cerr << errs << endl;
      ++errorCount;
    }
  } else {
    cerr << "Transformation seems to be correct!\n\n";
    ++goodCount;
  }

  return result;
}

// call constant synthesizer and fill in constMap if synthesis suceeeds
static bool
constantSynthesis(IR::Function &Func1, IR::Function &Func2,
                  unsigned &goodCount, unsigned &badCount, unsigned &errorCount,
                  unordered_map<const IR::Value*, ReservedConst*> &inputMap) {
  TransformPrintOpts print_opts;
  smt_init->reset();
  Transform t;
  t.src = move(Func1);
  t.tgt = move(Func2);

  t.preprocess();
  t.tgt.syncDataWithSrc(t.src);
  ::calculateAndInitConstants(t);

  ConstantSynthesis S(t);
  //t.print(cout, print_opts);
  // assume type verifies
  std::unordered_map<const IR::Value *, smt::expr> result;
  Errors errs = S.synthesize(result);

  bool ret(errs);
  if (result.empty()) {
    llvm::errs()<<"failed to synthesize constants\n";
    return ret;
  }

  for (auto p : inputMap) {
    auto &ty = p.first->getType();
    auto lty = p.second->getA()->getType();

    if (ty.isIntType()) {
      // TODO, fix, do not use numeral_string()
      p.second->setC(
        llvm::ConstantInt::get(llvm::cast<llvm::IntegerType>(lty),
                               result[p.first].numeral_string(), 10));
    } else if (ty.isFloatType()) {
      //TODO
      UNREACHABLE();
    } else if (ty.isVectorType()) {
      auto trunk = result[p.first];
      llvm::FixedVectorType *vty = llvm::cast<llvm::FixedVectorType>(lty);
      llvm::IntegerType *ety =
        llvm::cast<llvm::IntegerType>(vty->getElementType());
      vector<llvm::Constant *> v;
      for (int i = vty->getElementCount().getKnownMinValue()-1; i >= 0; i --) {
        unsigned bits = ety->getBitWidth();
        auto elem = trunk.extract((i + 1) * bits - 1, i * bits);
        // TODO: support undef
        if (!elem.isConst())
          return ret;
        v.push_back(llvm::ConstantInt::get(ety, elem.numeral_string(), 10));
      }
      p.second->setC(llvm::ConstantVector::get(v));
    }
  }

  goodCount++;

  return ret;
}

static void removeUnusedDecls(unordered_set<llvm::Function *> IntrinsicDecls) {
  for (auto Intr : IntrinsicDecls) {
    if (Intr->isDeclaration() && Intr->use_empty()) {
      Intr->eraseFromParent();
    }
  }
}

pair<Inst*, unordered_map<llvm::Argument*, llvm::Constant*>>
EnumerativeSynthesis::synthesize(llvm::Function &F, llvm::TargetLibraryInfo &TLI) {
  llvm::errs()<<"Working on Function:\n";
  F.dump();
  unsigned machinecost = get_machine_cost(&F);
  config::disable_undef_input = true;
  config::disable_poison_input = true;
  unordered_map<llvm::Argument *, llvm::Constant *> constMap;

  bool changed = false;

  smt_init.emplace();
  std::unordered_set<llvm::Function *> IntrinsicDecls;

  unsigned src_cost = get_approx_cost(&F);

  for (auto &BB : F) {
    auto T = BB.getTerminator();
    if(!llvm::isa<llvm::ReturnInst>(T))
      continue;
    llvm::Value *S = llvm::cast<llvm::ReturnInst>(T)->getReturnValue();
    if (!llvm::isa<llvm::Instruction>(S))
      continue;
    llvm::Instruction *I = cast<llvm::Instruction>(S);
    set<Var*> Inputs;
    set<Addr*> Pointers;
    findInputs(&*I, Inputs, Pointers, 20);

    vector<pair<Inst*,set<ReservedConst*>>> Sketches;

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
      for (auto &V : Inputs) {
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
    getSketches(&*I, Inputs, Pointers, Sketches);

    cout<<"---------Sketches------------"<<endl;
    for (auto &Sketch : Sketches) {
      cout<<*Sketch.first<<endl;
    }
    cout<<"-----------------------------"<<endl;

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
      if (tgt_cost >= src_cost) {
        Tgt->eraseFromParent();
        if (HaveC)
          Src->eraseFromParent();
        continue;
      }

      Fns.push_back(make_tuple(Tgt, Src, G, !Sketch.second.empty()));
    }
    std::stable_sort(Fns.begin(), Fns.end(), ac_cmp);
    // llvm functions -> alive2 functions
    auto iter = Fns.begin();
    Inst *R;
    bool success = false;
    for (;iter != Fns.end();) {
      auto &[Tgt, Src, G, HaveC] = *iter;
      unsigned tgt_cost = get_approx_cost(Tgt);
      llvm::errs()<<"-- candidate approx_cost(tgt) = " << tgt_cost
                  << ", approx_cost(src) = " << src_cost <<" --\n";
      Tgt->dump();
      auto Func1 = llvm_util::llvm2alive(*Src, TLI);
      auto Func2 = llvm_util::llvm2alive(*Tgt, TLI);
      unsigned goodCount = 0, badCount = 0, errorCount = 0;
      if (!HaveC) {
        compareFunctions(*Func1, *Func2,
                         goodCount, badCount, errorCount);
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
        constMap.clear();
        constantSynthesis(*Func1, *Func2,
                          goodCount, badCount, errorCount, inputMap);

        Src->eraseFromParent();
      }
      Tgt->eraseFromParent();
      if (goodCount) {
        R = G;
        success = true;
      }
      iter = Fns.erase(iter);
      if (goodCount) {
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
      llvm::errs()<<"=== original ir (uops="<<machinecost<<") ===\n";
      F.dump();
      llvm::ValueToValueMapTy VMap;
      llvm::Value *V = LLVMGen(&*I, IntrinsicDecls).codeGen(R, VMap);
      V = llvm::IRBuilder<>(I).CreateBitCast(V, I->getType());
      I->replaceAllUsesWith(V);
      eliminate_dead_code(F);
      unsigned newcost = get_machine_cost(&F);
      llvm::errs()<<"=== optimized ir (uops="<<newcost<<") ===\n";
      F.dump();
      if (!machinecost || !newcost || newcost <= machinecost) {
        llvm::errs()<<"=== successfully synthesized rhs ===\n";
        return {R, constMap};
      } else {
        llvm::errs()<<"!!! fails machine cost check, keep searching !!!\n";
      }
    }
  }
  return {nullptr, constMap};
}

};
