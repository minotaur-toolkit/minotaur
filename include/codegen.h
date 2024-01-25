
// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "alive-interface.h"
#include "expr.h"

#include "llvm/IR/Function.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <unordered_set>
#include <unordered_map>

namespace minotaur {

class LLVMGen {
  std::unordered_set<llvm::Function*>& IntrinsicDecls;
  llvm::IRBuilder<> b;
  llvm::Module *M;
  llvm::LLVMContext &C;
public:
  LLVMGen(llvm::Instruction *I,
          std::unordered_set<llvm::Function *> &IDs)
    : IntrinsicDecls(IDs), b(llvm::IRBuilder<>(I)),
      M(I->getModule()), C(I->getContext()) {};
  llvm::Value *codeGen(Inst*, llvm::ValueToValueMapTy &VMap);
  llvm::Value *bitcastTo(llvm::Value*, llvm::Type*);

private:
  llvm::Value *codeGenImpl(Inst*, llvm::ValueToValueMapTy&);
};

}