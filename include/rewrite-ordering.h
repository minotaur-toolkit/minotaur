// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "expr.h"

namespace minotaur {

// Keep rewrite-order analysis explicit and extensible. Different callers use
// the same structural signals with different priorities:
// 1. target-specific/exotic ops,
// 2. number of live LHS vars referenced by the RHS,
// 3. synthesized constants,
// 4. semantic flags such as `icmp samesign`,
// 5. structural size.
struct InstOrderingKey {
  unsigned TargetSpecificOps = 0;
  unsigned DomainCrossings = 0;
  unsigned VarNodes = 0;
  unsigned DistinctVars = 0;
  unsigned ReservedConsts = 0;
  unsigned SameSignICmps = 0;
  unsigned NodeCount = 0;
};

InstOrderingKey analyzeInstOrdering(const Inst &I);

struct SearchOrderingContext {
  unsigned ExpectedDistinctVars = 0;
};

// Search-time ordering: prefer generic, low-input RHSs before target-specific
// vector intrinsics so simple candidates are verified earlier.
bool preferInstForSearch(const Inst &A, const Inst &B,
                         SearchOrderingContext Ctx = {});

bool preferInstForSameCost(const Inst &A, const Inst &B);

} // namespace minotaur
