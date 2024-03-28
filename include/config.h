// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "llvm/Support/raw_ostream.h"
#include <string>
#include <ostream>

namespace minotaur {
namespace config {

extern bool disable_poison_input;
extern bool disable_undef_input;
extern bool debug_slicer;
extern bool debug_enumerator;
extern bool debug_tv;
extern bool debug_codegen;
extern bool debug_parser;
extern bool ignore_machine_cost;
extern bool smt_verbose;
extern bool disable_avx512;
extern bool show_stats;
extern bool return_first_solution;

extern unsigned slice_to;
extern unsigned slicer_max_depth;

llvm::raw_ostream &dbg();
void set_debug(llvm::raw_ostream &os);

extern const char minotaur_version[];

}
}
