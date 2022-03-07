// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "EnumerativeSynthesis.h"
#include "LLVMGen.h"
#include "Slice.h"

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

static bool
hGet(const char* s, unsigned sz, std::string &Value, redisContext *c) {
  redisReply *reply = (redisReply *)redisCommand(c, "HGET %b rewrite", s, sz);
  if (!reply || c->err) {
    llvm::report_fatal_error((llvm::StringRef)"redis error" + c->errstr);
    UNREACHABLE();
  }
  if (reply->type == REDIS_REPLY_NIL) {
    freeReplyObject(reply);
    return false;
  } else if (reply->type == REDIS_REPLY_STRING) {
    Value = reply->str;
    freeReplyObject(reply);
    return true;
  } else {
    llvm::report_fatal_error((llvm::StringRef)
      "Redis protocol error for cache lookup, didn't expect reply type "+
      std::to_string(reply->type));
    UNREACHABLE();
  }
}

static void
hSet(const char* s, unsigned sz, llvm::StringRef Value, redisContext *c) {
  redisReply *reply = (redisReply *)redisCommand(c, "HSET %b rewrite %s",
    s, sz, Value.data());
  if (!reply || c->err)
    llvm::report_fatal_error((llvm::StringRef)"Redis error: " + c->errstr);
  if (reply->type != REDIS_REPLY_INTEGER) {
    llvm::report_fatal_error((llvm::StringRef)
      "Redis protocol error for cache fill, didn't expect reply type " +
      std::to_string(reply->type));
  }
  freeReplyObject(reply);
}

static bool
optimize_function(llvm::Function &F, LoopInfo &LI, DominatorTree &DT, TargetLibraryInfo &TLI) {
  redisContext *c = redisConnect("127.0.0.1", 6379);
  for (auto &BB : F) {
    for (auto &I : BB) {
      if (I.getType()->isVoidTy())
        continue;
      minotaur::Slice S(F, LI, DT);
      auto NewF = S.extractExpr(I);

      string bytecode;
      llvm::raw_string_ostream bs(bytecode);
      auto m = S.getNewModule();
      WriteBitcodeToFile(*m, bs);
      bs.flush();
      std::string rewrite;
      if (hGet(bytecode.c_str(), bytecode.size(), rewrite, c)) {
        cout<<rewrite;
      }

      if (!NewF.has_value())
        continue;
      minotaur::EnumerativeSynthesis ES;
      auto [R, constMap] = ES.synthesize(*NewF, TLI);
      if (!R) continue;
      cout<<R->getWidth()<<endl;

      cout<<"foo"<<endl;
      rewrite = "";
      cout<<"foo1"<<endl;
      std::stringstream rs(rewrite);
      cout<<"foo2"<<endl;
      R->print(cout);
      R->print(rs);
      cout<<"fo3"<<endl;
      rs.flush();
      cout<<rewrite<<endl;

      hSet(bytecode.c_str(), bytecode.size(), rewrite, c);
      std::unordered_set<llvm::Function *> IntrinsicDecls;
      llvm::ValueToValueMapTy VMap;
      llvm::Value *V = minotaur::LLVMGen(&I, IntrinsicDecls).codeGen(R, VMap, &constMap);
      V = llvm::IRBuilder<>(&I).CreateBitCast(V, I.getType());
      I.replaceAllUsesWith(V);
    }
  }
  redisFree(c);
  return false;
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