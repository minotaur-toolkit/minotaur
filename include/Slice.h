// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Value.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <functional>
#include <optional>

namespace minotaur {

class Slice {
  llvm::Function &f;
  llvm::LoopInfo &LI;
  llvm::DominatorTree &DT;
  std::unique_ptr<llvm::Module> m;
  llvm::ValueToValueMapTy mapping;

public:
  Slice(llvm::Function &f, llvm::LoopInfo &LI, llvm::DominatorTree &DT)
    : f(f), LI(LI), DT(DT) {
    m = std::make_unique<llvm::Module>("", f.getContext());
  }
  std::unique_ptr<llvm::Module> getNewModule() {return move(m); }
  llvm::ValueToValueMapTy& getValueMap() { return mapping; }
  std::optional<std::reference_wrapper<llvm::Function>>
    extractExpr(llvm::Value &V);
};

} // namespace minotaur