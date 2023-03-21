// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "expr.h"
#include "config.h"
#include "ir/function.h"
#include "smt/smt.h"
#include "tools/transform.h"
#include "util/config.h"

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/Argument.h"

#include <iostream>

namespace minotaur {

using constmap = std::map<const llvm::Argument*, llvm::Constant*>;

class AliveEngine {
private:
  std::optional<smt::smt_initializer> smt_init;
  llvm::TargetLibraryInfoWrapperPass &TLI;

public:
  AliveEngine(llvm::TargetLibraryInfoWrapperPass &TLI) : TLI(TLI) {
    smt_init.emplace();
    util::config::disable_undef_input = config::disable_undef_input;
    util::config::disable_poison_input = config::disable_poison_input;
    util::config::set_debug(config::dbg());
  }


  bool constantSynthesis(llvm::Function&, llvm::Function&, constmap&);
  bool compareFunctions(llvm::Function&, llvm::Function&);
};

}