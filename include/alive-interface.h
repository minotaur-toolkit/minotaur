// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "expr.h"
#include "config.h"
#include "ir/function.h"
#include "smt/smt.h"
#include "tools/transform.h"
#include "util/config.h"
#include <iostream>

namespace minotaur {

class AliveEngine {
private:
  std::optional<smt::smt_initializer> smt_init;
public:
  AliveEngine() {
    smt_init.emplace();
    util::config::disable_undef_input = config::disable_undef_input;
    util::config::disable_poison_input = config::disable_poison_input;
    util::config::set_debug(config::dbg());
  }


  bool constantSynthesis(IR::Function &Func1, IR::Function &Func2,
                         unsigned &goodCount, unsigned &badCount, unsigned &errorCount,
                         std::unordered_map<const IR::Value*, ReservedConst*> &);
  bool compareFunctions(IR::Function &Func1, IR::Function &Func2,
                        unsigned &goodCount, unsigned &badCount, unsigned &errorCount);
};

}
