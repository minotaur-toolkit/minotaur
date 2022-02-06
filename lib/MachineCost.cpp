// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "MachineCost.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Value.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Object/ObjectFile.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/SmallVectorMemoryBuffer.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include <map>

using namespace llvm;

namespace minotaur {

static unsigned long getCodeSize(Module &M, TargetMachine *TM) {
  M.setDataLayout(TM->createDataLayout());
  SmallVector<char, 256> DotO;
  raw_svector_ostream dest(DotO);

  legacy::PassManager pass;
  if (TM->addPassesToEmitFile(pass, dest, nullptr, CGFT_ObjectFile)) {
    errs() << "Target machine can't emit a file of this type";
    report_fatal_error("oops");
  }
  pass.run(M);

  SmallVectorMemoryBuffer Buf(std::move(DotO));
  auto ObjOrErr = object::ObjectFile::createObjectFile(Buf);
  if (!ObjOrErr)
    report_fatal_error("createObjectFile() failed");
  object::ObjectFile *OF = ObjOrErr.get().get();
  auto SecList = OF->sections();
  MCContext Ctx(Triple);
  long Size = 0;
  for (auto &S : SecList) {
    if (S.isText())
      Size += S.getSize();
  }
  if (Size > 0)
    return Size;
  else
    report_fatal_error("no text segment found");
}

struct TargetInfo {
  std::string Trip, CPU;
};

std::vector<TargetInfo> Targets {
  { "x86_64", "skylake" },
  { "aarch64", "apple-a12" },
};

bool Init = false;

void getCost(llvm::Function *F, BackendCost &BC) {
  // TODO is this better than just forcing all clients of this code to
  // do the init themselves?
  if (!Init) {
    InitializeAllTargetInfos();
    InitializeAllTargets();
    InitializeAllTargetMCs();
    InitializeAllAsmParsers();
    InitializeAllAsmPrinters();
    Init = true;
  }

  BackendCost Cost;
  llvm::LLVMContext C;
  llvm::Module M("", C);

  llvm::errs() << M;

  for (auto &T : Targets) {
    std::string Error;
    auto Target = llvm::TargetRegistry::lookupTarget(T.Trip, Error);
    if (!Target) {
      errs() << Error;
      report_fatal_error("can't lookup target");
    }

    auto Features = "";
    TargetOptions Opt;
    auto RM = Optional<Reloc::Model>();
    auto TM = Target->createTargetMachine(T.Trip, T.CPU, Features, Opt, RM);

    Cost.C.push_back(getCodeSize(M, TM));
  }

  llvm::errs() << "cost vector: ";
  for (auto I : Cost.C) {
    llvm::errs() << I << " ";
  }
  llvm::errs() << "\n";
}

int compare(int A, int B) {
  if (A < B)
    return -1;
  if (A > B)
    return 1;
  return 0;
}

// "The value returned indicates whether the element passed as first
// argument is considered to go before the second"
bool compareCosts(const BackendCost &C1, const BackendCost &C2) {
  assert(C1.C.size() == C2.C.size());

  int Count = 0;
  for (int i = 0; i < C1.C.size(); ++i)
    Count += compare(C1.C[i], C2.C[i]);
  if (Count < 0)
    return true;
  if (Count > 0)
    return false;

  // break ties using souper cost
  // break final ties how? we want a canonical winner for all cases
}

} // namespace souper