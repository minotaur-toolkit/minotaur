// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "rewrite-ordering.h"

namespace minotaur {

namespace {

template <typename T>
T *mutableView(const T *Ptr) {
  return const_cast<T*>(Ptr);
}

InstOrderingKey combine(InstOrderingKey A, InstOrderingKey B) {
  A.ReservedConsts += B.ReservedConsts;
  A.SameSignICmps += B.SameSignICmps;
  A.NodeCount += B.NodeCount;
  return A;
}

InstOrderingKey analyze(const Inst &I) {
  InstOrderingKey Self;
  Self.NodeCount = 1;

  if (auto *Cmp = dynamic_cast<const ICmp*>(&I)) {
    Self.SameSignICmps = Cmp->hasSameSign() ? 1u : 0u;
    Self = combine(Self, analyze(*mutableView(Cmp)->getLHS()));
    Self = combine(Self, analyze(*mutableView(Cmp)->getRHS()));
    return Self;
  }

  if (dynamic_cast<const ReservedConst*>(&I)) {
    Self.ReservedConsts = 1;
    return Self;
  }

  if (auto *Op = dynamic_cast<const UnaryOp*>(&I))
    return combine(Self, analyze(*mutableView(Op)->getOperand()));

  if (auto *Op = dynamic_cast<const BinaryOp*>(&I))
    return combine(combine(Self, analyze(*mutableView(Op)->getLHS())),
                   analyze(*mutableView(Op)->getRHS()));

  if (auto *Cmp = dynamic_cast<const FCmp*>(&I))
    return combine(combine(Self, analyze(*mutableView(Cmp)->getLHS())),
                   analyze(*mutableView(Cmp)->getRHS()));

  if (auto *Op = dynamic_cast<const SIMDBinOpInst*>(&I))
    return combine(combine(Self, analyze(*mutableView(Op)->getLHS())),
                   analyze(*mutableView(Op)->getRHS()));

  if (auto *Op = dynamic_cast<const FakeShuffleInst*>(&I)) {
    auto Key = combine(Self, analyze(*mutableView(Op)->getLHS()));
    if (auto *RHS = mutableView(Op)->getRHS())
      Key = combine(Key, analyze(*RHS));
    return Key;
  }

  if (auto *Op = dynamic_cast<const ExtractElement*>(&I))
    return combine(Self, analyze(*mutableView(Op)->getVector()));

  if (auto *Op = dynamic_cast<const InsertElement*>(&I))
    return combine(combine(Self, analyze(*mutableView(Op)->getVector())),
                   analyze(*mutableView(Op)->getElement()));

  if (auto *Op = dynamic_cast<const VectorReduce*>(&I))
    return combine(Self, analyze(*mutableView(Op)->getVector()));

  if (auto *Op = dynamic_cast<const IntConversion*>(&I))
    return combine(Self, analyze(*mutableView(Op)->getOperand()));

  if (auto *Op = dynamic_cast<const FPConversion*>(&I))
    return combine(Self, analyze(*mutableView(Op)->getOperand()));

  if (auto *Op = dynamic_cast<const Select*>(&I))
    return combine(combine(combine(Self, analyze(*mutableView(Op)->getCond())),
                           analyze(*mutableView(Op)->getLHS())),
                   analyze(*mutableView(Op)->getRHS()));

  return Self;
}

} // namespace

InstOrderingKey analyzeInstOrdering(const Inst &I) {
  return analyze(I);
}

bool preferInstForSameCost(const Inst &A, const Inst &B) {
  auto KeyA = analyzeInstOrdering(A);
  auto KeyB = analyzeInstOrdering(B);
  if (KeyA.ReservedConsts != KeyB.ReservedConsts)
    return KeyA.ReservedConsts < KeyB.ReservedConsts;
  if (KeyA.SameSignICmps != KeyB.SameSignICmps)
    return KeyA.SameSignICmps > KeyB.SameSignICmps;
  if (KeyA.NodeCount != KeyB.NodeCount)
    return KeyA.NodeCount < KeyB.NodeCount;
  return false;
}

} // namespace minotaur
