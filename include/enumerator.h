// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "alive-interface.h"
#include "ir/function.h"

#include "expr.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/Dominators.h"

#include <functional>
#include <memory>
#include <unordered_map>

namespace llvm {
class Function;
class TargetLibraryInfo;
}

namespace minotaur {

using Sketch = std::pair<Inst*, std::set<ReservedConst*>>;

class Enumerator {
  std::vector<std::unique_ptr<Inst>> exprs;

  std::vector<Var*> values;

  void findInputs(llvm::Function&,
                  llvm::Instruction*,
                  llvm::DominatorTree&);
  bool getSketches(llvm::Value *V,
                   std::vector<Sketch>&);
public:
  std::vector<Rewrite> solve(llvm::Function&, llvm::Instruction*);
};

}
