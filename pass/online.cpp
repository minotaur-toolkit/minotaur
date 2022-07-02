// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "EnumerativeSynthesis.h"
#include "LLVMGen.h"
#include "Slice.h"
#include "Utils.h"

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

static constexpr unsigned DEBUG_LEVEL = 0;

namespace {

llvm::cl::opt<unsigned>
    opt_smt_to("so-smt-to",
               llvm::cl::desc("Superoptimizer: timeout for SMT queries"),
               llvm::cl::init(10000), llvm::cl::value_desc("ms"));

llvm::cl::opt<unsigned>
    opt_problem_to("so-problem-to",
                  llvm::cl::desc("Superoptimizer: timeout for SMT queries"),
                  llvm::cl::init(1200), llvm::cl::value_desc("s"));

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
    "minotaur-enable-caching",
    llvm::cl::desc("Superoptimizer: enable result caching"),
    llvm::cl::init(true));

llvm::cl::opt<bool> opt_debug("so-dbg",
                              llvm::cl::desc("Superoptimizer: Show debug data"),
                              llvm::cl::init(false), llvm::cl::Hidden);

llvm::cl::opt<unsigned> opt_omit_array_size(
    "so-omit-array-size",
    llvm::cl::desc("Omit an array initializer if it has elements more than "
                   "this number"),
    llvm::cl::init(-1));

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
static bool
optimize_function(llvm::Function &F, LoopInfo &LI, DominatorTree &DT,
                  TargetLibraryInfo &TLI, MemoryDependenceResults &MD) {
  // if (F.getName() != "gen_codes")
  //     return true;
  smt::solver_print_queries(opt_smt_verbose);
  if (DEBUG_LEVEL > 0)
    llvm::errs()<<"=== start of minotaur run ===\n";

  clock_t start = std::clock();

  smt::set_query_timeout(to_string(opt_smt_to));

  redisContext *c = redisConnect("127.0.0.1", 6379);
  bool changed = false;
  for (auto &BB : F) {
    for (auto &I : make_early_inc_range(BB)) {
      if (I.getType()->isVoidTy())
        continue;
      minotaur::Slice S(F, LI, DT, MD);
      auto NewF = S.extractExpr(I);
      auto m = S.getNewModule();

      if (!NewF.has_value())
        continue;

      // if (NewF->get().getReturnType()->isIntegerTy(16))
      //   continue;
      string bytecode;
      if (enable_caching) {
        llvm::raw_string_ostream bs(bytecode);
        WriteBitcodeToFile(*m, bs);
        bs.flush();
        std::string rewrite;
        if (minotaur::hGet(bytecode.c_str(), bytecode.size(), rewrite, c)) {
          if (rewrite == "<no-sol>") {
            if (DEBUG_LEVEL > 0) {
              llvm::errs()<<"*** cache matched, but no solution found in previous run, skipping function: \n";
              (*NewF).get().dump();
            }
            continue;
          }
        }
      }

      minotaur::EnumerativeSynthesis ES;
      if (DEBUG_LEVEL > 0) {
        llvm::errs()<<"*** working on Function:\n";
        (*NewF).get().dump();
      }

      unsigned duration = ( std::clock() - start ) / CLOCKS_PER_SEC;
      if (duration > opt_problem_to) {
        return false;
      }
      auto [R, oldcost, newcost] = ES.synthesize(*NewF, TLI);

      if (enable_caching) {
        if (R) {
          std::stringstream rs;
          R->print(rs);
          rs.flush();
          minotaur::hSet(bytecode.c_str(), bytecode.size(), rs.str(), c, oldcost, newcost, F.getName());
        } else {
          minotaur::hSet(bytecode.c_str(), bytecode.size(), "<no-sol>", c, 0, 0, F.getName());
        }
      }

      if (!R) continue;
      std::unordered_set<llvm::Function *> IntrinsicDecls;
      llvm::Instruction *insertpt = &I;
      while(isa<PHINode>(insertpt)) {
        insertpt = insertpt->getNextNode();
      }

      llvm::Value *V = minotaur::LLVMGen(insertpt, IntrinsicDecls).codeGen(R, S.getValueMap());

      if (Instruction *I = dyn_cast<Instruction>(V)) {
        if (!DT.dominates(I, &BB))
          continue;
      }

      V = llvm::IRBuilder<>(insertpt).CreateBitCast(V, I.getType());
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
    minotaur::eliminate_dead_code(F);
  }
  redisFree(c);
  if (DEBUG_LEVEL > 0)
    llvm::errs()<<"=== end of minotaur run ===\n";
  return changed;
}

struct SuperoptimizerLegacyPass final : public llvm::FunctionPass {
  static char ID;

  SuperoptimizerLegacyPass() : FunctionPass(ID) {}

  bool runOnFunction(llvm::Function &F) override {
    TargetLibraryInfo &TLI =
      getAnalysis<TargetLibraryInfoWrapperPass>().getTLI(F);
    LoopInfo &LI =
      getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
    DominatorTree &DT =
      getAnalysis<DominatorTreeWrapperPass>().getDomTree();
    MemoryDependenceResults &MD =
      getAnalysis<MemoryDependenceWrapperPass>().getMemDep();

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
    MemoryDependenceResults &MD = FAM.getResult<MemoryDependenceAnalysis>(F);
    optimize_function(F, LI, DT, TLI, MD);
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
  PB.registerVectorCombineCallback(
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
