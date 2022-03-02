// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "MachineCost.h"

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

namespace minotaur {

bool Init = false;

unsigned get_machine_cost(llvm::Function *F) {
  llvm::Module M("", F->getContext());
  auto newF = Function::Create(F->getFunctionType(), F->getLinkage(), "foo", M);

  ValueToValueMapTy VMap;
  for (unsigned i = 0 ; i < F->arg_size() ; ++i) {
    VMap[F->getArg(i)] = newF->getArg(i);
  }

  for (auto &BB : *F) {
    for (auto &I : BB) {
      if (CallInst *CI = dyn_cast<CallInst>(&I)) {
        Function *callee = CI->getCalledFunction();
        if (callee->isIntrinsic())
          M.getOrInsertFunction(callee->getName(), callee->getFunctionType(),
                                callee->getAttributes());
      }
    }
  }

  SmallVector<ReturnInst*, 8> Returns;
  CloneFunctionInto(newF, F, VMap, CloneFunctionChangeType::DifferentModule, Returns);

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

  int retval = sys::ExecuteAndWait("/home/liuz/minotaur/build/get-cost", ArgPtrs, None, Redirects, 5);

  if (retval)
    llvm::report_fatal_error("error when analysizing cost");

  unsigned cycle;
  std::ifstream result((std::string(OutputPath)));
  result >> cycle;
  result.close();

  return cycle;
}
}