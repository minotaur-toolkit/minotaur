// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "expr.h"

#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <unordered_set>

namespace minotaur {

class LLVMGen {
  std::unordered_set<llvm::Function*> &IntrinsicDecls;
  llvm::IRBuilder<> Builder;
  llvm::Module *Mod;
  llvm::LLVMContext &Ctx;
public:
  LLVMGen(llvm::Instruction *I,
          std::unordered_set<llvm::Function *> &IDs)
    : IntrinsicDecls(IDs),
      Builder(llvm::IRBuilder<>(I)),
      Mod(I->getModule()),
      Ctx(I->getContext()) {};
  llvm::Value *codeGen(
      Inst*, llvm::ValueToValueMapTy &VMap);
  llvm::Value *bitcastTo(
      llvm::Value*, llvm::Type*);

private:
  llvm::Value *codeGenImpl(
      Inst*, llvm::ValueToValueMapTy&);
};

} // namespace minotaur