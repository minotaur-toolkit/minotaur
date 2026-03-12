// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "expr.h"

#include "llvm/IR/Dominators.h"

#include <memory>
#include <set>
#include <vector>

namespace llvm {
class Function;
class Instruction;
class Value;
} // namespace llvm

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
  bool getDepth2Sketches(llvm::Value *V,
                         std::vector<Sketch>&);
public:
  std::vector<Rewrite> solve(llvm::Function&,
                             llvm::Instruction*);
};

} // namespace minotaur
