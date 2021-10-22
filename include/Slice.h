// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Value.h"

#include <functional>
#include <optional>

namespace minotaur {

class Slice {
  llvm::Function &f;
  std::unique_ptr<llvm::Module> m;

public:
  Slice(llvm::Function &f) : f(f) {
    m = std::make_unique<llvm::Module>("exprs", f.getContext());
  }
  std::unique_ptr<llvm::Module> getNewModule() {return move(m);}
  std::optional<std::reference_wrapper<llvm::Function>> extractExpr(llvm::Value &V);
};

} // namespace minotaur