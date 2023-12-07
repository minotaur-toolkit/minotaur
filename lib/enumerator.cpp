// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "alive-interface.h"
#include "config.h"
#include "enumerator.h"
#include "expr.h"
#include "codegen.h"
#include "cost.h"
#include "utils.h"
#include "type.h"

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

#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/Triple.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Support/KnownBits.h"

#include <algorithm>
#include <iostream>
#include <memory>
#include <queue>
#include <vector>
#include <set>
#include <map>

using namespace tools;
using namespace util;
using namespace std;
using namespace IR;

namespace {
struct debug {
template<class T>
debug &operator<<(const T &s)
{
  if (minotaur::config::debug_enumerator)
    llvm::errs() << s;
  return *this;
}
};
}


namespace minotaur {

void
Enumerator::findInputs(llvm::Function &F,
                       llvm::Instruction *root,
                       llvm::DominatorTree &DT) {
  // breadth-first search
  for (auto &A : F.args()) {
    auto T = make_unique<Var>(&A);
    values.insert(T.get());
    exprs.emplace_back(std::move(T));
  }
  for (auto &BB : F) {
    for (auto &I : BB) {
      if (&I == root)
        continue;

      auto ty = I.getType()->getScalarType();
      if (!ty->isIntegerTy() && !ty->isIEEELikeFPTy())
        continue;

      if (!DT.dominates(&I, root))
        continue;

      auto T = make_unique<Var>(&I);
      values.insert(T.get());
      exprs.emplace_back(std::move(T));
    }
  }
}

bool Enumerator::getSketches(llvm::Value *V, vector<Sketch> &sketches) {
  vector<Value*> Comps;
  for (auto &I : values) {
    Comps.emplace_back(I);
  }

  auto RC1 = make_unique<ReservedConst>(type(-1, -1, false));
  Comps.emplace_back(RC1.get());

  type expected{V->getType()};

  for (auto Comp = Comps.begin(); Comp != Comps.end(); ++Comp) {
    auto Op = dynamic_cast<Var*>(*Comp);
    if (!Op) continue;
    unsigned op_w = Op->getType().getWidth();
    if (Op->getType().same_width(expected))
      continue;

    vector<type> tys = getIntegerVectorTypes(Op->getType().getWidth());
    for (auto workty : tys) {
      unsigned op_bits = workty.getBits();
      unsigned lane = workty.getLane();

      if (expected.getWidth() % lane != 0)
        continue;

      if (expected.getWidth() > op_w) {
        if (expected.getWidth() % op_w)
          continue;
        unsigned nb = (expected.getWidth() / op_w) * op_bits;
        set<ReservedConst*> RCs1;
        auto SI = make_unique<ConversionOp>(ConversionOp::sext, *Op, lane,
                                            op_bits, nb);
        sketches.push_back(make_pair(SI.get(), std::move(RCs1)));
        exprs.emplace_back(std::move(SI));
        set<ReservedConst*> RCs2;
        auto ZI = make_unique<ConversionOp>(ConversionOp::zext, *Op, lane,
                                            op_bits, nb);
        sketches.push_back(make_pair(ZI.get(), std::move(RCs2)));
        exprs.emplace_back(std::move(ZI));
      } else if (expected.getWidth() < op_w){
        if (expected.getWidth() % op_w != 0)
          continue;

        unsigned nb = expected.getWidth() * op_bits / op_w;
        if (nb == 0)
          continue;
        set<ReservedConst*> RCs1;
        auto SI = make_unique<ConversionOp>(ConversionOp::trunc, *Op, lane,
                                            op_bits, nb);
        sketches.push_back(make_pair(SI.get(), std::move(RCs1)));
        exprs.emplace_back(std::move(SI));
      }
    }
  }

  // unop
  for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
    if (!expected.same_width((*Op0)->getType()))
      continue;
    if (dynamic_cast<ReservedConst *>(*Op0))
      continue;
    for (unsigned K = UnaryOp::bitreverse; K <= UnaryOp::ctpop; ++K) {
      UnaryOp::Op Op = static_cast<UnaryOp::Op>(K);
      vector<type> tys = getUnaryOpWorkTypes(expected, Op);

      for (auto workty : tys) {
        unsigned bits = workty.getBits();
        if (K == UnaryOp::Op::bswap && (bits < 16 || bits % 8))
          continue;
        set<ReservedConst*> RCs;
        auto U = make_unique<UnaryOp>(Op, **Op0, workty);
        sketches.push_back(make_pair(U.get(), std::move(RCs)));
        exprs.emplace_back(std::move(U));
      }
    }
  }

