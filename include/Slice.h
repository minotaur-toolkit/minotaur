// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Value.h"

namespace minotaur {

class Slice {
  llvm::Function &f;
  std::unique_ptr<llvm::Module> m;
  std::unique_ptr<llvm::LLVMContext> ctx;

public:
  Slice(llvm::Function &f) : f(f) {
    ctx = std::make_unique<llvm::LLVMContext>();
    m = std::make_unique<llvm::Module>("jit", *ctx);
  }
  llvm::Function& extractExpr(llvm::Value &V);
};

} // namespace minotaur