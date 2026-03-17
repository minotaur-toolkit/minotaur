// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "expr.h"
#include "llvm/ADT/APInt.h"

#include <optional>
#include <unordered_map>
#include <set>

namespace minotaur {

// Concrete interpreter for minotaur's Inst AST.
// Evaluates expressions on APInt values without
// touching LLVM IR. Used for dataflow-based pruning.
class Interpreter {
  using Env = std::unordered_map<Value*, llvm::APInt>;
  Env env;

  std::optional<llvm::APInt> evalImpl(Inst *I);

public:
  void bind(Value *V, llvm::APInt val) {
    env[V] = std::move(val);
  }

  // Evaluate an Inst tree. Returns nullopt if
  // evaluation fails (unsupported op, FP, etc.)
  std::optional<llvm::APInt> eval(Inst *I);

  // For sketches with reserved constants: solve for
  // the constant value(s) that make the sketch produce
  // `target` on the current bindings. Returns true if
  // a solution exists and populates `solution`.
  // Only handles integer-typed reserved constants.
  bool solveForConstants(
      Inst *I, const llvm::APInt &target,
      std::unordered_map<ReservedConst*,
                         llvm::APInt> &solution);
};

} // namespace minotaur
