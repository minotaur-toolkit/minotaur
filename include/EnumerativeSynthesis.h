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

  void findInputs(llvm::Function&,
                  llvm::Instruction*,
                  std::set<Var*>&,
                  std::set<Pointer*>&,
                  std::set<PointerVector*>&,
                  llvm::DominatorTree&);
  bool getSketches(llvm::Value *V,
                   std::set<Var*>&,
                   std::set<Pointer*>&,
                   std::vector<std::pair<Inst*, std::set<ReservedConst*>>>&);
public:
  std::tuple<Inst*, std::unordered_map<llvm::Argument*, llvm::Constant*>, unsigned, unsigned>
  synthesize (llvm::Function &F1, llvm::TargetLibraryInfo &TLI);
};

}
