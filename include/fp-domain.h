#pragma once

#include "expr.h"

#include "llvm/IR/Value.h"

namespace minotaur {

// A small must-property lattice for FP values.
//
// Unknown is the top element: it carries no pruning power.
// Selector and Fresh are incomparable must-facts:
// - Selector means the value is guaranteed to be a transported selection of
//   existing FP leaves.
// - Fresh means the value is guaranteed to be a newly manufactured FP value,
//   not merely one of the incoming FP leaves.
//
// We only prune on contradiction, so Unknown never causes pruning.
enum class FPOriginKind {
  Unknown,
  Selector,
  Fresh,
};

struct FPValueDomain {
  bool IsFP = false;
  FPOriginKind Origin = FPOriginKind::Unknown;
  unsigned DistinctLeaves = 0;

  bool mustBeSelector() const {
    return IsFP && Origin == FPOriginKind::Selector;
  }

  bool mustBeFresh() const {
    return IsFP && Origin == FPOriginKind::Fresh;
  }
};

FPValueDomain analyzeFPValueDomain(const Inst &I);
FPValueDomain analyzeFPValueDomain(const llvm::Value &V);

bool fpDomainsContradict(const FPValueDomain &Src, const FPValueDomain &Cand);
bool proveFPTransportEquivalent(const llvm::Value &Src, const Inst &Cand);

enum class FPTransportRelation {
  Unknown,
  Equivalent,
  Inequivalent,
};

FPTransportRelation classifyFPTransportRelation(const llvm::Value &Src,
                                               const Inst &Cand);

} // namespace minotaur
