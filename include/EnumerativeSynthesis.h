// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "ir/function.h"

#include "Expr.h"
#include "llvm/IR/Dominators.h"

#include <functional>
#include <memory>
#include <unordered_map>

namespace llvm {
class Function;
class TargetLibraryInfo;
}

namespace minotaur {

class EnumerativeSynthesis {
  std::vector<std::unique_ptr<Inst>> exprs;

  void findInputs(llvm::Instruction *Root,
                  std::set<Var*> &Cands,
                  std::set<Addr*> &Pointers,
                  llvm::DominatorTree &DT,
                  unsigned Max);
  bool getSketches(llvm::Value *V,
                   std::set<Var*>&,
                   std::set<Addr*>&,
                   std::vector<std::pair<Inst*, std::set<ReservedConst*>>>&);
public:
  std::pair<Inst*, std::unordered_map<llvm::Argument*, llvm::Constant*>>
  synthesize (llvm::Function &F1, llvm::TargetLibraryInfo &TLI);
};

}
