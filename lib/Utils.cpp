// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "llvm/Transforms/Scalar/DCE.h"
#include "llvm/Passes/PassBuilder.h"

namespace minotaur {

void eliminate_dead_code(llvm::Function &F) {
  llvm::FunctionAnalysisManager FAM;

  llvm::PassBuilder PB;
  PB.registerFunctionAnalyses(FAM);

  llvm::FunctionPassManager FPM;
  FPM.addPass(llvm::DCEPass());
  FPM.run(F, FAM);
}

}