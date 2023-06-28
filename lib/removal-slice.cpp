// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "config.h"
#include "removal-slice.h"
#include "utils.h"

#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Transforms/Utils/Cloning.h"

#include <optional>
#include <string>

using namespace llvm;
using namespace std;

namespace {

struct out {
  template<class T>
  out &operator<<(const T &s)
  {
    if (minotaur::config::debug_slicer)
      llvm::errs()<<s;
    return *this;
  }
};
}

static unsigned remove_unreachable() {
  return 0;
}

namespace minotaur {

optional<reference_wrapper<Function>> RemovalSlice::extractExpr(Value &V) {
  assert(isa<Instruction>(&v) && "Expr to be extracted must be a Instruction");
  out() << "[slicer] slicing value" << V << "\n";

  Instruction *vi = cast<Instruction>(&V);
  BasicBlock *vbb = vi->getParent();
  Loop *loopv = LI.getLoopFor(vbb);
  if (loopv) {
    out() << "[slicer] value is in " << *loopv;
    if (!loopv->isLoopSimplifyForm()) {
      // TODO: continue harvesting within loop boundary, even loop is not in
      // normal form.
      out() << "[slicer] loop is not in normal form\n";
      return nullopt;
    }
  }

  queue<pair<Value *, unsigned>> Worklist;
  SmallSet<BasicBlock*, 4> NonBranchingBBs;

  // initial population of worklist and nonbranchingBBs.
  Worklist.push({&V, 0});
  for (auto &BB : VF) {
    if (&BB == vbb) {
      continue;
    }
    Instruction *T = BB.getTerminator();
    if (isa<BranchInst>(T) || isa<SwitchInst>(T))
      Worklist.push({T, 0});
    else {
      NonBranchingBBs.insert(&BB);
    }
  }

  // recursively populate candidates set
  SmallSet<Value*, 16> Candidates;
  while (!Worklist.empty()) {
    auto &[W, Depth] = Worklist.front();
    Worklist.pop();

    if (Depth > config::slicer_max_depth) {
      if(config::debug_slicer)
        out() << "[INFO] max depth reached, stop harvesting";
      continue;
    }

    if (Instruction *I = dyn_cast<Instruction>(W)) {
      if(!Candidates.insert(W).second)
        continue;

      for (auto &Op : I->operands()) {
        if (!isa<Instruction>(Op))
          continue;
        Worklist.push({Op, Depth + 1});
      }
    }
  }

  SmallVector<Type*, 4> argTys(VF.getFunctionType()->params());

  // TODO: Add more arguments for the new function.
  FunctionType *FTy = FunctionType::get(V.getType(), argTys, false);
  Function *F = Function::Create(FTy, GlobalValue::ExternalLinkage, "foo", *M);

  ValueToValueMapTy VMap;
  Function::arg_iterator TgtArgI = F->arg_begin();

  for (auto I = VF.arg_begin(), E = VF.arg_end(); I != E; ++I, ++TgtArgI) {
    VMap[I] = TgtArgI;
    TgtArgI->setName(I->getName());
    this->mapping[TgtArgI] = I;
  }

  SmallVector<ReturnInst*, 8> _r;
  CloneFunctionInto(F, &VF, VMap, CloneFunctionChangeType::DifferentModule, _r);

  // insert return
  Instruction *NewV = cast<Instruction>(VMap[&V]);
  ReturnInst *Ret = ReturnInst::Create(Ctx, NewV, NewV->getNextNode());

  out() << "[slicer] harvested " << Candidates.size() << " candidates\n";

  for (auto C : Candidates) {
    out() << *C << "\n";
  }

  // remove unreachable code within same block
  SmallSet<Value*, 16> ClonedCandidates;
  for (auto C : Candidates) {
    ClonedCandidates.insert(VMap[C]);
  }

  ClonedCandidates.insert(Ret);
  for (auto &BB : *F) {
    Instruction *RI = &BB.back();
    out()<<*RI<<"\n";
    while (RI) {
      out()<<*RI<<"\n";
      Instruction *Prev = RI->getPrevNode();

      if (!ClonedCandidates.count(RI)) {
        out() << "[slicer] erasing" << *RI << "\n";
        RI->eraseFromParent();
      }
      RI = Prev;
    }
  }

  // handle non-branching BBs
  // * delete all the instructions inside BB
  // * insert unreachable instruction
  for (auto NonBranchingBB : NonBranchingBBs) {
    BasicBlock *BB = cast<BasicBlock>(VMap[NonBranchingBB]);
    new UnreachableInst(Ctx, BB);
  }

  out() << "[slicer] create module " << *M;

  string err;
  llvm::raw_string_ostream err_stream(err);
  bool illformed = verifyFunction(*F, &err_stream);
  if (illformed) {
    llvm::errs() << "[ERROR] found errors in the generated function\n";
    F->dump();
    llvm::errs() << err << "\n";
    llvm::report_fatal_error("illformed function generated");
    return nullopt;
  }

  return optional<reference_wrapper<Function>>(*F);
}

} // namespace minotaur
