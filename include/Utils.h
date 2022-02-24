// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once
#include "llvm/IR/Function.h"

namespace minotaur {
void eliminate_dead_code(llvm::Function &F);
}