// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#pragma once

#include "IR.h"

#include "llvm/IR/Function.h"

namespace minotaur {
unsigned get_machine_cost(llvm::Function *F);
unsigned get_approx_cost (llvm::Function *F);

bool ac_cmp(std::tuple<llvm::Function*, llvm::Function*, llvm::Value*, Inst*, bool> f1,
            std::tuple<llvm::Function*, llvm::Function*, llvm::Value*, Inst*, bool> f2);

}