// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "interp.h"
#include "expr.h"

#include "llvm/ADT/APInt.h"

using namespace llvm;
using namespace std;

namespace minotaur {

optional<APInt> Interpreter::eval(Inst *I) {
  return evalImpl(I);
}

optional<APInt> Interpreter::evalImpl(Inst *I) {
  if (auto *V = dynamic_cast<Var*>(I)) {
    auto it = env.find(V);
    if (it != env.end())
      return it->second;
    return nullopt;
  }

  if (auto *RC = dynamic_cast<ReservedConst*>(I)) {
    // If the constant is already known, use it.
    if (auto *CI = dyn_cast_or_null<ConstantInt>(
            RC->getConst())) {
      return CI->getValue();
    }
    // Unknown constant — can't evaluate.
    return nullopt;
  }

  if (auto *C = dynamic_cast<Copy*>(I)) {
    return evalImpl(C->getReservedConst());
  }

  if (auto *U = dynamic_cast<UnaryOp*>(I)) {
    auto op0 = evalImpl(U->getOperand());
    if (!op0) return nullopt;
    unsigned w = op0->getBitWidth();

    switch (U->getOpcode()) {
    case UnaryOp::bitreverse:
      return op0->reverseBits();
    case UnaryOp::bswap:
      return op0->byteSwap();
    case UnaryOp::ctpop:
      return APInt(w, op0->popcount());
    case UnaryOp::ctlz:
      return APInt(w, op0->countl_zero());
    case UnaryOp::cttz:
      return APInt(w, op0->countr_zero());
    default:
      // FP unary ops not supported in concrete eval
      return nullopt;
    }
  }

  if (auto *B = dynamic_cast<BinaryOp*>(I)) {
    auto lhs = evalImpl(B->getLHS());
    auto rhs = evalImpl(B->getRHS());
    if (!lhs || !rhs) return nullopt;

    // Width-match: extend or truncate to work type
    unsigned w = B->getWorkTy().getWidth();
    if (lhs->getBitWidth() != w)
      *lhs = lhs->zextOrTrunc(w);
    if (rhs->getBitWidth() != w)
      *rhs = rhs->zextOrTrunc(w);

    switch (B->getOpcode()) {
    case BinaryOp::band: return *lhs & *rhs;
    case BinaryOp::bor:  return *lhs | *rhs;
    case BinaryOp::bxor: return *lhs ^ *rhs;
    case BinaryOp::add:  return *lhs + *rhs;
    case BinaryOp::sub:  return *lhs - *rhs;
    case BinaryOp::mul:  return *lhs * *rhs;
    case BinaryOp::lshr: return lhs->lshr(*rhs);
    case BinaryOp::ashr: return lhs->ashr(*rhs);
    case BinaryOp::shl:  return lhs->shl(*rhs);
    case BinaryOp::udiv:
      if (rhs->isZero()) return nullopt;
      return lhs->udiv(*rhs);
    case BinaryOp::sdiv:
      if (rhs->isZero()) return nullopt;
      return lhs->sdiv(*rhs);
    case BinaryOp::umax:
      return lhs->ugt(*rhs) ? *lhs : *rhs;
    case BinaryOp::umin:
      return lhs->ult(*rhs) ? *lhs : *rhs;
    case BinaryOp::smax:
      return lhs->sgt(*rhs) ? *lhs : *rhs;
    case BinaryOp::smin:
      return lhs->slt(*rhs) ? *lhs : *rhs;
    default:
      // FP binary ops not supported
      return nullopt;
    }
  }

  if (auto *IC = dynamic_cast<ICmp*>(I)) {
    auto lhs = evalImpl(IC->getLHS());
    auto rhs = evalImpl(IC->getRHS());
    if (!lhs || !rhs) return nullopt;

    unsigned bits = IC->getBits();
    if (lhs->getBitWidth() != bits)
      *lhs = lhs->zextOrTrunc(bits);
    if (rhs->getBitWidth() != bits)
      *rhs = rhs->zextOrTrunc(bits);

    if (IC->hasSameSign()) {
      if (IC->getLanes() != 1)
        return nullopt;
      bool lhs_sign = lhs->isNegative();
      bool rhs_sign = rhs->isNegative();
      if (lhs_sign != rhs_sign)
        return nullopt;
    }

    bool result;
    switch (IC->getCond()) {
    case ICmp::eq:  result = *lhs == *rhs; break;
    case ICmp::ne:  result = *lhs != *rhs; break;
    case ICmp::ult: result = lhs->ult(*rhs); break;
    case ICmp::ule: result = lhs->ule(*rhs); break;
    case ICmp::ugt: result = lhs->ugt(*rhs); break;
    case ICmp::uge: result = lhs->uge(*rhs); break;
    case ICmp::slt: result = lhs->slt(*rhs); break;
    case ICmp::sle: result = lhs->sle(*rhs); break;
    case ICmp::sgt: result = lhs->sgt(*rhs); break;
    case ICmp::sge: result = lhs->sge(*rhs); break;
    }
    return APInt(1, result ? 1 : 0);
  }

  if (auto *S = dynamic_cast<Select*>(I)) {
    auto cond = evalImpl(S->getCond());
    auto lhs = evalImpl(S->getLHS());
    auto rhs = evalImpl(S->getRHS());
    if (!cond || !lhs || !rhs) return nullopt;
    return cond->getBoolValue() ? *lhs : *rhs;
  }

  if (auto *CI = dynamic_cast<IntConversion*>(I)) {
    auto op = evalImpl(CI->getOperand());
    if (!op) return nullopt;
    unsigned nb = CI->getNewTy().getWidth();
    switch (CI->getOpcode()) {
    case IntConversion::zext:
      return op->zext(nb);
    case IntConversion::sext:
      return op->sext(nb);
    case IntConversion::trunc:
      return op->trunc(nb);
    }
  }

  // FPConversion, SIMDBinOpInst, FakeShuffleInst,
  // ExtractElement, InsertElement — not handled
  return nullopt;
}

// Solve for reserved constants: evaluate the tree
// bottom-up. When an unbound ReservedConst is found,
// invert the parent operation to solve for it.
// Only supports sketches with a single RC for now.
bool Interpreter::solveForConstants(
    Inst *I, const APInt &target,
    unordered_map<ReservedConst*, APInt> &solution) {

  // If it's a Copy of a ReservedConst, solve directly
  if (auto *C = dynamic_cast<Copy*>(I)) {
    auto *RC = C->getReservedConst();
    if (!RC->getConst()) {
      solution[RC] = target;
      return true;
    }
    return false;
  }

  // Direct reserved const
  if (auto *RC = dynamic_cast<ReservedConst*>(I)) {
    if (!RC->getConst()) {
      solution[RC] = target;
      return true;
    }
    return false;
  }

  // BinaryOp: if one side is known and the other
  // contains the RC, invert the operation.
  if (auto *B = dynamic_cast<BinaryOp*>(I)) {
    auto lhs = evalImpl(B->getLHS());
    auto rhs = evalImpl(B->getRHS());
    unsigned w = B->getWorkTy().getWidth();
    APInt tgt = target.zextOrTrunc(w);

    // Case 1: LHS known, RHS has the unknown
    if (lhs && !rhs) {
      APInt L = lhs->zextOrTrunc(w);
      APInt needed(w, 0);
      switch (B->getOpcode()) {
      // L op RC = tgt → RC = ?
      case BinaryOp::add:  needed = tgt - L; break;
      case BinaryOp::sub:  needed = L - tgt; break;
      case BinaryOp::bxor: needed = tgt ^ L; break;
      case BinaryOp::band:
        // L & RC = tgt: RC must have tgt's bits set
        // where L has bits set. If tgt has bits set
        // where L doesn't, impossible.
        if ((tgt & ~L).getBoolValue()) return false;
        needed = tgt; // minimal solution
        break;
      case BinaryOp::bor:
        // L | RC = tgt: if L has bits tgt doesn't,
        // impossible.
        if ((L & ~tgt).getBoolValue()) return false;
        needed = tgt & ~L;
        break;
      case BinaryOp::mul:
        if (L.isZero()) return false;
        needed = tgt.udiv(L);
        if (needed * L != tgt) return false;
        break;
      case BinaryOp::shl:
        // Can't easily invert shl when RC is the
        // shift amount in general
        return false;
      default:
        return false;
      }
      return solveForConstants(
          B->getRHS(), needed, solution);
    }

    // Case 2: RHS known, LHS has the unknown
    if (!lhs && rhs) {
      APInt R = rhs->zextOrTrunc(w);
      APInt needed(w, 0);
      switch (B->getOpcode()) {
      case BinaryOp::add:  needed = tgt - R; break;
      case BinaryOp::sub:  needed = tgt + R; break;
      case BinaryOp::bxor: needed = tgt ^ R; break;
      case BinaryOp::band:
        if ((tgt & ~R).getBoolValue()) return false;
        needed = tgt;
        break;
      case BinaryOp::bor:
        if ((R & ~tgt).getBoolValue()) return false;
        needed = tgt & ~R;
        break;
      case BinaryOp::mul:
        if (R.isZero()) return false;
        needed = tgt.udiv(R);
        if (needed * R != tgt) return false;
        break;
      case BinaryOp::shl:
        if (R.uge(w)) return false;
        needed = tgt.lshr(R);
        if (needed.shl(R) != tgt) return false;
        break;
      case BinaryOp::lshr:
        if (R.uge(w)) return false;
        needed = tgt.shl(R);
        break;
      default:
        return false;
      }
      return solveForConstants(
          B->getLHS(), needed, solution);
    }

    // Both known or both unknown — can't solve
    return false;
  }

  // UnaryOp: if operand is unknown, invert
  if (auto *U = dynamic_cast<UnaryOp*>(I)) {
    switch (U->getOpcode()) {
    case UnaryOp::bitreverse:
      return solveForConstants(
          U->getOperand(), target.reverseBits(),
          solution);
    case UnaryOp::bswap:
      return solveForConstants(
          U->getOperand(), target.byteSwap(),
          solution);
    default:
      // ctpop, ctlz, cttz are not invertible
      return false;
    }
  }

  return false;
}

} // namespace minotaur
