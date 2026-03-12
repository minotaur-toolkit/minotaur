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

#include "util/compiler.h"
#include "llvm_util/llvm2alive.h"
#include "llvm_util/utils.h"

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
#include <chrono>
#include <memory>
#include <vector>
#include <set>

using namespace tools;
using namespace util;
using namespace std;
using namespace IR;

namespace minotaur {

using debug = config::DebugStream<
    &config::debug_enumerator>;

void Enumerator::findInputs(llvm::Function &F,
                            llvm::Instruction *root,
                            llvm::DominatorTree &DT) {
  for (auto &A : F.args()) {
    auto T = make_unique<Var>(&A);
    values.emplace_back(T.get());
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
      values.emplace_back(T.get());
      exprs.emplace_back(std::move(T));
    }
  }
}

bool Enumerator::getSketches(llvm::Value *V, vector<Sketch> &sketches) {
  vector<Value*> Comps(values.begin(), values.end());

  type expected{V->getType()};

  // casts
  for (auto Comp : Comps) {
    auto Op = dynamic_cast<Var*>(Comp);
    if (!Op)
      continue;

    unsigned op_w = Op->getType().getWidth();
    if (Op->getType().same_width(expected))
      continue;

    vector<type> tys = getIntegerVectorTypes(Op->getType());
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
        auto SI = make_unique<IntConversion>(IntConversion::sext, *Op, lane,
                                             op_bits, nb);
        sketches.push_back(make_pair(SI.get(), std::move(RCs1)));
        exprs.emplace_back(std::move(SI));
        set<ReservedConst*> RCs2;
        auto ZI = make_unique<IntConversion>(IntConversion::zext, *Op, lane,
                                             op_bits, nb);
        sketches.push_back(make_pair(ZI.get(), std::move(RCs2)));
        exprs.emplace_back(std::move(ZI));
      } else if (expected.getWidth() < op_w) {
        if (op_w % expected.getWidth() != 0)
          continue;

        unsigned nb = expected.getWidth() * op_bits / op_w;
        if (nb == 0)
          continue;
        set<ReservedConst*> RCs1;
        auto SI = make_unique<IntConversion>(IntConversion::trunc, *Op, lane,
                                             op_bits, nb);
        sketches.push_back(make_pair(SI.get(), std::move(RCs1)));
        exprs.emplace_back(std::move(SI));
      }
    }
  }

  for (auto Comp : Comps) {
    auto Op = dynamic_cast<Var*>(Comp);
    if (!Op)
      continue;

    auto op_ty = Op->getType();
    if (expected.isFP() && op_ty.isFP()) {
      if (expected.getLane() != op_ty.getLane())
        continue;
      if (expected.getBits() > op_ty.getBits()) {
        set<ReservedConst*> RCs;
        auto SI = make_unique<FPConversion>(FPConversion::fpext, *Op, expected);
        sketches.push_back(make_pair(SI.get(), std::move(RCs)));
        exprs.emplace_back(std::move(SI));
      } else if (expected.getBits() < op_ty.getBits()) {
        set<ReservedConst*> RCs;
        auto SI = make_unique<FPConversion>(FPConversion::fptrunc, *Op, expected);
        sketches.push_back(make_pair(SI.get(), std::move(RCs)));
        exprs.emplace_back(std::move(SI));
      }
    }

    if (expected.isFP() ^ op_ty.isFP()) {
      if (op_ty.isFP()) {
        if (expected.getWidth() % op_ty.getLane())
          continue;
        set<ReservedConst*> RCs;
        auto SI = make_unique<FPConversion>(FPConversion::fptosi, *Op, expected);
        sketches.push_back(make_pair(SI.get(), std::move(RCs)));
        exprs.emplace_back(std::move(SI));
        set<ReservedConst*> RCs2;
        auto UI = make_unique<FPConversion>(FPConversion::fptoui, *Op, expected);
        sketches.push_back(make_pair(UI.get(), std::move(RCs2)));
        exprs.emplace_back(std::move(UI));
      } else if (expected.isFP()) {
        if (op_ty.getWidth() % expected.getLane())
          continue;
        set<ReservedConst*> RCs;
        auto SI = make_unique<FPConversion>(FPConversion::uitofp, *Op, expected);
        sketches.push_back(make_pair(SI.get(), std::move(RCs)));
        exprs.emplace_back(std::move(SI));
        set<ReservedConst*> RCs2;
        auto UI = make_unique<FPConversion>(FPConversion::sitofp, *Op, expected);
        sketches.push_back(make_pair(UI.get(), std::move(RCs2)));
        exprs.emplace_back(std::move(UI));
      }
    }
  }

  // unop
  for (auto Op0 : Comps) {
    if (!expected.same_width(Op0->getType()))
      continue;
    for (unsigned K = UnaryOp::bitreverse; K <= UnaryOp::ftrunc; ++K) {
      UnaryOp::Op opcode = static_cast<UnaryOp::Op>(K);
      vector<type> tys = getUnaryOpWorkTypes(expected, opcode);

      for (auto workty : tys) {
        set<ReservedConst*> RCs;
        auto U = make_unique<UnaryOp>(opcode, *Op0, workty);
        sketches.push_back(make_pair(U.get(), std::move(RCs)));
        exprs.emplace_back(std::move(U));
      }
    }
  }

  // extractelement
  for (auto Op0 : Comps) {
    auto op0_ty = Op0->getType();
    if (op0_ty.getWidth() <= expected.getWidth())
      continue;
    if (op0_ty.getWidth() % expected.getWidth())
      continue;
    if (op0_ty.isFP() ^ expected.isFP())
      continue;
    if (op0_ty.isFP()) {
      if (expected.getLane() != 1)
        continue;
      if (op0_ty.getBits() != expected.getBits())
        continue;
    }

    auto T = make_unique<ReservedConst>(type::Integer(16));
    ReservedConst *idx = T.get();
    auto ety = type::Scalar(expected.getWidth(), expected.isFP());
    set<ReservedConst*> RCs;
    RCs.insert(T.get());
    exprs.emplace_back(std::move(T));
    auto EE = make_unique<ExtractElement>(*Op0, *idx, ety);
    sketches.push_back(make_pair(EE.get(), std::move(RCs)));
    exprs.emplace_back(std::move(EE));
  }

  auto RC1 = make_unique<ReservedConst>(type::Null());
  Comps.emplace_back(RC1.get());

  // binop
  for (unsigned K = BinaryOp::band; K <= BinaryOp::copysign; ++K) {
    BinaryOp::Op Op = static_cast<BinaryOp::Op>(K);

    if (expected.getBits() == 1 && !BinaryOp::isLogical(Op)) {
      continue;
    }

    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {

      auto Op1 = Comps.begin();
      if (K == BinaryOp::Op::mul || K == BinaryOp::Op::fmul)
        Op1 = Op0;
      else if (BinaryOp::isCommutative(Op))
        Op1 = Op0 + 1;

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
            } else continue;
          }
          // (op var, rc), for commutative operations, rc is always in rhs
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

  //icmps
  if (expected.getWidth() <= 64) {
    unsigned lanes = expected.getWidth();
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
        // skip (icmp op, op)
        if (Op0 == Op1)
          continue;
        // skip (icmp rc1, rc2)
        if (dynamic_cast<ReservedConst*>(*Op0) &&
            dynamic_cast<ReservedConst*>(*Op1))
          continue;
        // skip (icmp rc, var)
        if (dynamic_cast<ReservedConst*>(*Op0) && dynamic_cast<Var*>(*Op1))
          continue;

        //icmps
        for (unsigned C = ICmp::Cond::eq; C <= ICmp::Cond::sge; ++C) {
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
              auto jty = type::IntegerVectorizable(lanes, elem_bits);
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
        if (Op0 == Op1)
          continue;
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

        if (!I->getType().isFP())
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

  // insertelement
  for (auto Op0 : Comps) {
    for (auto Op1 : Comps) {
      if (dynamic_cast<ReservedConst*>(Op1)) {
        Value *V = Op0;
        auto v_ty = Op0->getType();
        if (v_ty.getWidth() != expected.getWidth())
          continue;
        auto worktys = getInsertElementWorkTypes(expected);
        for (auto ty : worktys) {
          set<ReservedConst*> RCs;
          auto T1 = make_unique<ReservedConst>(ty.getAsScalar());
          Value *Elm = T1.get();
          RCs.insert(T1.get());
          exprs.emplace_back(std::move(T1));

          auto T2 = make_unique<ReservedConst>(type::Integer(16));
          ReservedConst *idx = T2.get();
          RCs.insert(T2.get());
          exprs.emplace_back(std::move(T2));
          auto IE = make_unique<InsertElement>(*V, *Elm, *idx, ty);
          sketches.push_back(make_pair(IE.get(), std::move(RCs)));
          exprs.emplace_back(std::move(IE));
        }
      } else {
        Value *V = Op0, *Elm = Op1;
        set<ReservedConst*> RCs;
        if (dynamic_cast<ReservedConst*>(Op0)) {
          auto T = make_unique<ReservedConst>(expected);
          V = T.get();
          RCs.insert(T.get());
          exprs.emplace_back(std::move(T));
        }
        type v_ty = V->getType();
        type elm_ty = Elm->getType();

        if (v_ty.getWidth() != expected.getWidth())
          continue;
        if (elm_ty.getWidth() >= v_ty.getWidth())
          continue;
        if (v_ty.getWidth() % elm_ty.getWidth())
          continue;
        if (elm_ty.getWidth() < 8)
          continue;
        if (v_ty.isFP() ^ elm_ty.isFP())
          continue;
        if (elm_ty.isFP()) {
          if (elm_ty.getLane() != 1)
            continue;
          if (v_ty.getBits() != elm_ty.getBits())
            continue;
        } else {
          auto lane = v_ty.getWidth() / elm_ty.getWidth();
          auto bits = elm_ty.getWidth();
          v_ty = type::IntegerVectorizable(lane, bits);
          elm_ty = type::Integer(bits);
        }

        auto T = make_unique<ReservedConst>(type::Integer(16));
        ReservedConst *idx = T.get();
        RCs.insert(T.get());
        exprs.emplace_back(std::move(T));
        auto IE = make_unique<InsertElement>(*V, *Elm, *idx, elm_ty);
        sketches.push_back(make_pair(IE.get(), std::move(RCs)));
        exprs.emplace_back(std::move(IE));
      }
    }
  }

  for (unsigned K = 0; K < numOfX86BinOpIntrinsics; ++K) {
    if (expected.isFP())
      continue;
    // typecheck for return val
    X86IntrinBinOp::Op op = static_cast<X86IntrinBinOp::Op>(K);
    if (config::disable_avx512 && SIMDBinOpInst::is512Bit(op))
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

    //skip if expected and op_ty are not both fp or int
    if (expected.isFP() ^ op_ty.isFP())
      continue;

    auto tys = getShuffleWorkTypes(expected);
    for (auto ty : tys) {
      if (ty.getLane() == 1)
        continue;
      type mask_ty = type::IntegerVectorizable(ty.getLane(), 32);


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
          unsigned lanes = (*Op0)->getType().getWidth() / ty.getBits();
          type op_ty = type::IntegerVectorizable(lanes, ty.getBits());
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

  // adding new reserved constants for ternary operators
  auto RC2 = make_unique<ReservedConst>(type::Null());
  Comps.emplace_back(RC2.get());

  // select (i1, op, op)
  for (auto Op0 : Comps) {
    for (auto Op1 : Comps) {
      if (Op0 == Op1)
        continue;
      type op0_ty = Op0->getType(), op1_ty = Op1->getType();
      if (expected.isFP()) {
        // exact match for FP operations
        if (op0_ty.isValid() && op0_ty != expected)
          continue;
        if (op1_ty.isValid() && op1_ty != expected)
          continue;
      } else {
        // for integer operations, only check width match
        if (op0_ty.isValid() && !op0_ty.same_width(expected))
          continue;
        if (op1_ty.isValid() && !op1_ty.same_width(expected))
          continue;
      }

      for (auto Cond : Comps) {
        if (dynamic_cast<ReservedConst*>(Cond))
          continue;

        if (!Cond->getType().isBool())
          continue;

        set<ReservedConst*> RCs;
        Value *I = nullptr, *J = nullptr;

        if (dynamic_cast<ReservedConst*>(Op0)) {
          if (Op0 != RC1.get())
            continue;
          auto T = make_unique<ReservedConst>(expected);
          RCs.insert(T.get());
          I = T.get();
          exprs.emplace_back(std::move(T));
        } else {
          I = Op0;
        }

        if (dynamic_cast<ReservedConst*>(Op1)) {
          if (Op1 != RC2.get())
            continue;
          auto T = make_unique<ReservedConst>(expected);
          RCs.insert(T.get());
          J = T.get();
          exprs.emplace_back(std::move(T));
        } else {
          J = Op1;
        }

        auto s = make_unique<Select>(*Cond, *I, *J);
        sketches.push_back(make_pair(s.get(), std::move(RCs)));
        exprs.emplace_back(std::move(s));
      }
    }
  }

  return true;
}

// Depth-2 enumeration: compose two operations.
// Uses bottom-up strategy from equality saturation:
// 1. Build depth-1 "inner" expressions from input vars
// 2. Feed them as operands into a second layer of ops
// 3. Prune aggressively: only same-width types, skip
//    redundant compositions (e.g., add(add(x,c1),c2))
bool Enumerator::getDepth2Sketches(
    llvm::Value *V, vector<Sketch> &sketches) {
  type expected{V->getType()};

  // Only do depth-2 for integer scalar/vector types
  // where bit tricks are most profitable.
  if (expected.isFP())
    return true;

  // Step 1: build depth-1 inner expressions (var op var)
  // and (var op const) that match the expected width.
  struct InnerExpr {
    Value *expr;
    set<ReservedConst*> rcs;
  };
  vector<InnerExpr> inners;

  // Inner unary ops on each var
  for (auto *V : values) {
    if (!V->getType().same_width(expected))
      continue;
    for (unsigned K = UnaryOp::bitreverse;
         K <= UnaryOp::cttz; ++K) {
      UnaryOp::Op op = static_cast<UnaryOp::Op>(K);
      auto tys = getUnaryOpWorkTypes(expected, op);
      for (auto &workty : tys) {
        auto U = make_unique<UnaryOp>(op, *V, workty);
        inners.push_back({U.get(), {}});
        exprs.emplace_back(std::move(U));
      }
    }
  }

  // Inner binary ops: (var op var)
  for (unsigned K = BinaryOp::band;
       K <= BinaryOp::shl; ++K) {
    BinaryOp::Op op = static_cast<BinaryOp::Op>(K);
    if (expected.getBits() == 1 && !BinaryOp::isLogical(op))
      continue;
    auto worktys = getBinaryOpWorkTypes(expected, op);
    for (auto &workty : worktys) {
      for (auto *Op0 : values) {
        if (!expected.same_width(Op0->getType()))
          continue;
        for (auto *Op1 : values) {
          if (!expected.same_width(Op1->getType()))
            continue;
          if (BinaryOp::isCommutative(op) && Op1 < Op0)
            continue;
          auto B = make_unique<BinaryOp>(
              op, *Op0, *Op1, workty);
          inners.push_back({B.get(), {}});
          exprs.emplace_back(std::move(B));
        }
      }
    }
  }

  // Inner binary ops: (var op const)
  for (unsigned K = BinaryOp::band;
       K <= BinaryOp::shl; ++K) {
    BinaryOp::Op op = static_cast<BinaryOp::Op>(K);
    if (op == BinaryOp::sub)
      continue; // sub x, c == add x, -c
    if (expected.getBits() == 1 && !BinaryOp::isLogical(op))
      continue;
    auto worktys = getBinaryOpWorkTypes(expected, op);
    for (auto &workty : worktys) {
      for (auto *Op0 : values) {
        if (!expected.same_width(Op0->getType()))
          continue;
        auto RC = make_unique<ReservedConst>(workty);
        set<ReservedConst*> rcs;
        rcs.insert(RC.get());
        auto B = make_unique<BinaryOp>(
            op, *Op0, *RC, workty);
        inners.push_back({B.get(), std::move(rcs)});
        exprs.emplace_back(std::move(RC));
        exprs.emplace_back(std::move(B));
      }
    }
  }

  debug() << "[enumerator] depth-2: " << inners.size()
          << " inner expressions\n";

  // Step 2: compose — apply a second operation layer.
  // outer_op(inner, var) and outer_op(inner, const)
  // Limit: only integer non-FP binary ops as outer.
  for (auto &inner : inners) {
    for (unsigned K = BinaryOp::band;
         K <= BinaryOp::shl; ++K) {
      BinaryOp::Op op = static_cast<BinaryOp::Op>(K);
      if (expected.getBits() == 1 &&
          !BinaryOp::isLogical(op))
        continue;
      auto worktys = getBinaryOpWorkTypes(expected, op);
      for (auto &workty : worktys) {
        // outer_op(inner, var)
        for (auto *V : values) {
          if (!expected.same_width(V->getType()))
            continue;
          set<ReservedConst*> rcs(inner.rcs);
          auto B = make_unique<BinaryOp>(
              op, *inner.expr, *V, workty);
          sketches.push_back({B.get(), std::move(rcs)});
          exprs.emplace_back(std::move(B));
        }
        // outer_op(inner, const) — skip if inner already
        // has a const (avoids double-constant sketches
        // which are hard for the solver)
        if (inner.rcs.empty()) {
          for (auto *V : values) {
            if (!expected.same_width(V->getType()))
              continue;
            auto RC = make_unique<ReservedConst>(workty);
            set<ReservedConst*> rcs;
            rcs.insert(RC.get());
            auto B = make_unique<BinaryOp>(
                op, *inner.expr, *RC, workty);
            sketches.push_back(
                {B.get(), std::move(rcs)});
            exprs.emplace_back(std::move(RC));
            exprs.emplace_back(std::move(B));
          }
        }
      }
    }
  }

  // Also: unary(inner) compositions — e.g. ctpop(and(x,y))
  for (auto &inner : inners) {
    if (!inner.rcs.empty())
      continue; // skip const-bearing inners
    for (unsigned K = UnaryOp::bitreverse;
         K <= UnaryOp::cttz; ++K) {
      UnaryOp::Op op = static_cast<UnaryOp::Op>(K);
      auto tys = getUnaryOpWorkTypes(expected, op);
      for (auto &workty : tys) {
        set<ReservedConst*> rcs;
        auto U = make_unique<UnaryOp>(
            op, *inner.expr, workty);
        sketches.push_back({U.get(), std::move(rcs)});
        exprs.emplace_back(std::move(U));
      }
    }
  }

  return true;
}

using Candidate = tuple<llvm::Function*, llvm::Function*, Inst*,
                        unordered_map<const llvm::Argument*, ReservedConst*>,
                        bool>;

static bool approx(const Candidate &f1, const Candidate &f2) {
  return get_approx_cost(get<0>(f1)) < get_approx_cost(get<0>(f2));
}

vector<Rewrite> Enumerator::solve(llvm::Function &F, llvm::Instruction *I) {
  unsigned CANDIDATES = 0, PRUNED = 0, GOOD = 0;
  vector<Rewrite> ret;

  debug() << "[enumerator] working on slice\n" << F << "\n";

  auto start = std::chrono::steady_clock::now();

  llvm::DominatorTree DT(F);
  DT.recalculate(F);

  std::unordered_set<llvm::Function *> IntrinsicDecls;

  unsigned src_cost = get_approx_cost(&F);

  llvm::DataLayout DL = F.getParent()->getDataLayout();

  llvm::Triple Triple = llvm::Triple(F.getParent()->getTargetTriple());
  llvm::TargetLibraryInfoWrapperPass TLI(Triple);

  unsigned costBefore = get_machine_cost(&F);

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
      if (V->getType().getWidth() != I->getType()->getPrimitiveSizeInBits())
        continue;
      set<ReservedConst*> RCs;
      auto VA = make_unique<Var>(V->getValue());
      Sketches.push_back(make_pair(VA.get(), std::move(RCs)));
      exprs.emplace_back(std::move(VA));
    }
  }

  getSketches(&*I, Sketches);
  unsigned depth1_count = Sketches.size();
  getDepth2Sketches(&*I, Sketches);
  debug() << "[enumerator] " << depth1_count
          << " depth-1 + "
          << (Sketches.size() - depth1_count)
          << " depth-2 sketches\n";
  for (auto &Sketch : Sketches) {
    debug() << *Sketch.first << "\n";
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
    for (auto A: FT->params()) {
      Args.push_back(A);
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

    for (auto A = F.arg_begin(), E = F.arg_end(); A != E; ++A, ++TgtArgI) {
      VMap[A] = TgtArgI;
      TgtArgI->setName(A->getName());
    }

    unordered_map<const llvm::Argument*, ReservedConst*> ArgConst;
    // sketches with constants, duplicate F
    for (auto &C : Sketch.second) {
      string arg_name = "_reservedc_" + std::to_string(CI);
      TgtArgI->setName(arg_name);
      C->setArg(TgtArgI);
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
    llvm::Value *V =
        LLVMGen(PrevI, IntrinsicDecls).codeGen(G, VMap);
    V = llvm::IRBuilder<>(PrevI).CreateBitCast(V, PrevI->getType());
    PrevI->replaceAllUsesWith(V);

    eliminate_dead_code(*Tgt);
    unsigned tgt_cost = get_approx_cost(Tgt);

    ++CANDIDATES;

    string err;
    llvm::raw_string_ostream err_stream(err);
    bool illformed = llvm::verifyFunction(*Tgt, &err_stream);

    bool skip = false;
    if (illformed) {
      debug() << "Error tgt found: " << err
              << "\n" << *Tgt;
      skip = true;
    } else if (tgt_cost >= src_cost) {
      skip = true;
    }

    // Dataflow pruning: use KnownBits to reject
    // candidates that are provably inequivalent.
    // Compare structural known bits of src vs tgt
    // return values.
    if (!skip && !HaveC &&
        I->getType()->isIntOrIntVectorTy()) {
      llvm::Value *SrcRV = nullptr, *TgtRV = nullptr;
      for (auto &BB : *Src)
        if (auto *RI = dyn_cast<llvm::ReturnInst>(
                BB.getTerminator())) {
          SrcRV = RI->getReturnValue();
          break;
        }
      for (auto &BB : *Tgt)
        if (auto *RI = dyn_cast<llvm::ReturnInst>(
                BB.getTerminator())) {
          TgtRV = RI->getReturnValue();
          break;
        }
      if (SrcRV && TgtRV &&
          SrcRV->getType()->isIntOrIntVectorTy() &&
          TgtRV->getType()->isIntOrIntVectorTy()) {
        llvm::KnownBits KBSrc(Width);
        llvm::KnownBits KBTgt(Width);
        computeKnownBits(SrcRV, KBSrc, DL);
        computeKnownBits(TgtRV, KBTgt, DL);
        if ((KBSrc.One & KBTgt.Zero).getBoolValue() ||
            (KBSrc.Zero & KBTgt.One).getBoolValue()) {
          debug()
              << "[enumerator] dataflow pruned\n";
          skip = true;
          PRUNED++;
        }
      }
    }

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

  for (;iter != Fns.end();) {
    auto &[Tgt, Src, G, ArgConst, HaveC] = *iter;
    unsigned tgt_cost = get_approx_cost(Tgt);
    debug() << "[enumerator] approx_cost(tgt) = " << tgt_cost
            << ", approx_cost(src) = " << src_cost <<"\n";
    debug() << *Tgt;

    bool Good = false;
    unordered_map<llvm::Argument*, llvm::Constant*> ConstantResults;

    try {
      if (!HaveC) {
        AliveEngine AE(TLI);
        Good = AE.compareFunctions(*Src, *Tgt);
      } else {
        AliveEngine AE(TLI);
        Good = AE.constantSynthesis(*Src, *Tgt, ConstantResults);
      }
    } catch (const AliveException &E) {
      debug() << E.msg << "\n";
      // "slow vcgen" means the candidate is too complex to verify quickly;
      // fall through to cleanup and try the next candidate.
    }
    if (Good) {
      GOOD ++;
      Inst *R = G;
      if (HaveC) {
        for (auto &[A, C] : ConstantResults) {
          ArgConst[A]->setConst(C);
          A->replaceAllUsesWith(C);
        }
      }

      // rewrite fksv calls to shufflevector
      for (auto &BB : *Tgt) {
        for (auto &I : make_early_inc_range(BB)) {
          if (!isa<llvm::CallInst>(&I))
            continue;
          auto CI = llvm::cast<llvm::CallInst>(&I);

          auto callee = CI->getCalledFunction();
          if (!callee)
            continue;
          if (!callee->getName().starts_with("__fksv"))
            continue;

          auto shuf = new llvm::ShuffleVectorInst(CI->getArgOperand(0),
                                                  CI->getArgOperand(1),
                                                  CI->getArgOperand(2), "",
                                                  CI->getIterator());
          CI->replaceAllUsesWith(shuf);
          CI->eraseFromParent();
        }
      }

      unsigned costAfter = get_machine_cost(Tgt);

      debug() << "[enumerator] optimized ir (uops=" << costAfter <<")"
              << ", original cost (uops=" << costBefore << "), \n"
              << *Tgt << "\n";

      if (!costAfter || !costBefore) {
        debug() << "[enumerator] cost is zero, skip\n";
      } else if (config::ignore_machine_cost || costAfter < costBefore) {
        debug () << "[enumerator] successfully synthesized rhs\n";
        ret.emplace_back(R, costAfter, costBefore);
      } else {
        debug() << "[enumerator] successfully synthesized rhs, "
                << "however, rhs is more expensive than lhs\n";
      }
    }

    if (HaveC)
      Src->eraseFromParent();
    Tgt->eraseFromParent();

    iter = Fns.erase(iter);

    unsigned Duration = std::chrono::duration_cast<std::chrono::seconds>(
        std::chrono::steady_clock::now() - start).count();
    if ((config::return_first_solution && Good)) {
      debug() << "[enumerator] returning first solution\n";
      break;
    }
    if (Duration > config::slice_to) {
      debug() << "[enumerator] timeout for candidate, skipping\n";
      break;
    }
  }

  for (;iter != Fns.end(); ++iter) {
    auto &[Tgt, Src, _, __, HaveC] = *iter;
    if (HaveC)
      Src->eraseFromParent();
    Tgt->eraseFromParent();
  }

  debug() << "[enumerator] #Candidates = " << CANDIDATES
          << ", #Pruned = " << PRUNED
          << ", #Good = " << GOOD << "\n";

  std::stable_sort(ret.begin(), ret.end(),
    [](const Rewrite &a, const Rewrite &b) {
      return a.CostAfter < b.CostAfter;
    });

  for (auto &R : ret) {
    debug() << "[enumerator] rewrite: " << *R.I
            << ", cost="<<  R.CostAfter << "\n";
  }

  removeUnusedDecls(IntrinsicDecls);
  return ret;
}

};