  // binop
  for (unsigned K = BinaryOp::band; K <= BinaryOp::frem; ++K) {
    BinaryOp::Op Op = static_cast<BinaryOp::Op>(K);
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      auto Op1 = BinaryOp::isCommutative(Op) ? Op0 : Comps.begin();
      for (; Op1 != Comps.end(); ++Op1) {

        for (auto workty : getBinaryOpWorkTypes(expected, Op)) {
          Value *I = nullptr, *J = nullptr;
          set<ReservedConst*> RCs;

          // (op rc, var)
          if (dynamic_cast<ReservedConst*>(*Op0)) {
            if (auto R = dynamic_cast<Var*>(*Op1)) {
              if (!expected.same_width(R->getType()))
                continue;
              auto T = make_unique<ReservedConst>(workty);
              I = T.get();
              RCs.insert(T.get());
              exprs.emplace_back(std::move(T));
              J = R;
              if (BinaryOp::isCommutative(Op)) {
                swap(I, J);
              }
            } else continue;
          }
          // (op var, rc)
          else if (dynamic_cast<ReservedConst *>(*Op1)) {
            if (auto L = dynamic_cast<Var *>(*Op0)) {
              // do not generate (- x 3) which can be represented as (+ x -3)
              if (Op == BinaryOp::Op::sub)
                continue;
              if (!expected.same_width(L->getType()))
                continue;
              I = L;
              auto T = make_unique<ReservedConst>(workty);
              J = T.get();
              RCs.insert(T.get());
              exprs.emplace_back(std::move(T));
            } else continue;
          }
          // (op var, var)
          else {
            if (auto L = dynamic_cast<Var *>(*Op0)) {
              if (auto R = dynamic_cast<Var *>(*Op1)) {
                if (!expected.same_width(L->getType()) ||
                    !expected.same_width(R->getType()))
                  continue;
              };
            };
            I = *Op0;
            J = *Op1;
          }
          auto BO = make_unique<BinaryOp>(Op, *I, *J, workty);
          sketches.push_back(make_pair(BO.get(), std::move(RCs)));
          exprs.emplace_back(std::move(BO));
        }
      }
    }
  }

  //cmps
  if (expected.getWidth() <= 64) {
    unsigned lanes = expected.getWidth();
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
        // skip (icmp rc, rc)
        if (dynamic_cast<ReservedConst*>(*Op0) &&
            dynamic_cast<ReservedConst*>(*Op1))
          continue;
        // skip (icmp rc, var)
        if (dynamic_cast<ReservedConst*>(*Op0) && dynamic_cast<Var*>(*Op1))
          continue;

        //icmps
        for (unsigned C = ICmp::Cond::eq; C <= ICmp::Cond::sle; ++C) {
          ICmp::Cond Cond = static_cast<ICmp::Cond>(C);
          set<ReservedConst*> RCs;
          Value *I = nullptr, *J = nullptr;

          if (auto L = dynamic_cast<Var*>(*Op0)) {
            if (L->getType().getWidth() % expected.getWidth())
              continue;

            unsigned elem_bits = L->getType().getWidth() / lanes;
            if (elem_bits != 8 && elem_bits != 16 &&
                elem_bits != 32 && elem_bits != 64)
              continue;
            // (icmp var, rc)
            if (dynamic_cast<ReservedConst*>(*Op1)) {
              if (Cond == ICmp::sle || Cond == ICmp::ule)
                continue;
              I = L;
              auto jty = type(lanes, elem_bits, false);
              auto T = make_unique<ReservedConst>(jty);
              J = T.get();
              RCs.insert(T.get());
              exprs.emplace_back(std::move(T));
            // (icmp var, var)
            } else if (auto R = dynamic_cast<Var*>(*Op1)) {
              if (L->getType().getWidth() != R->getType().getWidth())
                continue;
              I = *Op0;
              J = *Op1;
            } else UNREACHABLE();
          } else UNREACHABLE();
          auto BO = make_unique<ICmp>(Cond, *I, *J, lanes);
          sketches.push_back(make_pair(BO.get(), std::move(RCs)));
          exprs.emplace_back(std::move(BO));
        }
      }
    }
  }

  // fcmps
  if (expected.getWidth() <= 64) {
    unsigned lanes = expected.getWidth();
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {

        // skip (fcmp rc, rc)
        if (dynamic_cast<ReservedConst*>(*Op0) &&
            dynamic_cast<ReservedConst*>(*Op1))
          continue;
        // skip (fcmp rc, var)
        if (dynamic_cast<ReservedConst*>(*Op0) && dynamic_cast<Var*>(*Op1))
          continue;

        //fcmps
        Value *I = dynamic_cast<Var*>(*Op0);
        if (!I)
          continue;

        if (I->getType().getLane() != expected.getWidth())
          continue;

        if (auto V = dynamic_cast<Var*>(*Op1)) {
          if (I->getType() != V->getType())
            continue;
        }

        for (unsigned C = FCmp::Cond::f; C <= FCmp::Cond::t; ++C) {
          FCmp::Cond Cond = static_cast<FCmp::Cond>(C);
          set<ReservedConst*> RCs;

          Value *J = nullptr;

          if (dynamic_cast<Var*>(*Op1)) {
            J = *Op1;
          } else if (dynamic_cast<ReservedConst*>(*Op1)) {
            auto T = make_unique<ReservedConst>(I->getType());
            J = T.get();
            RCs.insert(T.get());
            exprs.emplace_back(std::move(T));
          } else UNREACHABLE();

          auto BO = make_unique<FCmp>(Cond, *I, *J, lanes);
          sketches.push_back(make_pair(BO.get(), std::move(RCs)));
          exprs.emplace_back(std::move(BO));
        }
      }
    }
  }

  // BinaryIntrinsics
  for (unsigned K = 0; K < X86IntrinBinOp::numOfX86Intrinsics; ++K) {
    // typecheck for return val
    X86IntrinBinOp::Op op = static_cast<X86IntrinBinOp::Op>(K);
    if (config::disable_avx512 && SIMDBinOpInst::is512(op))
      continue;
    type ret_ty = getIntrinsicRetTy(op);
    type op0_ty = getIntrinsicOp0Ty(op);
    type op1_ty = getIntrinsicOp1Ty(op);

    if (!ret_ty.same_width(expected))
      continue;

    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
        if (dynamic_cast<ReservedConst *>(*Op0) &&
            dynamic_cast<ReservedConst *>(*Op1))
          continue;

        Value *I = nullptr;
        set<ReservedConst*> RCs;

        if (auto L = dynamic_cast<Var *> (*Op0)) {
          // typecheck for op0
          if (!L->getType().same_width(op0_ty))
            continue;
          I = L;
        } else if (dynamic_cast<ReservedConst *>(*Op0)) {
          auto T = make_unique<ReservedConst>(op0_ty);
          I = T.get();
          RCs.insert(T.get());
          exprs.emplace_back(std::move(T));
        }
        Value *J = nullptr;
        if (auto R = dynamic_cast<Var *>(*Op1)) {
          // typecheck for op1
          if (!R->getType().same_width(op1_ty))
            continue;
          J = R;
        } else if (dynamic_cast<ReservedConst *>(*Op1)) {
          auto T = make_unique<ReservedConst>(op1_ty);
          J = T.get();
          RCs.insert(T.get());
          exprs.emplace_back(std::move(T));
        }
        auto B = make_unique<SIMDBinOpInst>(op, *I, *J);
        sketches.push_back(make_pair(B.get(), std::move(RCs)));
        exprs.emplace_back(std::move(B));
      }
    }
  }
  // shufflevector
  for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
    // skip (sv rc, *, mask)
    if (dynamic_cast<ReservedConst *>(*Op0))
      continue;

    type op_ty = (*Op0)->getType();

    auto tys = getIntegerVectorTypes(expected.getWidth());
    for (auto ty : tys) {
      type mask_ty = type(ty.getLane(), 8, false);
      if (op_ty.getWidth() % ty.getBits())
        continue;
      if (op_ty.getWidth() == ty.getBits())
        continue;
      // (sv var, poison, mask)
      {
        set<ReservedConst*> RCs;
        auto m = make_unique<ReservedConst>(mask_ty);
        RCs.insert(m.get());
        auto sv = make_unique<FakeShuffleInst>(**Op0, nullptr, *m.get(), ty);
        exprs.emplace_back(std::move(m));
        sketches.push_back(make_pair(sv.get(), std::move(RCs)));
        exprs.emplace_back(std::move(sv));
      }
      // (sv var1, var2, mask)
      for (auto Op1 = Op0 + 1; Op1 != Comps.end(); ++Op1) {
        set<ReservedConst*> RCs;
        Value *J = nullptr;
        if (auto R = dynamic_cast<Var *>(*Op1)) {
          // typecheck for op1
          if (!op_ty.same_width(R->getType()))
            continue;
          J = R;
        } else if (dynamic_cast<ReservedConst *>(*Op1)) {
          type op_ty =
            type((*Op0)->getType().getWidth() / ty.getBits(), ty.getBits(), false);
          auto T = make_unique<ReservedConst>(op_ty);
          J = T.get();
          RCs.insert(T.get());
          exprs.emplace_back(std::move(T));
        }
        auto m = make_unique<ReservedConst>(mask_ty);
        RCs.insert(m.get());
        auto sv2 = make_unique<FakeShuffleInst>(**Op0, J, *m.get(), ty);
        exprs.emplace_back(std::move(m));
        sketches.push_back(make_pair(sv2.get(), std::move(RCs)));
        exprs.emplace_back(std::move(sv2));
      }
    }
  }
  return true;
}

