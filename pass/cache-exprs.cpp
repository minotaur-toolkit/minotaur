// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "Slice.h"

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#include "hiredis.h"

using namespace llvm;
using namespace minotaur;
using namespace std;

namespace {
/*
void optimizeModule(llvm::Module *M) {
  llvm::LoopAnalysisManager LAM;
  llvm::FunctionAnalysisManager FAM;
  llvm::CGSCCAnalysisManager CGAM;
  llvm::ModuleAnalysisManager MAM;

  llvm::PassBuilder PB;
  PB.registerModuleAnalyses(MAM);
  PB.registerCGSCCAnalyses(CGAM);
  PB.registerFunctionAnalyses(FAM);
  PB.registerLoopAnalyses(LAM);
  PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

  llvm::FunctionPassManager FPM =
    PB.buildFunctionSimplificationPipeline(llvm::OptimizationLevel::O2,
                                           llvm::ThinOrFullLTOPhase::None);
  llvm::ModulePassManager MPM;
  MPM.addPass(createModuleToFunctionPassAdaptor(std::move(FPM)));
  MPM.run(*M, MAM);
}
*/
struct CacheExprsPass : PassInfoMixin<CacheExprsPass> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    //TargetLibraryInfo &TLI = FAM.getResult<TargetLibraryAnalysis>(F);
    PreservedAnalyses PA;
    PA.preserveSet<CFGAnalyses>();

    if (F.isDeclaration())
      return PA;

    LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);
    DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);
    MemoryDependenceResults &MD = FAM.getResult<MemoryDependenceAnalysis>(F);

    redisContext *c = redisConnect("127.0.0.1", 6379);
    if (c == NULL || c->err) {
      if (c) {
        printf("Error: %s\n", c->errstr);
        llvm::report_fatal_error("Cannot establish connection to redis");
      } else {
        printf("Can't allocate redis context\n");
      }
    }
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (I.getType()->isVoidTy())
          continue;
        Slice S(F, LI, DT, MD);
        S.extractExpr(I);
        auto m = S.getNewModule();
        //optimizeModule(m.get());
        string bytecode;
        llvm::raw_string_ostream ss(bytecode);
        //m->print(ss, nullptr, false, false);
        WriteBitcodeToFile(*m, ss);
        ss.flush();
        const char *s = bytecode.c_str();
        redisCommand(c, "HSET %b rewrite (NULL)", s, bytecode.size());
      }
    }
    redisFree(c);
    return PA;
  }
};

} // namespace
/*

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
  PB.registerVectorCombineCallback(
  //PB.registerPipelineEarlySimplificationEPCallback
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
}*/