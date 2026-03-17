// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "config.h"
#include "tools/transform.h"
#include "util/config.h"

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/Argument.h"

#include <iostream>
#include <ostream>
#include <unordered_map>

namespace minotaur {

class AliveEngine {
private:
  llvm::TargetLibraryInfoWrapperPass &TLI;
  std::ostream *debug;

  // For constant synthesis we may need to return 'poison' as a synthesized
  // constant. Alive2 models poison via the non_poison predicate of StateValue.
  // We return both the value and its non_poison condition in the model.
  using ModelVal = std::pair<smt::expr, smt::expr>; // <value, non_poison>

  util::Errors find_model(tools::Transform &t,
    std::unordered_map<const IR::Value*, ModelVal>&);

public:
  AliveEngine(llvm::TargetLibraryInfoWrapperPass &TLI);

  bool constantSynthesis(llvm::Function&, llvm::Function&,
    std::unordered_map<llvm::Argument*, llvm::Constant*>&);
  bool compareFunctions(llvm::Function&, llvm::Function&);
};

} // namespace minotaur