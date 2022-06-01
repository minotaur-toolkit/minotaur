// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "util/config.h"
#include "llvm_util/utils.h"
#include <iostream>

using namespace std;

static ostream *debug_os = &cerr;

namespace minotaur {

bool disable_poison_input = true;
bool disable_undef_input = true;
bool debug_slicer = false;
bool debug_enumerator = false;
bool debug_tv = false;
bool smt_verbose = false;

ostream &dbg() {
  return *debug_os;
}

void set_debug(ostream &os) {
  debug_os = &os;
}

}