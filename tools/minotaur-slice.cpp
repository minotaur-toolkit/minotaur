// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "Slice.h"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/SourceMgr.h"

using namespace std;
using namespace llvm;
using namespace minotaur;

static cl::OptionCategory minotaur_slice("minotaur-slice options");

static cl::opt<string> opt_file(cl::Positional, cl::desc("bitcode_file"),
                                cl::Required, cl::value_desc("filename"),
                                cl::cat(minotaur_slice));

static llvm::ExitOnError ExitOnErr;

// adapted from llvm-dis.cpp
static std::unique_ptr<Module> openInputFile(LLVMContext &Context,
                                             string InputFilename) {
  auto MB = ExitOnErr(errorOrToExpected(MemoryBuffer::getFile(InputFilename)));
  llvm::SMDiagnostic Diag;
  auto M = getLazyIRModule(move(MB), Diag, Context,
                           /*ShouldLazyLoadMetadata=*/true);
  if (!M) {
    Diag.print("", llvm::errs(), false);
    return 0;
  }
  ExitOnErr(M->materializeAll());
  return M;
}

int main(int argc, char **argv) {
  llvm::sys::PrintStackTraceOnErrorSignal(argv[0]);
  llvm::PrettyStackTraceProgram X(argc, argv);
  llvm::EnableDebugBuffering = true;
  llvm::llvm_shutdown_obj llvm_shutdown; // Call llvm_shutdown() on exit.
  llvm::LLVMContext Context;

  llvm::cl::ParseCommandLineOptions(argc, argv, "Minotaur Program Slicer\n");

  auto M = openInputFile(Context, opt_file);

  for (auto &F : *M) {
    if (F.isDeclaration())
      continue;

    llvm::PassBuilder PB;
    llvm::FunctionAnalysisManager FAM;
    PB.registerFunctionAnalyses(FAM);

    //FAM.registerPass(llvm::LoopInfo());
    LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);
    DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);
    PostDominatorTree &PDT = FAM.getResult<PostDominatorTreeAnalysis>(F);

    Slice S(F, LI, DT, PDT);
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (I.getType()->isVoidTy())
          continue;
        auto fs = S.extractExpr(I);
        (void)fs;
        // fs.dump();
      }
    }
    std::error_code EC;
    string filename = "slice_" + string(F.getName()) + ".bc";
    llvm::raw_fd_ostream OS(filename, EC, sys::fs::OpenFlags::OF_None);
    WriteBitcodeToFile(*S.getNewModule(), OS);
    OS.flush();
  }
  // M->dump();

  return 0;
}