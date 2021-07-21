
// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once
#include "IR.h"

#include "llvm/IR/Function.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <unordered_set>
#include <unordered_map>

namespace minotaur {

class LLVMGen {
  std::unordered_set<llvm::Function *> &IntrinsicDecls;
  llvm::IRBuilder<> b;
  llvm::Module *M;
public:
  LLVMGen(llvm::Instruction *I, 
          std::unordered_set<llvm::Function *> &IDs)
    : IntrinsicDecls(IDs), b(llvm::IRBuilder<>(I)), M(I->getModule()) {};
  llvm::Value *codeGen(minotaur::Inst *I,
                       llvm::ValueToValueMapTy &VMap,
                       std::unordered_map<llvm::Argument *,
                                          llvm::Constant *> *constMap);
};

}