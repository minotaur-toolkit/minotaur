// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "alive-interface.h"
#include "config.h"
#include "enumerator.h"
#include "expr.h"
#include "fp-domain.h"
#include "codegen.h"
#include "cost.h"
#include "interp.h"
#include "rewrite-ordering.h"
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
#include "llvm/Analysis/ConstantFolding.h"
#include "llvm/Support/KnownBits.h"

#include <algorithm>
#include <chrono>
#include <map>
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

namespace {

constexpr BinaryOp::Op DeepBinaryOps[] = {
  BinaryOp::band,
  BinaryOp::bor,
  BinaryOp::bxor,
  BinaryOp::lshr,
  BinaryOp::ashr,
  BinaryOp::shl,
  BinaryOp::umax,
  BinaryOp::umin,
  BinaryOp::smax,
  BinaryOp::smin,
};

constexpr BinaryOp::Op DeepCompareBinaryOps[] = {
  BinaryOp::band,
  BinaryOp::bor,
  BinaryOp::bxor,
  BinaryOp::add,
  BinaryOp::sub,
  BinaryOp::mul,
  BinaryOp::sdiv,
  BinaryOp::udiv,
  BinaryOp::lshr,
  BinaryOp::ashr,
  BinaryOp::shl,
  BinaryOp::umax,
  BinaryOp::umin,
  BinaryOp::smax,
  BinaryOp::smin,
};

struct VectorReduceFamily {
  VectorReduce::Op reduce_op;
  BinaryOp::Op inner_op;
};

constexpr VectorReduce::Op VectorReduceOps[] = {
  VectorReduce::add,
  VectorReduce::mul,
  VectorReduce::band,
  VectorReduce::bor,
  VectorReduce::bxor,
};

constexpr VectorReduceFamily VectorReduceFamilies[] = {
  {VectorReduce::add,  BinaryOp::add},
  {VectorReduce::mul,  BinaryOp::mul},
  {VectorReduce::band, BinaryOp::band},
  {VectorReduce::bor,  BinaryOp::bor},
  {VectorReduce::bxor, BinaryOp::bxor},
};

constexpr bool supportsSameSign(ICmp::Cond Cond) {
  switch (Cond) {
  case ICmp::ult:
  case ICmp::ule:
  case ICmp::ugt:
  case ICmp::uge:
  case ICmp::slt:
  case ICmp::sle:
  case ICmp::sgt:
  case ICmp::sge:
    return true;
  case ICmp::eq:
  case ICmp::ne:
    return false;
  }
  return false;
}

template <typename Fn>
void forEachICmpVariant(Fn &&fn) {
  for (unsigned C = ICmp::Cond::eq; C <= ICmp::Cond::sge; ++C) {
    ICmp::Cond Cond = static_cast<ICmp::Cond>(C);
    fn(Cond, false);
    if (supportsSameSign(Cond))
      fn(Cond, true);
  }
}

} // namespace

