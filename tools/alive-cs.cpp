// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "lib/constantsynth.h"
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

#include <iostream>
#include <unordered_set>
#include <sstream>

using namespace tools;
using namespace util;
using namespace std;

static llvm::cl::OptionCategory opt_alive("Alive options");

static llvm::cl::opt<string>
opt_file1(llvm::cl::Positional, llvm::cl::desc("first_bitcode_file"),
    llvm::cl::Required, llvm::cl::value_desc("filename"),
    llvm::cl::cat(opt_alive));

static llvm::cl::opt<string>
opt_file2(llvm::cl::Positional, llvm::cl::desc("second_bitcode_file"),
    llvm::cl::Required, llvm::cl::value_desc("filename"),
    llvm::cl::cat(opt_alive));

static llvm::cl::opt<bool> opt_debug(
    "dbg", llvm::cl::desc("Alive: print debugging info"),
    llvm::cl::cat(opt_alive), llvm::cl::init(false));

static llvm::cl::opt<bool> opt_disable_undef("disable-undef-input",
    llvm::cl::init(false), llvm::cl::cat(opt_alive),
    llvm::cl::desc("Alive: Assume inputs are not undef (default=false)"));

static llvm::cl::opt<bool> opt_disable_poison("disable-poison-input",
    llvm::cl::init(false), llvm::cl::cat(opt_alive),
    llvm::cl::desc("Alive: Assume inputs are not poison (default=false)"));

static llvm::cl::opt<bool> opt_smt_verbose(
    "smt-verbose", llvm::cl::desc("Alive: SMT verbose mode"),
    llvm::cl::cat(opt_alive), llvm::cl::init(false));

static llvm::cl::opt<bool> opt_smt_stats(
    "smt-stats", llvm::cl::desc("Alive: show SMT statistics"),
    llvm::cl::cat(opt_alive), llvm::cl::init(false));

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

int main(int argc, char **argv) {
  llvm::sys::PrintStackTraceOnErrorSignal(argv[0]);
  llvm::PrettyStackTraceProgram X(argc, argv);
  llvm::EnableDebugBuffering = true;
  llvm::llvm_shutdown_obj llvm_shutdown;  // Call llvm_shutdown() on exit.
  llvm::LLVMContext Context;

  llvm::cl::ParseCommandLineOptions(argc, argv,
                                    "Alive2 stand-alone constant synthesizer\n");

  smt::solver_print_queries(opt_smt_verbose);
  //TODO:
  config::disable_undef_input = true; (void)opt_disable_undef;
  config::disable_poison_input = true; (void)opt_disable_poison;

  config::debug = opt_debug;

  auto M1 = openInputFile(Context, opt_file1);
  if (!M1.get())
    llvm::report_fatal_error(
      "Could not read bitcode from '" + opt_file1 + "'");

  auto M2 = openInputFile(Context, opt_file2);
  if (!M2.get())
    llvm::report_fatal_error(
      "Could not read bitcode from '" + opt_file2 + "'");

  if (M1.get()->getTargetTriple() != M2.get()->getTargetTriple())
    llvm::report_fatal_error("Modules have different target triple");

  //auto &DL = M1.get()->getDataLayout();
  auto targetTriple = llvm::Triple(M1.get()->getTargetTriple());

  llvm::Function &F1 = *(M1.get()->getFunction("foo"));
  llvm::Function &F2 = *(M2.get()->getFunction("foo"));

  unsigned /*goodCount = 0, badCount = 0,*/ errorCount = 0;
  auto Func1 = llvm_util::llvm2alive(F1, llvm::TargetLibraryInfoWrapperPass(targetTriple)
                                       .getTLI(F1));

  if (!Func1) {
    cerr << "ERROR: Could not translate '" << F1.getName().str()
         << "' to Alive IR\n";
    ++errorCount;
    return true;
  }

  auto Func2 = llvm_util::llvm2alive(F2, llvm::TargetLibraryInfoWrapperPass(targetTriple)
                                       .getTLI(F2), Func1->getGlobalVarNames());
  if (!Func2) {
    cerr << "ERROR: Could not translate '" << F2.getName().str()
         << "' to Alive IR\n";
    ++errorCount;
    return true;
  }

  smt::smt_initializer smt_init;
  smt_init.reset();

  Transform t;
  t.src = move(*Func1);
  t.tgt = move(*Func2);
  vectorsynth::ConstantSynth tv(t, false);
  TransformPrintOpts print_opts;
  t.print(cout, print_opts);

  unordered_map<const IR::Input*, smt::expr> rmap;
  Errors errs = tv.synthesize(rmap);
  bool result(errs);
  if (result) {
    cerr << errs << endl;
    ++errorCount;
  }

  if (opt_smt_stats)
    smt::solver_print_stats(cerr);

  return result;
}
