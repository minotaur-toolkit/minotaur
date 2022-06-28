// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "AliveInterface.h"
#include "Expr.h"
#include "ir/type.h"
#include "ir/instr.h"
#include "ir/function.h"
#include "ir/globals.h"
#include "smt/smt.h"
#include "smt/solver.h"
#include "tools/transform.h"
#include "util/config.h"
#include "util/symexec.h"
#include "util/errors.h"
#include "llvm_util/llvm2alive.h"

#include "llvm/ADT/Triple.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Bitcode/BitcodeReader.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Function.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/SourceMgr.h"

#include <iostream>
#include <unordered_set>
#include <sstream>

using namespace tools;
using namespace util;
using namespace std;

static llvm::cl::OptionCategory minotaur_cs("minotaur-cs options");

static llvm::cl::opt<string>
opt_file(llvm::cl::Positional, llvm::cl::desc("bitcode_file"),
    llvm::cl::Required, llvm::cl::value_desc("filename"),
    llvm::cl::cat(minotaur_cs));

static llvm::cl::opt<bool> opt_debug(
    "dbg", llvm::cl::desc("Alive: print debugging info"),
    llvm::cl::cat(minotaur_cs), llvm::cl::init(false));

// static llvm::cl::opt<bool> opt_disable_undef("disable-undef-input",
//     llvm::cl::init(false), llvm::cl::cat(minotaur_cs),
//     llvm::cl::desc("Alive: Assume inputs are not undef (default=false)"));

// static llvm::cl::opt<bool> opt_disable_poison("disable-poison-input",
//     llvm::cl::init(false), llvm::cl::cat(minotaur_cs),
//     llvm::cl::desc("Alive: Assume inputs are not poison (default=false)"));

static llvm::cl::opt<bool> opt_smt_verbose(
    "smt-verbose", llvm::cl::desc("Alive: SMT verbose mode"),
    llvm::cl::cat(minotaur_cs), llvm::cl::init(false));

static llvm::cl::opt<bool> opt_smt_stats(
    "smt-stats", llvm::cl::desc("Alive: show SMT statistics"),
    llvm::cl::cat(minotaur_cs), llvm::cl::init(false));

static llvm::ExitOnError ExitOnErr;

// adapted from llvm-dis.cpp
static std::unique_ptr<llvm::Module> openInputFile(llvm::LLVMContext &Context,
                                                   string InputFilename) {
  auto MB =
    ExitOnErr(errorOrToExpected(llvm::MemoryBuffer::getFile(InputFilename)));
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

void calculateAndInitConstants(Transform &t);

static llvm::Function *findFunction(llvm::Module &M, const string &FName) {
  for (auto &F : M) {
    if (F.isDeclaration())
      continue;
    if (FName.compare(F.getName()) != 0)
      continue;
    return &F;
  }
  return 0;
}

int main(int argc, char **argv) {
  llvm::sys::PrintStackTraceOnErrorSignal(argv[0]);
  llvm::PrettyStackTraceProgram X(argc, argv);
  llvm::EnableDebugBuffering = true;
  llvm::llvm_shutdown_obj llvm_shutdown;  // Call llvm_shutdown() on exit.
  llvm::LLVMContext Context;

  llvm::cl::ParseCommandLineOptions(argc, argv,
                                    "Minotaur stand-alone Constant Synthesizer\n");

  //smt::solver_print_queries(opt_smt_verbose);
  config::disable_undef_input = true;
  config::disable_poison_input = true;

  config::debug = opt_debug;
  auto M = openInputFile(Context, opt_file);
  if (!M.get())
    llvm::report_fatal_error(
      llvm::Twine("Could not read bitcode from '" + opt_file + "'"));

  //auto &DL = M1.get()->getDataLayout();
  auto targetTriple = llvm::Triple(M.get()->getTargetTriple());

  auto SRC = findFunction(*M, "src");
  auto TGT = findFunction(*M, "tgt");
  unsigned goodCount = 0, badCount = 0, errorCount = 0;
  auto Func1 =
    llvm_util::llvm2alive(*SRC, llvm::TargetLibraryInfoWrapperPass(targetTriple)
                                .getTLI(*SRC));

  if (!Func1) {
    cerr << "ERROR: Could not translate '" << SRC->getName().str()
         << "' to Alive IR\n";
    ++errorCount;
    return 1;
  }

  auto Func2 =
    llvm_util::llvm2alive(*TGT, llvm::TargetLibraryInfoWrapperPass(targetTriple)
                                .getTLI(*TGT));
  if (!Func2) {
    cerr << "ERROR: Could not translate '" << TGT->getName().str()
         << "' to Alive IR\n";
    ++errorCount;
    return 1;
  }

  minotaur::debug_tv = true;
  std::unordered_map<const IR::Value *, minotaur::ReservedConst*> rmap;
  minotaur::AliveEngine AE;
  try {
    AE.constantSynthesis(*Func1, *Func2, goodCount, badCount, errorCount, rmap);
  } catch (AliveException e) {
    std::cerr<<e.msg<<endl;
  }

  if (opt_smt_stats)
    smt::solver_print_stats(cerr);

  return 0;
}
