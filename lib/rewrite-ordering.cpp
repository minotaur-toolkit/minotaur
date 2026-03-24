// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "rewrite-ordering.h"

#include <set>
#include <string>

namespace minotaur {

namespace {

template <typename T>
T *mutableView(const T *Ptr) {
  return const_cast<T*>(Ptr);
}

struct AnalysisState {
  InstOrderingKey Key;
  std::set<std::string> DistinctVarNames;
};

AnalysisState combine(AnalysisState A, AnalysisState B) {
  A.Key.TargetSpecificOps += B.Key.TargetSpecificOps;
  A.Key.DomainCrossings += B.Key.DomainCrossings;
  A.Key.VarNodes += B.Key.VarNodes;
  A.Key.ReservedConsts += B.Key.ReservedConsts;
  A.Key.SameSignICmps += B.Key.SameSignICmps;
  A.Key.NodeCount += B.Key.NodeCount;
  A.DistinctVarNames.insert(B.DistinctVarNames.begin(),
                            B.DistinctVarNames.end());
  return A;
}

AnalysisState analyze(const Inst &I) {
  AnalysisState Self;
  Self.Key.NodeCount = 1;

  if (dynamic_cast<const Var*>(&I)) {
    auto *V = static_cast<const Var *>(&I);
    Self.Key.VarNodes = 1;
    Self.DistinctVarNames.insert(V->getName());
    return Self;
  }

  if (auto *Cmp = dynamic_cast<const ICmp*>(&I)) {
    Self.Key.SameSignICmps = Cmp->hasSameSign() ? 1u : 0u;
    Self = combine(Self, analyze(*mutableView(Cmp)->getLHS()));
    Self = combine(Self, analyze(*mutableView(Cmp)->getRHS()));
    return Self;
  }

  if (dynamic_cast<const ReservedConst*>(&I)) {
    Self.Key.ReservedConsts = 1;
    return Self;
  }

  if (auto *Op = dynamic_cast<const Copy*>(&I))
    return combine(Self, analyze(*mutableView(Op)->getReservedConst()));

  if (auto *Op = dynamic_cast<const UnaryOp*>(&I)) {
    Self.Key.DomainCrossings =
        mutableView(Op)->getWorkTy().isFP() != Op->getType().isFP() ? 1u : 0u;
    return combine(Self, analyze(*mutableView(Op)->getOperand()));
  }

  if (auto *Op = dynamic_cast<const BinaryOp*>(&I)) {
    Self.Key.DomainCrossings =
        mutableView(Op)->getWorkTy().isFP() != Op->getType().isFP() ? 1u : 0u;
    return combine(combine(Self, analyze(*mutableView(Op)->getLHS())),
                   analyze(*mutableView(Op)->getRHS()));
  }

  if (auto *Cmp = dynamic_cast<const FCmp*>(&I))
    return combine(combine(Self, analyze(*mutableView(Cmp)->getLHS())),
                   analyze(*mutableView(Cmp)->getRHS()));

  if (auto *Op = dynamic_cast<const SIMDBinOpInst*>(&I)) {
    Self.Key.TargetSpecificOps = 1;
    return combine(combine(Self, analyze(*mutableView(Op)->getLHS())),
                   analyze(*mutableView(Op)->getRHS()));
  }

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

  if (auto *Op = dynamic_cast<const IntConversion*>(&I)) {
    Self.Key.DomainCrossings =
        mutableView(Op)->getOperand()->getType().isFP() !=
        Op->getType().isFP() ? 1u : 0u;
    return combine(Self, analyze(*mutableView(Op)->getOperand()));
  }

  if (auto *Op = dynamic_cast<const FPConversion*>(&I)) {
    Self.Key.DomainCrossings =
        mutableView(Op)->getOperand()->getType().isFP() !=
        Op->getType().isFP() ? 1u : 0u;
    return combine(Self, analyze(*mutableView(Op)->getOperand()));
  }

  if (auto *Op = dynamic_cast<const Select*>(&I))
    return combine(combine(combine(Self, analyze(*mutableView(Op)->getCond())),
                           analyze(*mutableView(Op)->getLHS())),
                   analyze(*mutableView(Op)->getRHS()));

  return Self;
}

} // namespace

InstOrderingKey analyzeInstOrdering(const Inst &I) {
  auto S = analyze(I);
  S.Key.DistinctVars = S.DistinctVarNames.size();
  return S.Key;
}

bool preferInstForSearch(const Inst &A, const Inst &B,
                         SearchOrderingContext Ctx) {
  auto KeyA = analyzeInstOrdering(A);
  auto KeyB = analyzeInstOrdering(B);
  if (KeyA.TargetSpecificOps != KeyB.TargetSpecificOps)
    return KeyA.TargetSpecificOps < KeyB.TargetSpecificOps;
  if (KeyA.DomainCrossings != KeyB.DomainCrossings)
    return KeyA.DomainCrossings < KeyB.DomainCrossings;
  if (Ctx.ExpectedDistinctVars) {
    auto DeltaA = (KeyA.DistinctVars > Ctx.ExpectedDistinctVars)
        ? KeyA.DistinctVars - Ctx.ExpectedDistinctVars
        : Ctx.ExpectedDistinctVars - KeyA.DistinctVars;
    auto DeltaB = (KeyB.DistinctVars > Ctx.ExpectedDistinctVars)
        ? KeyB.DistinctVars - Ctx.ExpectedDistinctVars
        : Ctx.ExpectedDistinctVars - KeyB.DistinctVars;
    if (DeltaA != DeltaB)
      return DeltaA < DeltaB;
  }
  if (KeyA.SameSignICmps != KeyB.SameSignICmps)
    return KeyA.SameSignICmps > KeyB.SameSignICmps;
  if (KeyA.ReservedConsts != KeyB.ReservedConsts)
    return KeyA.ReservedConsts < KeyB.ReservedConsts;
  if (KeyA.NodeCount != KeyB.NodeCount)
    return KeyA.NodeCount < KeyB.NodeCount;
  if (KeyA.DistinctVars != KeyB.DistinctVars)
    return KeyA.DistinctVars < KeyB.DistinctVars;
  if (KeyA.VarNodes != KeyB.VarNodes)
    return KeyA.VarNodes < KeyB.VarNodes;
  return false;
}

bool preferInstForSameCost(const Inst &A, const Inst &B) {
  auto KeyA = analyzeInstOrdering(A);
  auto KeyB = analyzeInstOrdering(B);
  if (KeyA.DomainCrossings != KeyB.DomainCrossings)
    return KeyA.DomainCrossings < KeyB.DomainCrossings;
  if (KeyA.ReservedConsts != KeyB.ReservedConsts)
    return KeyA.ReservedConsts < KeyB.ReservedConsts;
  if (KeyA.SameSignICmps != KeyB.SameSignICmps)
    return KeyA.SameSignICmps > KeyB.SameSignICmps;
  if (KeyA.NodeCount != KeyB.NodeCount)
    return KeyA.NodeCount < KeyB.NodeCount;
  return false;
}

} // namespace minotaur
