// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "util/config.h"
#include "llvm_util/utils.h"
#include "llvm/Support/raw_ostream.h"
#include <iostream>

using namespace std;

static llvm::raw_ostream *debug_os = &llvm::nulls();

namespace minotaur{
namespace config {

bool disable_poison_input = true;
bool disable_undef_input = true;
bool debug_slicer = false;
bool debug_enumerator = false;
bool debug_tv = false;
bool ignore_machine_cost = false;
bool smt_verbose = false;
bool disable_avx512 = true;
bool show_stats = false;
bool return_first_solution = false;

unsigned slicer_max_depth = 2;

llvm::raw_ostream &dbg() {
  return *debug_os;
}

void set_debug(llvm::raw_ostream &os) {
  debug_os = &os;
}

}
}

