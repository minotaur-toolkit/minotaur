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
#include <ostream>
#include <unordered_map>

namespace minotaur {

static std::ostream NOP_OSTREAM(nullptr);

class AliveEngine {
private:
  llvm::TargetLibraryInfoWrapperPass &TLI;
  std::ostream *debug;

  util::Errors find_model(tools::Transform &t,
    std::unordered_map<const IR::Value*, smt::expr>&);

public:
  AliveEngine(llvm::TargetLibraryInfoWrapperPass &TLI, bool dpi) : TLI(TLI) {
    util::config::disable_undef_input = true;
    util::config::disable_poison_input = dpi;
    util::config::use_exact_fp = dpi;
    debug = config::debug_tv ? &std::cerr : &NOP_OSTREAM;
  }

  bool constantSynthesis(llvm::Function&, llvm::Function&,
    std::unordered_map<llvm::Argument*, llvm::Constant*>&);
  bool compareFunctions(llvm::Function&, llvm::Function&);
};

}