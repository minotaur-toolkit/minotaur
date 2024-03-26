// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "alive-interface.h"
#include "expr.h"

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
#include "llvm/ADT/STLExtras.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
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

using namespace llvm;

static cl::OptionCategory minotaur_cs("minotaur-cs options");

static cl::opt<string> opt_file(
    cl::Positional, cl::desc("bitcode_file"), cl::Required,
    cl::value_desc("filename"), cl::cat(minotaur_cs));

static cl::opt<bool> opt_debug(
    "dbg", cl::desc("Alive: print debugging info"),
    cl::cat(minotaur_cs), cl::init(false));

static cl::opt<bool> opt_disable_undef("disable-undef-input",
    cl::init(true), cl::cat(minotaur_cs),
    cl::desc("Alive: Assume inputs are not undef (default=true)"));

static cl::opt<bool> opt_disable_poison("disable-poison-input",
    cl::init(true), cl::cat(minotaur_cs),
    cl::desc("Alive: Assume inputs are not poison (default=true)"));

static cl::opt<bool> opt_smt_verbose(
    "smt-verbose", cl::desc("Alive: SMT verbose mode"),
    cl::cat(minotaur_cs), cl::init(false));

static cl::opt<bool> opt_smt_stats(
    "smt-stats", cl::desc("Alive: show SMT statistics"),
    cl::cat(minotaur_cs), cl::init(false));

static cl::opt<unsigned> opt_smt_to(
    "smt-to", cl::desc("Timeout for SMT queries (default=10000)"),
    cl::cat(minotaur_cs),
    cl::init(10000), cl::value_desc("ms"));

static ExitOnError ExitOnErr;

// adapted from llvm-dis.cpp
static std::unique_ptr<Module> openInputFile(LLVMContext &Context,
                                                   string InputFilename) {
  auto MB =
    ExitOnErr(errorOrToExpected(MemoryBuffer::getFile(InputFilename)));
  SMDiagnostic Diag;
  auto M = getLazyIRModule(std::move(MB), Diag, Context,
                           /*ShouldLazyLoadMetadata=*/true);
  if (!M) {
    Diag.print("", errs(), false);
    return 0;
  }
  ExitOnErr(M->materializeAll());
  return M;
}

static Function *findFunction(Module &M, const string &FName) {
  for (auto &F : M) {
    if (F.isDeclaration())
      continue;
    if (FName.compare(F.getName()) != 0)
      continue;
    return &F;
  }
  return nullptr;
}

int main(int argc, char **argv) {
  sys::PrintStackTraceOnErrorSignal(argv[0]);
  PrettyStackTraceProgram X(argc, argv);
  EnableDebugBuffering = true;
  llvm_shutdown_obj llvm_shutdown;  // Call llvm_shutdown() on exit.
  LLVMContext Context;

  cl::ParseCommandLineOptions(argc, argv,
                                    "Minotaur stand-alone Constant Synthesizer\n");

  smt::set_query_timeout(to_string(opt_smt_to));
  smt::solver_print_queries(opt_smt_verbose);
  config::disable_undef_input = opt_disable_undef;
  config::disable_poison_input = opt_disable_poison;
  config::debug = opt_debug;

  auto M = openInputFile(Context, opt_file);
  if (!M.get())
    report_fatal_error(
      Twine("could not read bitcode from '" + opt_file + "'"));

  auto targetTriple = Triple(M.get()->getTargetTriple());
  TargetLibraryInfoWrapperPass TLI(targetTriple);

  auto SRC = findFunction(*M, "src");
  if (!SRC)
    report_fatal_error("could not find function in src");

  auto TGT = findFunction(*M, "tgt");
  if (!TGT)
    report_fatal_error("could not find function in tgt");

  auto check_name = [](Argument &A) {
    return A.getName().startswith("_reservedc");
  };
  if (!any_of(SRC->args(), check_name))
    report_fatal_error("could not find reservedconst argument in src");
  if (!any_of(TGT->args(), check_name))
    report_fatal_error("could not find reservedconst argument in tgt");

  minotaur::config::debug_tv = true;
  unordered_map<Argument*, Constant*> constMap;
  minotaur::AliveEngine AE(TLI, true);
  try {
    AE.constantSynthesis(*SRC, *TGT, constMap);
  } catch (AliveException e) {
    std::cerr<<e.msg<<endl;
  }

  if (opt_smt_stats)
    smt::solver_print_stats(cerr);

  return 0;
}
