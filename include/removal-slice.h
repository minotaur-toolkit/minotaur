// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/MemoryDependenceAnalysis.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Value.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <functional>
#include <optional>

namespace minotaur {

class RemovalSlice {
  llvm::Function &VF;
  llvm::LLVMContext &Ctx;
  llvm::LoopInfo &LI;
  llvm::DominatorTree &DT;

  std::unique_ptr<llvm::Module> M;
  llvm::ValueToValueMapTy mapping;

public:
  RemovalSlice(llvm::Function &VF, llvm::LoopInfo &LI, llvm::DominatorTree &DT)
    : VF(VF), Ctx(VF.getContext()), LI(LI), DT(DT) {
    M = std::make_unique<llvm::Module>("", Ctx);
    M->setDataLayout(VF.getParent()->getDataLayout());
  }
  std::unique_ptr<llvm::Module> getNewModule() {return std::move(M); }
  llvm::ValueToValueMapTy& getValueMap() { return mapping; }
  std::optional<std::reference_wrapper<llvm::Function>>
    extractExpr(llvm::Value &V);
};

} // namespace minotaur