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
  llvm::LLVMContext &Ctx;
  llvm::LoopInfo &LI;
  llvm::DominatorTree &DT;
  llvm::MemoryDependenceResults &MD;

  std::unique_ptr<llvm::Module> m;
  llvm::ValueToValueMapTy mapping;

public:
  RemovalSlice(llvm::LLVMContext &Ctx, llvm::DataLayout &DL, llvm::LoopInfo &LI, 
               llvm::DominatorTree &DT, llvm::MemoryDependenceResults &MD)
    : Ctx(Ctx), LI(LI), DT(DT), MD(MD) {
    m = std::make_unique<llvm::Module>("", Ctx);
    m->setDataLayout(DL);
  }
  std::unique_ptr<llvm::Module> getNewModule() {return move(m); }
  llvm::ValueToValueMapTy& getValueMap() { return mapping; }
  std::optional<std::reference_wrapper<llvm::Function>>
    extractExpr(llvm::Value &V);
};

} // namespace minotaur