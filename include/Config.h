#pragma once

// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include <string>
#include <ostream>

namespace minotaur {

extern bool disable_poison_input;
extern bool disable_undef_input;
extern bool debug_slicer;
extern bool debug_enumerator;
extern bool debug_tv;
extern bool smt_verbose;

std::ostream &dbg();
void set_debug(std::ostream &os);

}