using Candidate = tuple<llvm::Function*, llvm::Function*, Inst*,
                        unordered_map<const llvm::Argument*, ReservedConst*>,
                        bool>;

static bool approx(const Candidate &f1, const Candidate &f2){
  return get_approx_cost(get<0>(f1)) < get_approx_cost(get<0>(f2));
}

optional<Rewrite> Enumerator::synthesize(llvm::Function &F) {
  unsigned REWRITES = 0;
  unsigned PRUNED = 0;

  assert (!V->getType()->isPointerTy() && "pointer arith is not supported");


  debug() << "[enumerator] working on slice\n" << F << "\n";


  clock_t start = std::clock();

  llvm::DominatorTree DT(F);
  DT.recalculate(F);

  std::unordered_set<llvm::Function *> IntrinsicDecls;

  unsigned src_cost = get_approx_cost(&F);

  llvm::DataLayout DL = F.getParent()->getDataLayout();

  llvm::Triple Triple = llvm::Triple(F.getParent()->getTargetTriple());
  llvm::TargetLibraryInfoWrapperPass TLI(Triple);

  AliveEngine AE(TLI);

  unsigned machinecost = get_machine_cost(&F) + 1;

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
    if (I->getType()->isIntOrIntVectorTy())
      computeKnownBits(I, KnownI, DL);

    findInputs(F, I, DT);

    vector<Sketch> Sketches;

    // immediate constant synthesis
    {
      set<ReservedConst*> RCs;
      auto RC = make_unique<ReservedConst>(type(I->getType()));
      auto CI = make_unique<Copy>(*RC.get());
      RCs.insert(RC.get());
      Sketches.push_back(make_pair(CI.get(), std::move(RCs)));
      exprs.emplace_back(std::move(CI));
      exprs.emplace_back(std::move(RC));
    }
    // nops
    {
      for (auto &V : values) {
        auto vty = V->V()->getType();
        if (vty->isPointerTy())
          continue;
        if (V->getType().getWidth() != I->getType()->getPrimitiveSizeInBits())
          continue;
        set<ReservedConst*> RCs;
        auto VA = make_unique<Var>(V->V());
        Sketches.push_back(make_pair(VA.get(), std::move(RCs)));
        exprs.emplace_back(std::move(VA));
      }
    }

    getSketches(&*I, Sketches);
    debug() << "[enumerator] listing sketches\n";
    for (auto &Sketch : Sketches) {
      if(config::debug_enumerator) cerr << *Sketch.first << "\n";
    }

    unsigned CI = 0;

    vector<Candidate> Fns;
    auto FT = F.getFunctionType();
    // sketches -> llvm functions

    for (auto &Sketch : Sketches) {
      bool HaveC = !Sketch.second.empty();
      auto &G = Sketch.first;
      llvm::ValueToValueMapTy VMap;

      llvm::SmallVector<llvm::Type*, 8> Args;
      for (auto I: FT->params()) {
        Args.push_back(I);
      }
      for (auto &C : Sketch.second) {
        Args.push_back(C->getType().toLLVM(F.getContext()));
      }

      auto _functionType =
        llvm::FunctionType::get(FT->getReturnType(), Args, FT->isVarArg());

      llvm::Function *Tgt =
        llvm::Function::Create(_functionType, F.getLinkage(),
                               F.getName(), F.getParent());


      llvm::Function::arg_iterator TgtArgI = Tgt->arg_begin();

      for (auto I = F.arg_begin(), E = F.arg_end(); I != E; ++I, ++TgtArgI) {
        VMap[I] = TgtArgI;
        TgtArgI->setName(I->getName());
      }

      unordered_map<const llvm::Argument*, ReservedConst*> ArgConst;
      // sketches with constants, duplicate F
      for (auto &C : Sketch.second) {
        string arg_name = "_reservedc_" + std::to_string(CI);
        TgtArgI->setName(arg_name);
        C->setA(TgtArgI);
        ArgConst[TgtArgI] = C;
        ++CI;
        ++TgtArgI;
      }

      llvm::SmallVector<llvm::ReturnInst*, 8> _returns;
      llvm::CloneFunctionInto(Tgt, &F, VMap,
        llvm::CloneFunctionChangeType::LocalChangesOnly, _returns);

      llvm::Function *Src;
      if (HaveC) {
        llvm::ValueToValueMapTy _vs;
        Src = llvm::CloneFunction(Tgt, _vs);
      } else {
        Src = &F;
      }

      llvm::Instruction *PrevI = llvm::cast<llvm::Instruction>(VMap[&*I]);
      ConstMap _consts;
      Rewrite R{*Tgt, G, _consts};
      llvm::Value *V =
         LLVMGen(PrevI, IntrinsicDecls).codeGen(R, VMap);
      V = llvm::IRBuilder<>(PrevI).CreateBitCast(V, PrevI->getType());
      PrevI->replaceAllUsesWith(V);

      eliminate_dead_code(*Tgt);
      unsigned tgt_cost = get_approx_cost(Tgt);

      ++REWRITES;

      bool skip = false;
      string err;
      llvm::raw_string_ostream err_stream(err);
      bool illformed = llvm::verifyFunction(*Tgt, &err_stream);
      llvm::KnownBits KnownV(Width);

      if (illformed) {
        llvm::errs()<<"Error tgt found: "<<err<<"\n";
        Tgt->dump();
        skip = true;
        goto push;
      }

      if (I->getType()->isIntOrIntVectorTy()) {
        computeKnownBits(V, KnownV, DL);

        if ((KnownV.Zero & KnownI.One) != 0 || (KnownV.One & KnownI.Zero) != 0) {
          skip = true;
          ++PRUNED;
          goto push;
        }
      }

      // check cost
      if (tgt_cost >= src_cost) {
        skip = true;
        goto push;
      }
push:
      if (skip) {
        Tgt->eraseFromParent();
        if (HaveC)
          Src->eraseFromParent();
      } else {
        Fns.push_back(make_tuple(Tgt, Src, G, ArgConst, !Sketch.second.empty()));
      }
    }
    std::stable_sort(Fns.begin(), Fns.end(), approx);
    // llvm functions -> alive2 functions
    auto iter = Fns.begin();
    Inst *R;
    bool success = false;
    ConstMap Consts;
    for (;iter != Fns.end();) {
      auto &[Tgt, Src, G, ArgConst, HaveC] = *iter;
      unsigned tgt_cost = get_approx_cost(Tgt);
      debug() << "[enumerator] approx_cost(tgt) = " << tgt_cost
              << ", approx_cost(src) = " << src_cost <<"\n";
      debug() << *Tgt;

      bool Good = false;
      unordered_map<const llvm::Argument*, llvm::Constant*> ConstantResults;

      try {
        if (!HaveC) {
          Good = AE.compareFunctions(*Src, *Tgt);
        } else {
          Good = AE.constantSynthesis(*Src, *Tgt, ConstantResults);
        }
      } catch (AliveException E) {
        debug() << E.msg << "\n";
        if (E.msg == "slow vcgen") {
          continue;
        }
      }

      if (Good) {
        R = G;
        if (HaveC) {
          for (auto &[A, C] : ConstantResults) {
            Consts[ArgConst[A]] = C;
          }
        }
        success = true;
      }

      if (HaveC)
        Src->eraseFromParent();
      Tgt->eraseFromParent();

      iter = Fns.erase(iter);

      unsigned Duration = ( std::clock() - start ) / CLOCKS_PER_SEC;
      if (Good || Duration > 120) {
        break;
      }
    }

    for (;iter != Fns.end(); ++iter) {
      auto &[Tgt, Src, _, __, HaveC] = *iter;
      if (HaveC)
        Src->eraseFromParent();
      Tgt->eraseFromParent();
    }

    debug() <<"[enumerator] rewrites,"<< REWRITES << ",pruned," << PRUNED << "\n";

    // replace
    if (success) {
      debug() << "[enumerator] original ir (uops=" <<machinecost<<")\n"
              << F << "\n";

      llvm::ValueToValueMapTy VMap;
      Rewrite r = {F, R, Consts};
      llvm::Value *V = LLVMGen(&*I, IntrinsicDecls).codeGen(r, VMap);
      V = llvm::IRBuilder<>(I).CreateBitCast(V, I->getType());
      I->replaceAllUsesWith(V);
      unsigned newcost = get_machine_cost(&F);

      debug() << "[enumerator] optimized ir (uops=" << newcost << ")\n"
              << F << "\n";

      if (config::ignore_machine_cost ||
          !machinecost || !newcost || newcost <= machinecost) {
        removeUnusedDecls(IntrinsicDecls);
        debug () << "[enumerator] successfully synthesized rhs\n";
        return {{F, R, Consts, machinecost, newcost}};
      } else {
        debug() <<  "[enumerator] !!! discard !!!\n";
        return nullopt;
      }
    }
  }
  return nullopt;
}

};
