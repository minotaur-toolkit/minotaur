// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "expr.h"

namespace minotaur {

// Keep the rewrite ordering policy explicit and extensible. Today the only
// tie-breakers are:
// 1. prefer fewer synthesized constants,
// 2. preserve more semantic flags such as `icmp samesign`,
// 3. prefer structurally smaller RHSs.
//
// Additional fields can be added here later without changing the caller-side
// sorting logic.
struct InstOrderingKey {
  unsigned ReservedConsts = 0;
  unsigned SameSignICmps = 0;
  unsigned NodeCount = 0;
};

InstOrderingKey analyzeInstOrdering(const Inst &I);

bool preferInstForSameCost(const Inst &A, const Inst &B);

} // namespace minotaur
