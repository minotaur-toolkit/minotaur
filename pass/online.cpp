// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "config.h"
#include "synthesis.h"
#include "codegen.h"
#include "slice.h"
#include "removal-slice.h"
#include "utils.h"

#include "ir/instr.h"
#include "llvm_util/llvm2alive.h"
#include "smt/smt.h"
#include "smt/solver.h"
#include "tools/transform.h"
#include "util/compiler.h"
#include "util/config.h"
#include "util/version.h"

#include "llvm/ADT/Any.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/MemoryDependenceAnalysis.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/Casting.h"
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
using namespace minotaur;

namespace {

llvm::cl::opt<unsigned> smt_to(
    "minotaur-query-to",
    llvm::cl::desc("minotaur: timeout for SMT queries"),
    llvm::cl::init(10), llvm::cl::value_desc("s"));

// llvm::cl::opt<unsigned> problem_to(
//     "minotaur-problem-to",
//     llvm::cl::desc("minotaur: timeout for each synthesis problem"),
//     llvm::cl::init(1200), llvm::cl::value_desc("s"));

llvm::cl::opt<bool> smt_verbose(
    "minotaur-smt-verbose",
    llvm::cl::desc("minotaur: SMT verbose mode"),
    llvm::cl::init(false));

llvm::cl::opt<bool> enable_caching(
    "minotaur-enable-caching",
    llvm::cl::desc("minotaur: enable result caching"),
    llvm::cl::init(true));

llvm::cl::opt<bool> ignore_mca(
    "minotaur-ignore-machine-cost",
    llvm::cl::desc("minotaur: ignore llvm-mca cost model"),
    llvm::cl::init(false));

llvm::cl::opt<bool> debug_enumerator(
    "minotaur-debug-enumerator",
    llvm::cl::desc("minotaur: enable enumerator debug output"),
    llvm::cl::init(false));

llvm::cl::opt<bool> debug_slicer(
    "minotaur-debug-slicer",
    llvm::cl::desc("minotaur: enable slicer debug output"),
    llvm::cl::init(false));

llvm::cl::opt<bool> debug_tv(
    "minotaur-debug-tv",
    llvm::cl::desc("minotaur: enable alive2 debug output"),
    llvm::cl::init(false));

llvm::cl::opt<unsigned> redis_port(
    "minotaur-redis-port",
    llvm::cl::desc("redis port number"),
    llvm::cl::init(6379));

static bool dom_check(llvm::Value *V, DominatorTree &DT, llvm::Use &U) {
  if (auto I = dyn_cast<Instruction> (V)) {
    for (auto &op : I->operands()) {
      if (auto opI = dyn_cast<Instruction> (op)) {
        if (!DT.dominates(opI, U)) return false;
      }
    }
  }
  return true;
}

struct debug {
  template<class T>
  debug &operator<<(const T &s)
  {
    if (debug_enumerator || debug_slicer || debug_tv)
      llvm::errs()<<s;
    return *this;
  }
};

static bool
optimize_function(llvm::Function &F, LoopInfo &LI, DominatorTree &DT,
                  TargetLibraryInfoWrapperPass &TLI,
                  MemoryDependenceResults &MD) {

  config::ignore_machine_cost = ignore_mca;
  config::debug_enumerator = debug_enumerator;
  config::debug_tv = debug_tv;
  config::debug_slicer = debug_slicer;
  smt::solver_print_queries(smt_verbose);

  debug() << "[online] starting minotaur\n";

  smt::set_query_timeout(to_string(smt_to * 1000));

  redisContext *ctx = redisConnect("127.0.0.1", redis_port);
  bool changed = false;
  for (auto &BB : F) {
    for (auto &I : make_early_inc_range(BB)) {
      if (I.getType()->isVoidTy())
        continue;

      DataLayout DL(F.getParent());
      minotaur::RemovalSlice S(F, LI, DT, MD);
      auto NewF = S.extractExpr(I);
      auto m = S.getNewModule();

      if (!NewF.has_value())
        continue;

      string bytecode;
      if (enable_caching) {
        llvm::raw_string_ostream bs(bytecode);
        WriteBitcodeToFile(*m, bs);
        bs.flush();
        std::string rewrite;
        if (minotaur::hGet(bytecode.c_str(), bytecode.size(), rewrite, ctx)) {
          if (rewrite == "<no-sol>") {
            debug() << "[online] cache matched, but no solution found in "
                       "previous run, skipping function: \n"
                    << (*NewF).get();
            continue;
          }
        }
      }

      EnumerativeSynthesis ES;
      debug() << "[online] working on Function:\n" << (*NewF).get();

      auto R = ES.synthesize(*NewF);

      if (!R.has_value()) {
        hSetNoSolution(bytecode.c_str(), bytecode.size(), ctx, F.getName());
        continue;
      }
      unordered_set<llvm::Function *> IntrinDecls;
      Instruction *insertpt = I.getNextNode();
      while(isa<PHINode>(insertpt)) {
        insertpt = insertpt->getNextNode();
      }

      auto *V = LLVMGen(insertpt, IntrinDecls).codeGen(*R, S.getValueMap());
      V = llvm::IRBuilder<>(insertpt).CreateBitCast(V, I.getType());

      if (enable_caching) {
        string optimized;
        llvm::raw_string_ostream bs(optimized);
        for (auto &F : *m) {
          eliminate_dead_code(F);
        }
        WriteBitcodeToFile(*m, bs);

        stringstream rs;
        R->I->print(rs);
        rs.flush();
        hSetRewrite(bytecode.c_str(), bytecode.size(),
                    optimized.c_str(), optimized.size(),
                    rs.str(), ctx, /*TODO*/ 0, 0, F.getName());
      }

      I.replaceUsesWithIf(V, [&changed, &V, &DT](Use &U) {
        if(dom_check(V, DT, U)) {
          changed = true;
          return true;
        }
        return false;
      });
    }
  }
  if (changed) {
    F.removeFnAttr("min-legal-vector-width");
    eliminate_dead_code(F);
  }
  redisFree(ctx);
  debug() << "[online] minotaur completed optimization\n";
  return changed;
}

struct SuperoptimizerLegacyPass final : public llvm::FunctionPass {
  static char ID;

