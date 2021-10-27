// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "Slice.h"

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

using namespace llvm;
using namespace minotaur;

namespace {

struct CacheExprsPass : PassInfoMixin<CacheExprsPass> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    //TargetLibraryInfo &TLI = FAM.getResult<TargetLibraryAnalysis>(F);

    PreservedAnalyses PA;
    PA.preserveSet<CFGAnalyses>();
    if (F.isDeclaration())
      return PA;

    Slice S(F);
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (I.getType()->isVoidTy())
          continue;
        auto fs = S.extractExpr(I);
        (void)fs;
      }
    }
    return PA;
  }
};

} // namespace

bool pipelineParsingCallback(StringRef Name, FunctionPassManager &FPM,
                             ArrayRef<PassBuilder::PipelineElement>) {
  bool Res = false;

  if (Name == "minotaur-cache-exprs") {
    Res = true;

    FPM.addPass(CacheExprsPass());
  }

  return Res;
}

void passBuilderCallback(PassBuilder &PB) {
  PB.registerPipelineParsingCallback(pipelineParsingCallback);
  PB.registerPeepholeEPCallback(
      [](llvm::FunctionPassManager &FPM, llvm::OptimizationLevel) {
        FPM.addPass(CacheExprsPass());
      });
}

PassPluginLibraryInfo getCacheExprsPassPluginInfo() {
  llvm::PassPluginLibraryInfo Res;

  Res.APIVersion = LLVM_PLUGIN_API_VERSION;
  Res.PluginName = "CacheExprsPass";
  Res.PluginVersion = LLVM_VERSION_STRING;
  Res.RegisterPassBuilderCallbacks = passBuilderCallback;

  return Res;
}

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getCacheExprsPassPluginInfo();
}