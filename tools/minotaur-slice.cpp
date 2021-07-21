// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "Slice.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Error.h"
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
  SMDiagnostic Diag;
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
  sys::PrintStackTraceOnErrorSignal(argv[0]);
  PrettyStackTraceProgram X(argc, argv);
  EnableDebugBuffering = true;
  llvm_shutdown_obj llvm_shutdown; // Call llvm_shutdown() on exit.
  LLVMContext Context;

  cl::ParseCommandLineOptions(argc, argv, "Minotaur Program Slicer\n");

  auto M = openInputFile(Context, opt_file);

  for (auto &F : *M) {
    Slice S(F);
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (I.getType()->isVoidTy())
          continue;
        auto &fs = S.extractExpr(I);
        fs.dump();
      }
    }
  }

  return 0;
}