// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "cost.h"
#include "utils.h"
#include "cost-command.h"

#include "llvm/ADT/ArrayRef.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Program.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <fstream>
#include <map>
#include <unistd.h>

using namespace llvm;
using namespace std;

namespace minotaur {

bool Init = false;

unsigned get_machine_cost(Function *F) {
  llvm::Module M("", F->getContext());
  auto newF = Function::Create(F->getFunctionType(), F->getLinkage(), "foo", M);

  ValueToValueMapTy VMap;
  for (unsigned i = 0 ; i < F->arg_size() ; ++i) {
    VMap[F->getArg(i)] = newF->getArg(i);
  }

  for (auto &BB : *F) {
    for (auto &I : BB) {
      if (CallInst *CI = dyn_cast<CallInst>(&I)) {
        llvm::Function *callee = CI->getCalledFunction();
        M.getOrInsertFunction(callee->getName(), callee->getFunctionType(),
                              callee->getAttributes());
      }
    }
  }

  SmallVector<ReturnInst*, 8> _;
  CloneFunctionInto(newF, F, VMap, CloneFunctionChangeType::DifferentModule, _);

  eliminate_dead_code(*newF);

  SmallString<64> InputPath;
  {
    int InputFD;
    if (std::error_code EC =
            sys::fs::createTemporaryFile("input", "ll", InputFD, InputPath)) {
      llvm::report_fatal_error("cannot open input buffer");
    }

    std::string module_str;
    raw_string_ostream OS(module_str);
    M.print(OS, nullptr);

    raw_fd_ostream InputFile(InputFD, true,true);
    InputFile << module_str;
    InputFile.close();
    ::close(InputFD);
  }

  SmallString<64> OutputPath;
  {
    int OutputFD;
    if (std::error_code EC =
          sys::fs::createTemporaryFile("output", "out", OutputFD, OutputPath)) {
      llvm::report_fatal_error("cannot open output buffer");
    }
    ::close(OutputFD);
  }

  vector<StringRef> ArgPtrs = {"get-cost", InputPath};
  optional<StringRef> Redirects[3] = { nullopt,
                                       StringRef(OutputPath),
                                       StringRef("/dev/null") };

  int r = sys::ExecuteAndWait(GET_COST_COMMAND, ArgPtrs, nullopt, Redirects, 5);

  if (r) {
    llvm::errs()<<"error when analysizing cost\n";
    return 0;
  }

  unsigned cycle;
  std::ifstream result((std::string(OutputPath)));
  result >> cycle;
  result.close();

  return cycle;
}

// simply count lines of code without bitcast for now
unsigned get_approx_cost(llvm::Function *F) {
  unsigned cost = 0;
  for (auto &BB : *F) {
    for (auto &I : BB) {
      if (isa<BitCastInst>(&I)) {
        cost += 0;
      } else if (CallInst *CI = dyn_cast<CallInst>(&I)) {
        auto CalledF = CI->getCalledFunction();
        if (CalledF && CalledF->getName().startswith("__fksv")) {
          cost += 1;
        } else if (CalledF && CalledF->isIntrinsic()) {
          cost += 1;
        } else {
          cost += 1;
        }
      } else if (isa<ShuffleVectorInst>(&I)) {
        cost += 1;
      } else {
        cost += 1;
      }
    }
  }
  return cost;
}

}