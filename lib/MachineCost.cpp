// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "MachineCost.h"
#include "Utils.h"
#include "GetCost.h"

#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
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

unsigned get_machine_cost(llvm::Function *F) {
  llvm::Module M("", F->getContext());
  auto newF = llvm::Function::Create(F->getFunctionType(), F->getLinkage(), "foo", M);

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

  SmallVector<ReturnInst*, 8> Returns;
  CloneFunctionInto(newF, F, VMap, CloneFunctionChangeType::DifferentModule, Returns);

  eliminate_dead_code(*newF);

  int InputFD;
  SmallString<64> InputPath;
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
  int OutputFD;
  SmallString<64> OutputPath;
  if (std::error_code EC =
          sys::fs::createTemporaryFile("output", "out", OutputFD,
                                        OutputPath)) {
    llvm::report_fatal_error("cannot open output buffer");
  }
  ::close(OutputFD);

  std::vector<StringRef> ArgPtrs = {"get-cost", InputPath};
  Optional<StringRef> Redirects[3] = {None, StringRef(OutputPath), StringRef("/dev/null")};

  int retval = sys::ExecuteAndWait(GET_COST_COMMAND, ArgPtrs, None, Redirects, 5);

  if (retval)
    llvm::report_fatal_error("error when analysizing cost");

  unsigned cycle;
  std::ifstream result((std::string(OutputPath)));
  result >> cycle;
  result.close();

  return cycle;
}

unsigned get_approx_cost(llvm::Function *F) {
  unsigned cost = 0;
  for (auto &BB : *F) {
    for (auto &I : BB) {
      if (isa<BitCastInst>(I)) {
        cost += 1;
      } else if (isa<CallInst>(I)){
        cost += 1;
      } else {
        cost += 5;
      }
    }
  }
  return cost;
}

bool ac_cmp(const tuple<llvm::Function*, llvm::Function*, Inst*, bool> &f1,
            const tuple<llvm::Function*, llvm::Function*, Inst*, bool> &f2) {
  return get_approx_cost(get<0>(f1)) < get_approx_cost(get<0>(f2));
}


}