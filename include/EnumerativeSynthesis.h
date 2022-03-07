// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "ir/function.h"

#include "IR.h"

#include <functional>
#include <unordered_map>

namespace llvm {
class Function;
class TargetLibraryInfo;
}

namespace minotaur {
std::pair<Inst*, std::unordered_map<llvm::Argument*, llvm::Constant*>>
synthesize (llvm::Function &F1, llvm::TargetLibraryInfo &TLI);
};