void Enumerator::findInputs(llvm::Function &F,
                            llvm::Instruction *root,
                            llvm::DominatorTree &DT) {
  for (auto &A : F.args()) {
    if (A.use_empty())
      continue;
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

  // vector_reduce_*
  if (!expected.isFP() && expected.getLane() == 1) {
    unsigned expected_bits = expected.getWidth();
    if (expected_bits == 8 || expected_bits == 16 ||
        expected_bits == 32 || expected_bits == 64) {
      for (auto Op0 : Comps) {
        auto op0_ty = Op0->getType();
        if (op0_ty.isFP())
          continue;
        if (op0_ty.getLane() <= 1)
          continue;
        if (op0_ty.getBits() != expected_bits)
          continue;

        for (auto reduce_op : VectorReduceOps) {
          set<ReservedConst*> RCs;
          auto VR = make_unique<VectorReduce>(reduce_op, *Op0, op0_ty);
          sketches.push_back(make_pair(VR.get(), std::move(RCs)));
          exprs.emplace_back(std::move(VR));
        }
      }
    }
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

        // icmps
        forEachICmpVariant([&](ICmp::Cond Cond, bool SameSign) {
          set<ReservedConst*> RCs;
          Value *I = nullptr, *J = nullptr;

          if (auto L = dynamic_cast<Var*>(*Op0)) {
            if (L->getType().getWidth() % expected.getWidth())
              return;

            unsigned elem_bits = L->getType().getWidth() / lanes;
            if (elem_bits != 8 && elem_bits != 16 &&
                elem_bits != 32 && elem_bits != 64)
              return;
            // (icmp var, rc)
            if (dynamic_cast<ReservedConst*>(*Op1)) {
              if (Cond == ICmp::sle || Cond == ICmp::ule)
                return;
              I = L;
              auto jty = type::IntegerVectorizable(lanes, elem_bits);
              auto T = make_unique<ReservedConst>(jty);
              J = T.get();
              RCs.insert(T.get());
              exprs.emplace_back(std::move(T));
            // (icmp var, var)
            } else if (auto R = dynamic_cast<Var*>(*Op1)) {
              if (L->getType().getWidth() != R->getType().getWidth())
                return;
              I = *Op0;
              J = *Op1;
            } else UNREACHABLE();
          } else UNREACHABLE();
          auto BO = make_unique<ICmp>(Cond, *I, *J, lanes, SameSign);
          sketches.push_back(make_pair(BO.get(), std::move(RCs)));
          exprs.emplace_back(std::move(BO));
        });
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

  // For scalar i1 roots, deeper opportunities are usually
  // compare-over-arithmetic shapes rather than boolean-only trees.
  if (expected.getWidth() == 1) {
    struct InnerExpr {
      Value *expr;
      set<ReservedConst*> rcs;
    };

    auto isScalarInt = [](const type &ty) {
      if (ty.isFP() || ty.getLane() != 1)
        return false;
      unsigned w = ty.getWidth();
      return w == 8 || w == 16 || w == 32 || w == 64;
    };
    auto isScalarIntSource = [](const type &ty) {
      if (ty.isFP() || ty.getLane() != 1)
        return false;
      unsigned w = ty.getWidth();
      return w == 1 || w == 8 || w == 16 || w == 32 || w == 64;
    };

    map<unsigned, vector<Value*>> leaves_by_bits;
    for (auto *Value : values) {
      if (!isScalarInt(Value->getType()))
        continue;
      leaves_by_bits[Value->getType().getWidth()].push_back(Value);
    }

    for (auto &[bits, leaves] : leaves_by_bits) {
      type target_ty = type::Integer(bits);
      vector<InnerExpr> inners;

      for (auto *Leaf : leaves) {
        for (unsigned K = UnaryOp::bitreverse;
             K <= UnaryOp::cttz; ++K) {
          UnaryOp::Op op = static_cast<UnaryOp::Op>(K);
          auto U = make_unique<UnaryOp>(op, *Leaf, target_ty);
          inners.push_back({U.get(), {}});
          exprs.emplace_back(std::move(U));
        }
      }

      for (auto *Value : values) {
        auto from_ty = Value->getType();
        if (!isScalarIntSource(from_ty) || from_ty.same_width(target_ty))
          continue;

        if (target_ty.getWidth() > from_ty.getWidth() &&
            target_ty.getWidth() % from_ty.getWidth() == 0) {
          auto SExt = make_unique<IntConversion>(
              IntConversion::sext, *Value, 1,
              from_ty.getBits(), target_ty.getBits());
          inners.push_back({SExt.get(), {}});
          exprs.emplace_back(std::move(SExt));

          auto ZExt = make_unique<IntConversion>(
              IntConversion::zext, *Value, 1,
              from_ty.getBits(), target_ty.getBits());
          inners.push_back({ZExt.get(), {}});
          exprs.emplace_back(std::move(ZExt));
        } else if (target_ty.getWidth() < from_ty.getWidth() &&
                   from_ty.getWidth() % target_ty.getWidth() == 0) {
          auto Trunc = make_unique<IntConversion>(
              IntConversion::trunc, *Value, 1,
              from_ty.getBits(), target_ty.getBits());
          inners.push_back({Trunc.get(), {}});
          exprs.emplace_back(std::move(Trunc));
        }
      }

      for (auto op : DeepCompareBinaryOps) {
        for (auto *Op0 : leaves) {
          for (auto *Op1 : leaves) {
            if (BinaryOp::isCommutative(op) && Op1 < Op0)
              continue;
            auto B = make_unique<BinaryOp>(
                op, *Op0, *Op1, target_ty);
            inners.push_back({B.get(), {}});
            exprs.emplace_back(std::move(B));
          }
        }
      }

      for (auto op : DeepCompareBinaryOps) {
        if (op == BinaryOp::sub)
          continue;
        for (auto *Op0 : leaves) {
          auto RC = make_unique<ReservedConst>(target_ty);
          set<ReservedConst*> rcs;
          rcs.insert(RC.get());
          auto B = make_unique<BinaryOp>(
              op, *Op0, *RC, target_ty);
          inners.push_back({B.get(), std::move(rcs)});
          exprs.emplace_back(std::move(RC));
          exprs.emplace_back(std::move(B));
        }
      }

      for (auto *Cond : values) {
        if (!Cond->getType().isBool())
          continue;
        for (auto *TrueV : leaves) {
          for (auto *FalseV : leaves) {
            if (TrueV == FalseV)
              continue;
            auto S = make_unique<Select>(*Cond, *TrueV, *FalseV);
            inners.push_back({S.get(), {}});
            exprs.emplace_back(std::move(S));
          }

          auto FalseRC = make_unique<ReservedConst>(target_ty);
          set<ReservedConst*> false_rcs;
          false_rcs.insert(FalseRC.get());
          auto FalseSel = make_unique<Select>(*Cond, *TrueV, *FalseRC);
          inners.push_back({FalseSel.get(), std::move(false_rcs)});
          exprs.emplace_back(std::move(FalseRC));
          exprs.emplace_back(std::move(FalseSel));

          auto TrueRC = make_unique<ReservedConst>(target_ty);
          set<ReservedConst*> true_rcs;
          true_rcs.insert(TrueRC.get());
          auto TrueSel = make_unique<Select>(*Cond, *TrueRC, *TrueV);
          inners.push_back({TrueSel.get(), std::move(true_rcs)});
          exprs.emplace_back(std::move(TrueRC));
          exprs.emplace_back(std::move(TrueSel));
        }
      }

      for (auto &inner : inners) {
        for (auto *Leaf : leaves) {
          forEachICmpVariant([&](ICmp::Cond Cond, bool SameSign) {
            {
              set<ReservedConst*> rcs(inner.rcs);
              auto Cmp = make_unique<ICmp>(
                  Cond, *inner.expr, *Leaf, 1, SameSign);
              sketches.push_back({Cmp.get(), std::move(rcs)});
              exprs.emplace_back(std::move(Cmp));
            }
            {
              set<ReservedConst*> rcs(inner.rcs);
              auto Cmp = make_unique<ICmp>(
                  Cond, *Leaf, *inner.expr, 1, SameSign);
              sketches.push_back({Cmp.get(), std::move(rcs)});
              exprs.emplace_back(std::move(Cmp));
            }
          });
        }

        if (!inner.rcs.empty())
          continue;

        forEachICmpVariant([&](ICmp::Cond Cond, bool SameSign) {
          if (Cond == ICmp::sle || Cond == ICmp::ule)
            return;

          auto RC = make_unique<ReservedConst>(target_ty);
          set<ReservedConst*> rcs;
          rcs.insert(RC.get());
          auto Cmp = make_unique<ICmp>(
              Cond, *inner.expr, *RC, 1, SameSign);
          sketches.push_back({Cmp.get(), std::move(rcs)});
          exprs.emplace_back(std::move(RC));
          exprs.emplace_back(std::move(Cmp));
        });
      }
    }

    return true;
  }

  if (expected.getLane() == 1) {
    unsigned expected_bits = expected.getWidth();
    if (expected_bits == 8 || expected_bits == 16 ||
        expected_bits == 32 || expected_bits == 64) {
      std::map<std::pair<unsigned, unsigned>, std::vector<Value*>> vector_leaves;
      for (auto *Leaf : values) {
        auto leaf_ty = Leaf->getType();
        if (leaf_ty.isFP() || leaf_ty.getLane() <= 1)
          continue;
        if (leaf_ty.getBits() != expected_bits)
          continue;
        vector_leaves[{leaf_ty.getLane(), leaf_ty.getBits()}].push_back(Leaf);
      }

      for (auto &[key, leaves] : vector_leaves) {
        type vec_ty = type::IntegerVectorizable(key.first, key.second);
        for (auto family : VectorReduceFamilies) {
          auto worktys = getBinaryOpWorkTypes(vec_ty, family.inner_op);
          for (auto &workty : worktys) {
            if (workty != vec_ty)
              continue;
            for (auto *Op0 : leaves) {
              for (auto *Op1 : leaves) {
                if (BinaryOp::isCommutative(family.inner_op) && Op1 < Op0)
                  continue;
                auto Inner = make_unique<BinaryOp>(
                    family.inner_op, *Op0, *Op1, workty);
                auto *InnerPtr = Inner.get();
                exprs.emplace_back(std::move(Inner));

                set<ReservedConst*> rcs;
                auto Reduce = make_unique<VectorReduce>(
                    family.reduce_op, *InnerPtr, vec_ty);
                sketches.push_back({Reduce.get(), std::move(rcs)});
                exprs.emplace_back(std::move(Reduce));
              }
            }
          }
        }
      }
    }
  }

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
  for (auto op : DeepBinaryOps) {
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
  for (auto op : DeepBinaryOps) {
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

  // Inner selects: select(cond, var, var/const)
  for (auto *Cond : values) {
    if (!Cond->getType().isBool())
      continue;
    for (auto *TrueV : values) {
      if (!expected.same_width(TrueV->getType()))
        continue;
      for (auto *FalseV : values) {
        if (!expected.same_width(FalseV->getType()))
          continue;
        if (TrueV == FalseV)
          continue;
        auto S = make_unique<Select>(*Cond, *TrueV, *FalseV);
        inners.push_back({S.get(), {}});
        exprs.emplace_back(std::move(S));
      }

      auto FalseRC = make_unique<ReservedConst>(expected);
      set<ReservedConst*> false_rcs;
      false_rcs.insert(FalseRC.get());
      auto FalseSel = make_unique<Select>(*Cond, *TrueV, *FalseRC);
      inners.push_back({FalseSel.get(), std::move(false_rcs)});
      exprs.emplace_back(std::move(FalseRC));
      exprs.emplace_back(std::move(FalseSel));

      auto TrueRC = make_unique<ReservedConst>(expected);
      set<ReservedConst*> true_rcs;
      true_rcs.insert(TrueRC.get());
      auto TrueSel = make_unique<Select>(*Cond, *TrueRC, *TrueV);
      inners.push_back({TrueSel.get(), std::move(true_rcs)});
      exprs.emplace_back(std::move(TrueRC));
      exprs.emplace_back(std::move(TrueSel));
    }
  }

  debug() << "[enumerator] depth-2: " << inners.size()
          << " inner expressions\n";

  // Step 2: compose — apply a second operation layer.
  // outer_op(inner, var) and outer_op(inner, const)
  // Limit: deep bitwise/minmax ops plus select.
  for (auto &inner : inners) {
    for (auto op : DeepBinaryOps) {
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

  // select(cond, inner, var/const) and select(cond, var/const, inner)
  for (auto &inner : inners) {
    for (auto *Cond : values) {
      if (!Cond->getType().isBool())
        continue;
      for (auto *V : values) {
        if (!expected.same_width(V->getType()))
          continue;
        {
          set<ReservedConst*> rcs(inner.rcs);
          auto S = make_unique<Select>(*Cond, *inner.expr, *V);
          sketches.push_back({S.get(), std::move(rcs)});
          exprs.emplace_back(std::move(S));
        }
        {
          set<ReservedConst*> rcs(inner.rcs);
          auto S = make_unique<Select>(*Cond, *V, *inner.expr);
          sketches.push_back({S.get(), std::move(rcs)});
          exprs.emplace_back(std::move(S));
        }
      }
      if (inner.rcs.empty()) {
        auto FalseRC = make_unique<ReservedConst>(expected);
        set<ReservedConst*> false_rcs;
        false_rcs.insert(FalseRC.get());
        auto FalseSel = make_unique<Select>(*Cond, *inner.expr, *FalseRC);
        sketches.push_back({FalseSel.get(), std::move(false_rcs)});
        exprs.emplace_back(std::move(FalseRC));
        exprs.emplace_back(std::move(FalseSel));

        auto TrueRC = make_unique<ReservedConst>(expected);
        set<ReservedConst*> true_rcs;
        true_rcs.insert(TrueRC.get());
        auto TrueSel = make_unique<Select>(*Cond, *TrueRC, *inner.expr);
        sketches.push_back({TrueSel.get(), std::move(true_rcs)});
        exprs.emplace_back(std::move(TrueRC));
        exprs.emplace_back(std::move(TrueSel));
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

// Depth-3 enumeration: compose three operations.
// Builds depth-2 expressions (deduped by fingerprint),
// then uses them as operands in a third layer.
bool Enumerator::getDepth3Sketches(
    llvm::Value *V, vector<Sketch> &sketches) {
  type expected{V->getType()};
  if (expected.isFP())
    return true;

  if (expected.getWidth() == 1) {
    static const uint64_t primes[] = {
      2, 3, 5, 7, 11, 13, 17, 19
    };
    static const uint64_t seeds[] = {
      0, 1, UINT64_MAX, 100,
    };
    constexpr unsigned nseeds =
        sizeof(seeds) / sizeof(seeds[0]);

    struct InnerExpr {
      Value *expr;
      set<ReservedConst*> rcs;
    };
    struct D2Expr {
      Value *expr;
      set<ReservedConst*> rcs;
    };

    auto isScalarInt = [](const type &ty) {
      if (ty.isFP() || ty.getLane() != 1)
        return false;
      unsigned w = ty.getWidth();
      return w == 8 || w == 16 || w == 32 || w == 64;
    };
    auto isScalarIntSource = [](const type &ty) {
      if (ty.isFP() || ty.getLane() != 1)
        return false;
      unsigned w = ty.getWidth();
      return w == 1 || w == 8 || w == 16 || w == 32 || w == 64;
    };

    map<unsigned, vector<Value*>> leaves_by_bits;
    for (auto *Value : values) {
      if (!isScalarInt(Value->getType()))
        continue;
      leaves_by_bits[Value->getType().getWidth()].push_back(Value);
    }

    for (auto &[bits, leaves] : leaves_by_bits) {
      type target_ty = type::Integer(bits);
      vector<InnerExpr> d1exprs;

      for (auto *Leaf : leaves) {
        for (unsigned K = UnaryOp::bitreverse;
             K <= UnaryOp::cttz; ++K) {
          UnaryOp::Op op = static_cast<UnaryOp::Op>(K);
          auto U = make_unique<UnaryOp>(op, *Leaf, target_ty);
          d1exprs.push_back({U.get(), {}});
          exprs.emplace_back(std::move(U));
        }
      }

      for (auto *Value : values) {
        auto from_ty = Value->getType();
        if (!isScalarIntSource(from_ty) || from_ty.same_width(target_ty))
          continue;

        if (target_ty.getWidth() > from_ty.getWidth() &&
            target_ty.getWidth() % from_ty.getWidth() == 0) {
          auto SExt = make_unique<IntConversion>(
              IntConversion::sext, *Value, 1,
              from_ty.getBits(), target_ty.getBits());
          d1exprs.push_back({SExt.get(), {}});
          exprs.emplace_back(std::move(SExt));

          auto ZExt = make_unique<IntConversion>(
              IntConversion::zext, *Value, 1,
              from_ty.getBits(), target_ty.getBits());
          d1exprs.push_back({ZExt.get(), {}});
          exprs.emplace_back(std::move(ZExt));
        } else if (target_ty.getWidth() < from_ty.getWidth() &&
                   from_ty.getWidth() % target_ty.getWidth() == 0) {
          auto Trunc = make_unique<IntConversion>(
              IntConversion::trunc, *Value, 1,
              from_ty.getBits(), target_ty.getBits());
          d1exprs.push_back({Trunc.get(), {}});
          exprs.emplace_back(std::move(Trunc));
        }
      }

      for (auto op : DeepCompareBinaryOps) {
        for (auto *Op0 : leaves) {
          for (auto *Op1 : leaves) {
            if (BinaryOp::isCommutative(op) && Op1 < Op0)
              continue;
            auto B = make_unique<BinaryOp>(
                op, *Op0, *Op1, target_ty);
            d1exprs.push_back({B.get(), {}});
            exprs.emplace_back(std::move(B));
          }
        }
      }

      for (auto op : DeepCompareBinaryOps) {
        if (op == BinaryOp::sub)
          continue;
        for (auto *Op0 : leaves) {
          auto RC = make_unique<ReservedConst>(target_ty);
          set<ReservedConst*> rcs;
          rcs.insert(RC.get());
          auto B = make_unique<BinaryOp>(
              op, *Op0, *RC, target_ty);
          d1exprs.push_back({B.get(), std::move(rcs)});
          exprs.emplace_back(std::move(RC));
          exprs.emplace_back(std::move(B));
        }
      }

      for (auto *Cond : values) {
        if (!Cond->getType().isBool())
          continue;
        for (auto *TrueV : leaves) {
          for (auto *FalseV : leaves) {
            if (TrueV == FalseV)
              continue;
            auto S = make_unique<Select>(*Cond, *TrueV, *FalseV);
            d1exprs.push_back({S.get(), {}});
            exprs.emplace_back(std::move(S));
          }

          auto FalseRC = make_unique<ReservedConst>(target_ty);
          set<ReservedConst*> false_rcs;
          false_rcs.insert(FalseRC.get());
          auto FalseSel = make_unique<Select>(*Cond, *TrueV, *FalseRC);
          d1exprs.push_back({FalseSel.get(), std::move(false_rcs)});
          exprs.emplace_back(std::move(FalseRC));
          exprs.emplace_back(std::move(FalseSel));

          auto TrueRC = make_unique<ReservedConst>(target_ty);
          set<ReservedConst*> true_rcs;
          true_rcs.insert(TrueRC.get());
          auto TrueSel = make_unique<Select>(*Cond, *TrueRC, *TrueV);
          d1exprs.push_back({TrueSel.get(), std::move(true_rcs)});
          exprs.emplace_back(std::move(TrueRC));
          exprs.emplace_back(std::move(TrueSel));
        }
      }

      vector<D2Expr> d2exprs;
      map<vector<uint64_t>, bool> d2seen;
      auto addDepth2Expr = [&](unique_ptr<Inst> I,
                               set<ReservedConst*> rcs) {
        Value *Expr = static_cast<Value*>(I.get());
        if (rcs.empty()) {
          vector<uint64_t> fp;
          bool ok = true;
          for (unsigned si = 0; si < nseeds; ++si) {
            Interpreter interp;
            unsigned vi = 0;
            for (auto *V : values) {
              unsigned w = V->getType().getWidth();
              uint64_t v = seeds[si] +
                  primes[vi % 8] * (vi + 1);
              if (w < 64)
                v &= (1ULL << w) - 1;
              interp.bind(V, llvm::APInt(w, v));
              vi++;
            }
            auto r = interp.eval(Expr);
            if (!r) {
              ok = false;
              break;
            }
            fp.push_back(r->getLimitedValue());
          }
          if (ok && !d2seen.count(fp)) {
            d2seen[fp] = true;
            d2exprs.push_back({Expr, {}});
          }
        } else {
          d2exprs.push_back({Expr, std::move(rcs)});
        }
        exprs.emplace_back(std::move(I));
      };

      for (auto &inner : d1exprs) {
        for (unsigned K = UnaryOp::bitreverse;
             K <= UnaryOp::cttz; ++K) {
          UnaryOp::Op op = static_cast<UnaryOp::Op>(K);
          auto U = make_unique<UnaryOp>(op, *inner.expr, target_ty);
          addDepth2Expr(std::move(U), set<ReservedConst*>(inner.rcs));
        }

        for (auto op : DeepCompareBinaryOps) {
          for (auto *Leaf : leaves) {
            {
              set<ReservedConst*> rcs(inner.rcs);
              auto B = make_unique<BinaryOp>(
                  op, *inner.expr, *Leaf, target_ty);
              addDepth2Expr(std::move(B), std::move(rcs));
            }
            {
              set<ReservedConst*> rcs(inner.rcs);
              auto B = make_unique<BinaryOp>(
                  op, *Leaf, *inner.expr, target_ty);
              addDepth2Expr(std::move(B), std::move(rcs));
            }
          }

          if (inner.rcs.empty() && op != BinaryOp::sub) {
            auto RC = make_unique<ReservedConst>(target_ty);
            set<ReservedConst*> rcs;
            rcs.insert(RC.get());
            auto B = make_unique<BinaryOp>(
                op, *inner.expr, *RC, target_ty);
            exprs.emplace_back(std::move(RC));
            addDepth2Expr(std::move(B), std::move(rcs));
          }
        }

        for (auto *Cond : values) {
          if (!Cond->getType().isBool())
            continue;
          for (auto *Leaf : leaves) {
            {
              set<ReservedConst*> rcs(inner.rcs);
              auto S = make_unique<Select>(*Cond, *inner.expr, *Leaf);
              addDepth2Expr(std::move(S), std::move(rcs));
            }
            {
              set<ReservedConst*> rcs(inner.rcs);
              auto S = make_unique<Select>(*Cond, *Leaf, *inner.expr);
              addDepth2Expr(std::move(S), std::move(rcs));
            }
          }

          if (inner.rcs.empty()) {
            auto FalseRC = make_unique<ReservedConst>(target_ty);
            set<ReservedConst*> false_rcs;
            false_rcs.insert(FalseRC.get());
            auto FalseSel = make_unique<Select>(
                *Cond, *inner.expr, *FalseRC);
            exprs.emplace_back(std::move(FalseRC));
            addDepth2Expr(std::move(FalseSel), std::move(false_rcs));

            auto TrueRC = make_unique<ReservedConst>(target_ty);
            set<ReservedConst*> true_rcs;
            true_rcs.insert(TrueRC.get());
            auto TrueSel = make_unique<Select>(
                *Cond, *TrueRC, *inner.expr);
            exprs.emplace_back(std::move(TrueRC));
            addDepth2Expr(std::move(TrueSel), std::move(true_rcs));
          }
        }
      }

      for (auto &d2 : d2exprs) {
        for (auto *Leaf : leaves) {
          forEachICmpVariant([&](ICmp::Cond Cond, bool SameSign) {
            {
              set<ReservedConst*> rcs(d2.rcs);
              auto Cmp = make_unique<ICmp>(
                  Cond, *d2.expr, *Leaf, 1, SameSign);
              sketches.push_back({Cmp.get(), std::move(rcs)});
              exprs.emplace_back(std::move(Cmp));
            }
            {
              set<ReservedConst*> rcs(d2.rcs);
              auto Cmp = make_unique<ICmp>(
                  Cond, *Leaf, *d2.expr, 1, SameSign);
              sketches.push_back({Cmp.get(), std::move(rcs)});
              exprs.emplace_back(std::move(Cmp));
            }
          });
        }

        if (!d2.rcs.empty())
          continue;

        forEachICmpVariant([&](ICmp::Cond Cond, bool SameSign) {
          if (Cond == ICmp::sle || Cond == ICmp::ule)
            return;

          auto RC = make_unique<ReservedConst>(target_ty);
          set<ReservedConst*> rcs;
          rcs.insert(RC.get());
          auto Cmp = make_unique<ICmp>(
              Cond, *d2.expr, *RC, 1, SameSign);
          sketches.push_back({Cmp.get(), std::move(rcs)});
          exprs.emplace_back(std::move(RC));
          exprs.emplace_back(std::move(Cmp));
        });
      }
    }

    return true;
  }

  if (expected.getLane() == 1) {
    unsigned expected_bits = expected.getWidth();
    if (expected_bits == 8 || expected_bits == 16 ||
        expected_bits == 32 || expected_bits == 64) {
      std::map<std::pair<unsigned, unsigned>, std::vector<Value*>> vector_leaves;
      for (auto *Leaf : values) {
        auto leaf_ty = Leaf->getType();
        if (leaf_ty.isFP() || leaf_ty.getLane() <= 1)
          continue;
        if (leaf_ty.getBits() != expected_bits)
          continue;
        vector_leaves[{leaf_ty.getLane(), leaf_ty.getBits()}].push_back(Leaf);
      }

      for (auto &[key, leaves] : vector_leaves) {
        type vec_ty = type::IntegerVectorizable(key.first, key.second);
        for (auto family : VectorReduceFamilies) {
          auto worktys = getBinaryOpWorkTypes(vec_ty, family.inner_op);
          for (auto &workty : worktys) {
            if (workty != vec_ty)
              continue;

            std::vector<Value*> d2exprs;
            for (auto *Op0 : leaves) {
              for (auto *Op1 : leaves) {
                if (BinaryOp::isCommutative(family.inner_op) && Op1 < Op0)
                  continue;
                auto D2 = make_unique<BinaryOp>(
                    family.inner_op, *Op0, *Op1, workty);
                d2exprs.push_back(D2.get());
                exprs.emplace_back(std::move(D2));
              }
            }

            for (auto *D2 : d2exprs) {
              for (auto *Leaf : leaves) {
                auto D3 = make_unique<BinaryOp>(
                    family.inner_op, *D2, *Leaf, workty);
                auto *D3Ptr = D3.get();
                exprs.emplace_back(std::move(D3));

                set<ReservedConst*> rcs;
                auto Reduce = make_unique<VectorReduce>(
                    family.reduce_op, *D3Ptr, vec_ty);
                sketches.push_back({Reduce.get(), std::move(rcs)});
                exprs.emplace_back(std::move(Reduce));
              }
            }
          }
        }
      }
    }
  }

  // Only worthwhile for types with enough entropy
  // for fingerprint dedup to be reliable.
  if (expected.getWidth() <= 32)
    return true;

  static const uint64_t primes[] = {
    2, 3, 5, 7, 11, 13, 17, 19
  };
  static const uint64_t seeds[] = {
    0, 1, UINT64_MAX, 100,
  };
  constexpr unsigned nseeds =
      sizeof(seeds) / sizeof(seeds[0]);

  // Step 1: build depth-2 inner expressions (var op var)
  // then dedup by fingerprint.
  struct D2Expr {
    Value *expr;
    vector<uint64_t> fingerprint;
  };
  vector<D2Expr> d2exprs;
  map<vector<uint64_t>, bool> d2seen;

  auto addDepth2Expr = [&](unique_ptr<Inst> I) {
    Value *Expr = static_cast<Value*>(I.get());
    vector<uint64_t> fp;
    bool ok = true;
    for (unsigned si = 0; si < nseeds; ++si) {
      Interpreter interp;
      unsigned vi = 0;
      for (auto *V : values) {
        unsigned w = V->getType().getWidth();
        uint64_t v = seeds[si] +
            primes[vi % 8] * (vi + 1);
        if (w < 64)
          v &= (1ULL << w) - 1;
        interp.bind(V, llvm::APInt(w, v));
        vi++;
      }
      auto r = interp.eval(Expr);
      if (!r) {
        ok = false;
        break;
      }
      fp.push_back(r->getLimitedValue());
    }
    if (ok && !d2seen.count(fp)) {
      d2seen[fp] = true;
      d2exprs.push_back(D2Expr{Expr, std::move(fp)});
    }
    exprs.emplace_back(std::move(I));
  };

  // Generate depth-1 inner ops (vars + unary(var))
  vector<Value*> d1vars;
  for (auto *V : values) {
    if (!V->getType().same_width(expected))
      continue;
    d1vars.push_back(V);
  }
  vector<Value*> d1exprs(d1vars);
  for (auto *Op0 : d1vars) {
    for (unsigned K = UnaryOp::bitreverse;
         K <= UnaryOp::cttz; ++K) {
      UnaryOp::Op op = static_cast<UnaryOp::Op>(K);
      auto tys = getUnaryOpWorkTypes(expected, op);
      for (auto &workty : tys) {
        auto U = make_unique<UnaryOp>(
            op, *Op0, workty);
        d1exprs.push_back(U.get());
        exprs.emplace_back(std::move(U));
      }
    }
  }

  // Generate depth-2 by composing depth-1
  for (auto op : DeepBinaryOps) {
    if (expected.getBits() == 1 &&
        !BinaryOp::isLogical(op))
      continue;
    auto worktys = getBinaryOpWorkTypes(expected, op);
    for (auto &workty : worktys) {
      for (auto *Op0 : d1exprs) {
        if (!expected.same_width(Op0->getType()))
          continue;
        for (auto *Op1 : d1exprs) {
          if (!expected.same_width(Op1->getType()))
            continue;
          if (BinaryOp::isCommutative(op) && Op1 < Op0)
            continue;
          auto B = make_unique<BinaryOp>(op, *Op0, *Op1, workty);
          addDepth2Expr(std::move(B));
        }
      }
    }
  }

  // Generate depth-2 selects over depth-1 values/unary expressions.
  for (auto *Cond : values) {
    if (!Cond->getType().isBool())
      continue;
    for (auto *TrueV : d1exprs) {
      if (!expected.same_width(TrueV->getType()))
        continue;
      for (auto *FalseV : d1exprs) {
        if (!expected.same_width(FalseV->getType()))
          continue;
        if (TrueV == FalseV)
          continue;
        auto S = make_unique<Select>(*Cond, *TrueV, *FalseV);
        addDepth2Expr(std::move(S));
      }
    }
  }

  debug() << "[enumerator] depth-3: " << d2exprs.size()
          << " unique depth-2 inner expressions\n";

  // Step 2: compose depth-2 expressions into depth-3
  // outer_op(d2_expr, var) and outer_op(d2_expr, const)
  for (auto &d2 : d2exprs) {
    for (auto op : DeepBinaryOps) {
      if (expected.getBits() == 1 &&
          !BinaryOp::isLogical(op))
        continue;
      auto worktys = getBinaryOpWorkTypes(expected, op);
      for (auto &workty : worktys) {
        // d3 = outer_op(d2_expr, var)
        for (auto *V : values) {
          if (!expected.same_width(V->getType()))
            continue;
          set<ReservedConst*> rcs;
          auto B = make_unique<BinaryOp>(
              op, *d2.expr, *V, workty);
          sketches.push_back(
              {B.get(), std::move(rcs)});
          exprs.emplace_back(std::move(B));
        }
        // d3 = outer_op(d2_expr, const)
        auto RC = make_unique<ReservedConst>(workty);
        set<ReservedConst*> rcs;
        rcs.insert(RC.get());
        auto B = make_unique<BinaryOp>(
            op, *d2.expr, *RC, workty);
        sketches.push_back(
            {B.get(), std::move(rcs)});
        exprs.emplace_back(std::move(RC));
        exprs.emplace_back(std::move(B));
      }
    }

    for (auto *Cond : values) {
      if (!Cond->getType().isBool())
        continue;
      for (auto *V : values) {
        if (!expected.same_width(V->getType()))
          continue;
        {
          set<ReservedConst*> rcs;
          auto S = make_unique<Select>(*Cond, *d2.expr, *V);
          sketches.push_back({S.get(), std::move(rcs)});
          exprs.emplace_back(std::move(S));
        }
        {
          set<ReservedConst*> rcs;
          auto S = make_unique<Select>(*Cond, *V, *d2.expr);
          sketches.push_back({S.get(), std::move(rcs)});
          exprs.emplace_back(std::move(S));
        }
      }

      auto FalseRC = make_unique<ReservedConst>(expected);
      set<ReservedConst*> false_rcs;
      false_rcs.insert(FalseRC.get());
      auto FalseSel = make_unique<Select>(*Cond, *d2.expr, *FalseRC);
      sketches.push_back({FalseSel.get(), std::move(false_rcs)});
      exprs.emplace_back(std::move(FalseRC));
      exprs.emplace_back(std::move(FalseSel));

      auto TrueRC = make_unique<ReservedConst>(expected);
      set<ReservedConst*> true_rcs;
      true_rcs.insert(TrueRC.get());
      auto TrueSel = make_unique<Select>(*Cond, *TrueRC, *d2.expr);
      sketches.push_back({TrueSel.get(), std::move(true_rcs)});
      exprs.emplace_back(std::move(TrueRC));
      exprs.emplace_back(std::move(TrueSel));
    }
  }

  return true;
}

using Candidate = tuple<llvm::Function*, llvm::Function*, Inst*,
                        unordered_map<const llvm::Argument*, ReservedConst*>,
                        bool>;

static unsigned countUsedSourceArgs(const llvm::Function &F) {
  unsigned Count = 0;
  for (auto &A : F.args()) {
    if (!A.use_empty())
      ++Count;
  }
  return Count;
}

static bool approx(const Candidate &f1, const Candidate &f2) {
  auto ExpectedDistinctVars = countUsedSourceArgs(*get<1>(f1));
  SearchOrderingContext Ctx{ExpectedDistinctVars};
  if (preferInstForSearch(*get<2>(f1), *get<2>(f2), Ctx))
    return true;
  if (preferInstForSearch(*get<2>(f2), *get<2>(f1), Ctx))
    return false;

  unsigned cost1 = get_approx_cost(get<0>(f1));
  unsigned cost2 = get_approx_cost(get<0>(f2));
  if (cost1 != cost2)
    return cost1 < cost2;

  return false;
}

vector<string> Enumerator::enumerateSketchStringsForTesting(
    llvm::Function &F, llvm::Instruction *I,
    bool args_only, bool enable_depth2,
    bool enable_depth3) {
  values.clear();
  exprs.clear();

  if (args_only) {
    for (auto &A : F.args()) {
      auto T = make_unique<Var>(&A);
      values.emplace_back(T.get());
      exprs.emplace_back(std::move(T));
    }
  } else {
    llvm::DominatorTree DT(F);
    DT.recalculate(F);
    findInputs(F, I, DT);
  }

  vector<Sketch> Sketches;
  getSketches(&*I, Sketches);
  if (enable_depth2)
    getDepth2Sketches(&*I, Sketches);
  if (enable_depth3)
    getDepth3Sketches(&*I, Sketches);

  vector<string> Result;
  Result.reserve(Sketches.size());
  for (auto &[Sketch, _] : Sketches) {
    string S;
    llvm::raw_string_ostream OS(S);
    OS << *Sketch;
    OS.flush();
    Result.push_back(std::move(S));
  }
  return Result;
}

vector<Rewrite> Enumerator::solve(llvm::Function &F, llvm::Instruction *I) {
  unsigned CANDIDATES = 0, PRUNED = 0, GOOD = 0;
  unsigned APPROX_PRUNED = 0, ILLFORMED_PRUNED = 0;
  unsigned FP_DOMAIN_PRUNED = 0;
  unsigned VERIFY_EXCEPTIONS = 0;
  unsigned ZERO_COST_SKIPPED = 0;
  unsigned MACHINE_COST_REJECTED = 0;
  unsigned ACCEPTED = 0;
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

  unsigned costBefore =
      config::ignore_machine_cost ? src_cost : get_machine_cost(&F);

  unsigned Width = I->getType()->getScalarSizeInBits();
  llvm::KnownBits KnownI(Width);
  if (I->getType()->isIntOrIntVectorTy())
    computeKnownBits(I, KnownI, DL);
  FPValueDomain SourceFPDomain = analyzeFPValueDomain(*I);

  findInputs(F, I, DT);
  debug() << "[enumerator] root=" << *I
          << ", scalar_width=" << Width
          << ", input_leaves=" << values.size()
          << ", depth2=" << (config::enable_depth2 ? "on" : "off")
          << ", depth3=" << (config::enable_depth3 ? "on" : "off")
          << "\n";
  if (SourceFPDomain.IsFP) {
    debug() << "[enumerator] fp-domain: source origin="
            << (SourceFPDomain.mustBeSelector() ? "selector"
                : SourceFPDomain.mustBeFresh() ? "fresh"
                                               : "unknown")
            << ", leaves=" << SourceFPDomain.DistinctLeaves << "\n";
  }

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
  unsigned base_sketches = Sketches.size();
  unsigned depth2_sketches = 0, depth3_sketches = 0;
  if (config::enable_depth2) {
    unsigned before = Sketches.size();
    getDepth2Sketches(&*I, Sketches);
    depth2_sketches = Sketches.size() - before;
  }
  if (config::enable_depth3) {
    unsigned before = Sketches.size();
    getDepth3Sketches(&*I, Sketches);
    depth3_sketches = Sketches.size() - before;
  }
  debug() << "[enumerator] sketch counts: base=" << base_sketches
          << ", depth2=" << depth2_sketches
          << ", depth3=" << depth3_sketches
          << ", total=" << Sketches.size() << "\n";
  for (auto &Sketch : Sketches) {
    debug() << *Sketch.first << "\n";
  }

  // Early pruning via fingerprinting: evaluate each
  // sketch on test vectors at the AST level.
  // Sketches with identical fingerprints are
  // semantically equivalent — keep only the first.
  // For RC sketches: solve the constant from seed 0,
  // then fingerprint with that constant bound.
  unsigned EARLY_PRUNED = 0;
  if (I->getType()->isIntOrIntVectorTy() &&
      I->getType()->getPrimitiveSizeInBits() > 32) {
    static const uint64_t primes[] = {
      2, 3, 5, 7, 11, 13, 17, 19
    };
    static const uint64_t seeds[] = {
      0, 1, 2, 3, UINT64_MAX, UINT64_MAX - 1,
      100, 255, 0x8000000000000000ULL,
      0x5555555555555555ULL,
      0xAAAAAAAAAAAAAAAAULL, 42,
    };
    constexpr unsigned nseeds =
        sizeof(seeds) / sizeof(seeds[0]);

    auto bindVarsForSeed = [&](Interpreter &interp,
                               unsigned si) {
      unsigned vi = 0;
      for (auto *V : values) {
        unsigned w = V->getType().getWidth();
        uint64_t v = seeds[si] +
            primes[vi % 8] * (vi + 1);
        // Mask to bitwidth to avoid APInt assert
        if (w < 64)
          v &= (1ULL << w) - 1;
        interp.bind(V, llvm::APInt(w, v));
        vi++;
      }
    };

    map<vector<uint64_t>, unsigned> seen;
    auto it = Sketches.begin();
    while (it != Sketches.end()) {
      auto &[G, RCs] = *it;

      vector<uint64_t> fingerprint;
      bool ok = true;

      if (RCs.empty()) {
        // No reserved constants: direct eval
        for (unsigned si = 0; si < nseeds; ++si) {
          Interpreter interp;
          bindVarsForSeed(interp, si);
          auto r = interp.eval(G);
          if (!r) { ok = false; break; }
          // Use low 64 bits as fingerprint element
          fingerprint.push_back(
              r->getLimitedValue());
        }
      } else {
        // RC sketches: skip dedup for now.
        // The late-stage concrete pruning handles
        // these after LLVM function creation.
        ok = false;
      }

      if (ok && seen.count(fingerprint)) {
        it = Sketches.erase(it);
        EARLY_PRUNED++;
      } else {
        if (ok) seen[fingerprint] = 1;
        ++it;
      }
    }
  } else {
    debug() << "[enumerator] early dedup disabled for type "
            << *I->getType() << "\n";
  }
  debug() << "[enumerator] early dedup pruned "
          << EARLY_PRUNED << " sketches, remaining="
          << Sketches.size() << "\n";

  unsigned CI = 0;

  vector<Candidate> Fns;
  auto FT = F.getFunctionType();
  // sketches -> llvm functions

  for (auto &Sketch : Sketches) {
    bool HaveC = !Sketch.second.empty();
    auto &G = Sketch.first;
    auto TargetFPDomain = analyzeFPValueDomain(*G);
    if (fpDomainsContradict(SourceFPDomain, TargetFPDomain)) {
      FP_DOMAIN_PRUNED++;
      debug() << "[enumerator] skip candidate: fp-domain contradiction\n";
      continue;
    }
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
      ILLFORMED_PRUNED++;
      debug() << "Error tgt found: " << err
              << "\n" << *Tgt;
      skip = true;
    } else if (tgt_cost >= src_cost) {
      APPROX_PRUNED++;
      debug() << "[enumerator] skip candidate: approx_cost(tgt)="
              << tgt_cost << " >= approx_cost(src)="
              << src_cost << "\n";
      skip = true;
    }

    // Late-stage concrete pruning is disabled: the
    // source function often has control flow (switch,
    // phi) that ConstantFoldInstOperands can't handle.
    // The early fingerprint dedup handles the bulk of
    // redundancy elimination instead.
    if (false && !skip &&
        I->getType()->isIntOrIntVectorTy()) {
      // Each row is a base value; each variable gets
      // base + variable_index to ensure distinct vals.
      static const uint64_t bases[] = {
        0, 1, 3, 0x8000000000000000ULL,
        UINT64_MAX, 0x5555555555555555ULL,
        0xAAAAAAAAAAAAAAAAULL, 100,
      };
      constexpr unsigned nbases =
          sizeof(bases) / sizeof(bases[0]);

      // Check if Src is foldable: all int args AND
      // single basic block (no control flow).
      bool allIntArgs = true;
      for (auto &A : Src->args())
        if (!A.getType()->isIntegerTy()) {
          allIntArgs = false;
          break;
        }
      if (Src->size() != 1)
        allIntArgs = false;

      if (allIntArgs) {
        // Helper: fold source IR on a test vector
        auto foldSrc = [&](unsigned ti)
            -> optional<llvm::APInt> {
          llvm::DenseMap<llvm::Value*,
                         llvm::Constant*> vals;
          unsigned ai = 0;
          for (auto &A : Src->args()) {
            uint64_t v = bases[ti] + ai * 7 + ai;
            vals[&A] = llvm::ConstantInt::get(
                A.getType(), v);
            ai++;
          }
          for (auto &BB : *Src) {
            for (auto &Inst : BB) {
              if (auto *RI =
                  dyn_cast<llvm::ReturnInst>(&Inst)) {
                auto *RV = RI->getReturnValue();
                if (!RV) return nullopt;
                llvm::Constant *C = nullptr;
                if (auto *CC =
                    dyn_cast<llvm::Constant>(RV))
                  C = CC;
                else if (vals.count(RV))
                  C = vals[RV];
                if (!C) return nullopt;
                if (isa<llvm::PoisonValue>(C) ||
                    isa<llvm::UndefValue>(C))
                  return nullopt;
                if (auto *CI =
                    dyn_cast<llvm::ConstantInt>(C))
                  return CI->getValue();
                return nullopt;
              }
              llvm::SmallVector<llvm::Constant*, 4> ops;
              bool ok = true;
              for (auto &op : Inst.operands()) {
                if (auto *C =
                    dyn_cast<llvm::Constant>(op.get()))
                  ops.push_back(C);
                else if (vals.count(op.get()))
                  ops.push_back(vals[op.get()]);
                else { ok = false; break; }
              }
              if (!ok) return nullopt;
              auto *f = llvm::ConstantFoldInstOperands(
                  &Inst, ops, DL);
              if (!f) return nullopt;
              vals[&Inst] = f;
            }
          }
          return nullopt;
        };

        // Helper: bind vars for test vector ti
        auto bindVars = [&](Interpreter &interp,
                            unsigned ti) {
          unsigned vi = 0;
          for (auto *V : values) {
            unsigned w = V->getType().getWidth();
            uint64_t v = bases[ti] + vi * 7 + vi;
            interp.bind(V, llvm::APInt(w, v));
            vi++;
          }
        };

        bool pruned = false;

        if (!HaveC) {
          // No reserved constants: direct comparison
          for (unsigned ti = 0;
               ti < nbases && !pruned; ++ti) {
            Interpreter interp;
            bindVars(interp, ti);
            auto tgtR = interp.eval(G);
            if (!tgtR) break;
            auto srcR = foldSrc(ti);
            if (!srcR) break;
            if (*srcR != *tgtR) {
              pruned = true;
              PRUNED++;
            }
          }
        } else {
          // Has reserved constants: solve from first
          // test vector, verify on the rest.
          auto srcR0 = foldSrc(0);
          if (srcR0) {
            Interpreter interp0;
            bindVars(interp0, 0);
            unordered_map<ReservedConst*,
                          llvm::APInt> solved;
            bool canSolve =
                interp0.solveForConstants(
                    G, *srcR0, solved);
            if (canSolve && !solved.empty()) {
              // Verify solved constants on remaining
              // test vectors
              for (unsigned ti = 1;
                   ti < nbases && !pruned; ++ti) {
                auto srcR = foldSrc(ti);
                if (!srcR) break;
                Interpreter interp;
                bindVars(interp, ti);
                // Bind solved constants
                for (auto &[rc, val] : solved)
                  interp.bind(rc, val);
                auto tgtR = interp.eval(G);
                if (!tgtR) break;
                if (*srcR != *tgtR) {
                  pruned = true;
                  PRUNED++;
                }
              }
            }
          }
        }
        if (pruned) skip = true;
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
  unsigned VerifiedCandidates = 0;
  const unsigned TotalQueued = Fns.size();

  for (;iter != Fns.end();) {
    auto &[Tgt, Src, G, ArgConst, HaveC] = *iter;
    ++VerifiedCandidates;
    unsigned tgt_cost = get_approx_cost(Tgt);
    debug() << "[enumerator] candidate " << VerifiedCandidates
            << "/" << TotalQueued
            << ": approx_cost(tgt) = " << tgt_cost
            << ", approx_cost(src) = " << src_cost <<"\n";
    debug() << *Tgt;

    bool Good = false;
    unordered_map<llvm::Argument*, llvm::Constant*> ConstantResults;

    try {
      if (!HaveC) {
        switch (classifyFPTransportRelation(*I, *G)) {
        case FPTransportRelation::Equivalent:
          debug() << "[enumerator] accepted by fp transport proof\n";
          Good = true;
          break;
        case FPTransportRelation::Inequivalent:
          debug() << "[enumerator] rejected by fp transport proof\n";
          Good = false;
          break;
        case FPTransportRelation::Unknown: {
          AliveEngine AE(TLI);
          Good = AE.compareFunctions(*Src, *Tgt);
          break;
        }
        }
      } else {
        AliveEngine AE(TLI);
        Good = AE.constantSynthesis(*Src, *Tgt, ConstantResults);
      }
    } catch (const AliveException &E) {
      VERIFY_EXCEPTIONS++;
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

      unsigned costAfter =
          config::ignore_machine_cost ? tgt_cost : get_machine_cost(Tgt);

      debug() << "[enumerator] optimized ir (uops=" << costAfter <<")"
              << ", original cost (uops=" << costBefore << "), \n"
              << *Tgt << "\n";

      if (!costAfter || !costBefore) {
        ZERO_COST_SKIPPED++;
        debug() << "[enumerator] cost is zero, skip\n";
      } else if (config::ignore_machine_cost || costAfter < costBefore) {
        debug () << "[enumerator] successfully synthesized rhs\n";
        ret.emplace_back(R, costAfter, costBefore);
        ACCEPTED++;
      } else {
        MACHINE_COST_REJECTED++;
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

  auto DurationMs = std::chrono::duration_cast<
      std::chrono::milliseconds>(
          std::chrono::steady_clock::now() - start).count();
  debug() << "[enumerator] summary: candidates=" << CANDIDATES
          << ", approx_pruned=" << APPROX_PRUNED
          << ", illformed_pruned=" << ILLFORMED_PRUNED
          << ", fp_domain_pruned=" << FP_DOMAIN_PRUNED
          << ", concrete_pruned=" << PRUNED
          << ", verified_equiv=" << GOOD
          << ", verify_exceptions=" << VERIFY_EXCEPTIONS
          << ", machine_cost_rejected=" << MACHINE_COST_REJECTED
          << ", zero_cost_skipped=" << ZERO_COST_SKIPPED
          << ", accepted=" << ACCEPTED
          << ", elapsed_ms=" << DurationMs << "\n";

  std::stable_sort(ret.begin(), ret.end(),
    [](const Rewrite &a, const Rewrite &b) {
      if (a.CostAfter != b.CostAfter)
        return a.CostAfter < b.CostAfter;

      return preferInstForSameCost(*a.I, *b.I);
    });

  for (auto &R : ret) {
    debug() << "[enumerator] rewrite: " << *R.I
            << ", cost="<<  R.CostAfter << "\n";
  }

  removeUnusedDecls(IntrinsicDecls);
  return ret;
}

};
