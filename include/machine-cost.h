// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#pragma once

#include "expr.h"

#include "llvm/IR/Function.h"

namespace minotaur {
unsigned get_machine_cost(llvm::Function *F);
unsigned get_approx_cost (llvm::Function *F);

bool approx_cmp(const std::tuple<llvm::Function*, llvm::Function*, Inst*, bool> &f1,
                const std::tuple<llvm::Function*, llvm::Function*, Inst*, bool> &f2);

}