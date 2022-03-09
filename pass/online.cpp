// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "EnumerativeSynthesis.h"
#include "LLVMGen.h"
#include "Slice.h"
#include "Utils.h"

#include "ir/instr.h"
#include "smt/smt.h"
#include "smt/solver.h"
#include "tools/transform.h"
#include "util/compiler.h"
#include "util/config.h"
#include "util/version.h"

#include "llvm/ADT/Any.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#include "hiredis.h"

#include <fstream>
#include <iostream>
#include <random>
#include <unordered_map>
#include <sstream>
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

llvm::cl::opt<bool> enable_caching(
    "so-enable-cachine",
    llvm::cl::desc("Superoptimizer: enable result caching"),
    llvm::cl::init(false));

llvm::cl::opt<bool> opt_debug("so-dbg",
                              llvm::cl::desc("Superoptimizer: Show debug data"),
                              llvm::cl::init(false), llvm::cl::Hidden);

llvm::cl::opt<unsigned> opt_omit_array_size(
    "so-omit-array-size",
    llvm::cl::desc("Omit an array initializer if it has elements more than "
                   "this number"),
    llvm::cl::init(-1));

static bool
optimize_function(llvm::Function &F, LoopInfo &LI, DominatorTree &DT, TargetLibraryInfo &TLI) {
  redisContext *c = redisConnect("127.0.0.1", 6379);
  bool changed = false;
  for (auto &BB : F) {
    for (auto &I : make_early_inc_range(BB)) {
      if (I.getType()->isVoidTy())
        continue;
      minotaur::Slice S(F, LI, DT);
      auto NewF = S.extractExpr(I);

              string bytecode;
      if (enable_caching) {
        llvm::raw_string_ostream bs(bytecode);
        auto m = S.getNewModule();
        WriteBitcodeToFile(*m, bs);
        bs.flush();
        std::string rewrite;
        if (minotaur::hGet(bytecode.c_str(), bytecode.size(), rewrite, c)) {
          cout<<rewrite;
        }
      }

      if (!NewF.has_value())
        continue;
      minotaur::EnumerativeSynthesis ES;
      auto [R, constMap] = ES.synthesize(*NewF, TLI);
      if (!R) continue;

      llvm::errs()<<"successfully synthesized rhs\n";


      if (enable_caching) {
        std::stringstream rs;
        R->print(rs);
        rs.flush();
        minotaur::hSet(bytecode.c_str(), bytecode.size(), rs.str(), c);
      }
      std::unordered_set<llvm::Function *> IntrinsicDecls;
      llvm::Value *V = minotaur::LLVMGen(&I, IntrinsicDecls).codeGen(R, S.getValueMap());
      V = llvm::IRBuilder<>(&I).CreateBitCast(V, I.getType());
      I.replaceAllUsesWith(V);
      minotaur::eliminate_dead_code(F);
      changed = true;
    }
  }
  if (changed)
    minotaur::eliminate_dead_code(F);
  redisFree(c);
  return changed;
}

struct SuperoptimizerLegacyPass final : public llvm::FunctionPass {
  static char ID;

  SuperoptimizerLegacyPass() : FunctionPass(ID) {}

  bool runOnFunction(llvm::Function &F) override {
    TargetLibraryInfo *TLI =
      &getAnalysis<TargetLibraryInfoWrapperPass>().getTLI(F);
    LoopInfo *LI =
      &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
    DominatorTree *DT =
      &getAnalysis<DominatorTreeWrapperPass>().getDomTree();

    return optimize_function(F, *LI, *DT, *TLI);
  }

  bool doInitialization(llvm::Module &module) override {
    return false;
  }

  bool doFinalization(llvm::Module &) override {
    return false;
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<TargetLibraryInfoWrapperPass>();
    AU.addRequired<LoopInfoWrapperPass>();
    AU.addRequired<DominatorTreeWrapperPass>();
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
  PreservedAnalyses run(llvm::Function &F, FunctionAnalysisManager &FAM) {
    //TargetLibraryInfo &TLI = FAM.getResult<TargetLibraryAnalysis>(F);
    PreservedAnalyses PA;
    PA.preserveSet<CFGAnalyses>();

    if (F.isDeclaration())
      return PA;

    LoopInfo &LI = FAM.getResult<llvm::LoopAnalysis>(F);
    DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);
    TargetLibraryInfo &TLI = FAM.getResult<TargetLibraryAnalysis>(F);
    optimize_function(F, LI, DT, TLI);
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