  SuperoptimizerLegacyPass() : FunctionPass(ID) {}

  bool runOnFunction(llvm::Function &F) override {
    LoopInfo &LI =
      getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
    DominatorTree &DT =
      getAnalysis<DominatorTreeWrapperPass>().getDomTree();
    MemoryDependenceResults &MD =
      getAnalysis<MemoryDependenceWrapperPass>().getMemDep();

    TargetLibraryInfoWrapperPass TLI(Triple(F.getParent()->getTargetTriple()));

    return optimize_function(F, LI, DT, TLI, MD);
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
    AU.addRequired<MemoryDependenceWrapperPass>();
    AU.setPreservesAll();
  }
};

char SuperoptimizerLegacyPass::ID = 0;
} // namespace

namespace llvm {
RegisterPass<SuperoptimizerLegacyPass> X("so", "Superoptimizer", false, false);
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
    MemoryDependenceResults &MD = FAM.getResult<MemoryDependenceAnalysis>(F);

    TargetLibraryInfoWrapperPass TLI(Triple(F.getParent()->getTargetTriple()));
    optimize_function(F, LI, DT, TLI, MD);
    return PA;
  }
};

}// namespace

bool pipelineParsingCallback(StringRef Name, FunctionPassManager &FPM,
                             ArrayRef<PassBuilder::PipelineElement>) {
  if (Name == "minotaur-online") {
    FPM.addPass(SuperoptimizerPass());
    return true;
  }
  return false;
}

void passBuilderCallback(PassBuilder &PB) {
  PB.registerPipelineParsingCallback(pipelineParsingCallback);
  PB.registerVectorCombineCallback(
      [](llvm::FunctionPassManager &FPM, llvm::OptimizationLevel) {
        FPM.addPass(SuperoptimizerPass());
      });
}

PassPluginLibraryInfo getMinotaurPassInfo() {
  llvm::PassPluginLibraryInfo PPLI;

  PPLI.APIVersion = LLVM_PLUGIN_API_VERSION;
  PPLI.PluginName = "MinotaurPass";
  PPLI.PluginVersion = LLVM_VERSION_STRING;
  PPLI.RegisterPassBuilderCallbacks = passBuilderCallback;

  return PPLI;
}

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getMinotaurPassInfo();
}
