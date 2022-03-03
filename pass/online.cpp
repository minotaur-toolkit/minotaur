// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "EnumerativeSynthesis.h"
#include "Slice.h"

#include "ir/instr.h"
#include "smt/smt.h"
#include "smt/solver.h"
#include "tools/transform.h"
#include "util/config.h"
#include "util/version.h"

#include "llvm/ADT/Any.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"

#include <fstream>
#include <iostream>
#include <random>
#include <unordered_map>
#include <utility>

using namespace std;
using namespace llvm;

namespace {
llvm::cl::opt<bool>
    opt_error_fatal("tv-exit-on-error",
                    llvm::cl::desc("Superoptimizer: exit on error"),
                    llvm::cl::init(false));

llvm::cl::opt<unsigned>
    opt_smt_to("so-smt-to",
               llvm::cl::desc("Superoptimizer: timeout for SMT queries"),
               llvm::cl::init(1000), llvm::cl::value_desc("ms"));

llvm::cl::opt<bool> opt_se_verbose(
    "so-se-verbose",
    llvm::cl::desc("Superoptimizer: symbolic execution verbose mode"),
    llvm::cl::init(false));

llvm::cl::opt<bool>
    opt_smt_stats("so-smt-stats",
                  llvm::cl::desc("Superoptimizer: show SMT statistics"),
                  llvm::cl::init(false));

llvm::cl::opt<bool>
    opt_smt_skip("so-smt-skip",
                 llvm::cl::desc("Superoptimizer: skip SMT queries"),
                 llvm::cl::init(false));

llvm::cl::opt<bool>
    opt_smt_verbose("so-smt-verbose",
                    llvm::cl::desc("Superoptimizer: SMT verbose mode"),
                    llvm::cl::init(false));

llvm::cl::opt<bool> opt_tactic_verbose(
    "so-tactic-verbose",
    llvm::cl::desc("Superoptimizer: SMT Tactic verbose mode"),
    llvm::cl::init(false));

llvm::cl::opt<bool> opt_disable_undef_input(
    "so-disable-undef-input",
    llvm::cl::desc("Superoptimizer: Assume function input cannot be undef"),
    llvm::cl::init(false));

llvm::cl::opt<unsigned> opt_src_unrolling_factor(
    "so-src-unroll",
    llvm::cl::desc("Unrolling factor for src function (default=0)"),
    llvm::cl::init(0));

llvm::cl::opt<unsigned> opt_tgt_unrolling_factor(
    "so-tgt-unroll",
    llvm::cl::desc("Unrolling factor for tgt function (default=0)"),
    llvm::cl::init(0));

llvm::cl::opt<bool> opt_debug("so-dbg",
                              llvm::cl::desc("Superoptimizer: Show debug data"),
                              llvm::cl::init(false), llvm::cl::Hidden);

llvm::cl::opt<unsigned> opt_omit_array_size(
    "so-omit-array-size",
    llvm::cl::desc("Omit an array initializer if it has elements more than "
                   "this number"),
    llvm::cl::init(-1));

struct SuperoptimizerLegacyPass final : public llvm::FunctionPass {
  static char ID;

  SuperoptimizerLegacyPass() : FunctionPass(ID) {}

  bool runOnFunction(llvm::Function &F) override {
    F.dump();
    llvm::TargetLibraryInfo *TLI =
        &getAnalysis<llvm::TargetLibraryInfoWrapperPass>().getTLI(F);
    smt::solver_print_queries(opt_smt_verbose);
    bool changed = minotaur::synthesize(F, *TLI);
    return changed;
  }

  bool doInitialization(llvm::Module &module) override {
    return false;
  }

  bool doFinalization(llvm::Module &) override {
    return false;
  }

  void getAnalysisUsage(llvm::AnalysisUsage &AU) const override {
    AU.addRequired<llvm::TargetLibraryInfoWrapperPass>();
    AU.setPreservesAll();
  }
};

char SuperoptimizerLegacyPass::ID = 0;
} // namespace

namespace llvm {
llvm::RegisterPass<SuperoptimizerLegacyPass> X("so", "Superoptimizer", false, false);
}

namespace {

struct SuperoptimizerPass : PassInfoMixin<SuperoptimizerPass> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    //TargetLibraryInfo &TLI = FAM.getResult<TargetLibraryAnalysis>(F);
    PreservedAnalyses PA;
    PA.preserveSet<CFGAnalyses>();

    if (F.isDeclaration())
      return PA;

    LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);
    DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);

    for (auto &BB : F) {
      for (auto &I : BB) {
        if (I.getType()->isVoidTy())
          continue;
        minotaur::Slice S(F, LI, DT);
        S.extractExpr(I);
        auto m = S.getNewModule();

        llvm::TargetLibraryInfo TLI = FAM.getResult<TargetLibraryAnalysis>(F);
        smt::solver_print_queries(opt_smt_verbose);
        minotaur::synthesize(F, TLI);
        return PA;
      }
    }
    return PA;
  }
};

}// namespace

bool pipelineParsingCallback(StringRef Name, FunctionPassManager &FPM,
                             ArrayRef<PassBuilder::PipelineElement>) {
  bool Result = false;

  if (Name == "minotaur-online") {
    Result = true;
    FPM.addPass(SuperoptimizerPass());
  }

  return Result;
}

void passBuilderCallback(PassBuilder &PB) {
  PB.registerPipelineParsingCallback(pipelineParsingCallback);
  PB.registerPeepholeEPCallback(
  //PB.registerPipelineEarlySimplificationEPCallback
      [](llvm::FunctionPassManager &FPM, llvm::OptimizationLevel) {
        FPM.addPass(SuperoptimizerPass());
      });
}

PassPluginLibraryInfo getSuperoptimizerPassPluginInfo() {
  llvm::PassPluginLibraryInfo Res;

  Res.APIVersion = LLVM_PLUGIN_API_VERSION;
  Res.PluginName = "SuperoptimizerPass";
  Res.PluginVersion = LLVM_VERSION_STRING;
  Res.RegisterPassBuilderCallbacks = passBuilderCallback;

  return Res;
}

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getSuperoptimizerPassPluginInfo();
}