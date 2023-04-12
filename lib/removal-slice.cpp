// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "config.h"
#include "removal-slice.h"
#include "utils.h"

#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Transforms/Utils/Cloning.h"

#include <optional>

using namespace llvm;
using namespace std;

static unsigned remove_unreachable() {
  return 0;
}

namespace minotaur {

optional<reference_wrapper<Function>> RemovalSlice::extractExpr(Value &V) {
  assert(isa<Instruction>(&v) && "Expr to be extracted must be a Instruction");
  if(config::debug_slicer) {
    llvm::errs() << ">>> slicing value " << V << ">>>\n";
  }

  Instruction *vi = cast<Instruction>(&V);
  BasicBlock *vbb = vi->getParent();
  Loop *loopv = LI.getLoopFor(vbb);
  if (loopv) {
    if(config::debug_slicer) {
      llvm::errs() << "[INFO] value is in " << *loopv;
    }
    if (!loopv->isLoopSimplifyForm()) {
      // TODO: continue harvesting within loop boundary, even loop is not in
      // normal form.
      if(config::debug_slicer) {
        llvm::errs() << "[INFO] loop is not in normal form\n";
      }
      return nullopt;
    }
  }

  SmallSet<Value*, 16> Candidates;

  queue<pair<Value *, unsigned>> Worklist;
  Worklist.push({&V, 0});
  SmallSet<BasicBlock*, 4> NonBranchingBBs;

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

  while (!Worklist.empty()) {
    auto &[W, Depth] = Worklist.front();
    Worklist.pop();

    if (Depth > config::slicer_max_depth) {
      if(config::debug_slicer)
        llvm::errs() << "[INFO] max depth reached, stop harvesting";
      continue;
    }

    if (Instruction *I = dyn_cast<Instruction>(W)) {
      Candidates.insert(W);
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

  llvm::errs()<<Candidates.size()<<"\n";
  for (auto C : Candidates) {
    C->dump();
  }
  // remove unreachable code within same block
  SmallSet<Value*, 16> ClonedCandidates;
  for (auto C : Candidates) {
    ClonedCandidates.insert(VMap[C]);
  }

  ClonedCandidates.insert(Ret);
  for (auto &BB : *F) {
    Instruction *RI = &BB.back();
    RI->dump();
    while (RI) {
      RI->dump();
      Instruction *Prev = RI->getPrevNode();

      if (!ClonedCandidates.count(RI)) {
        llvm::errs()<<"erase "<<*RI<<"\n";
        llvm::errs()<<ClonedCandidates.count(RI)<<"\n";
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

  llvm::errs()<<"M->dump() for slice value ";
  M->dump();
  llvm::errs()<<"end of m dump\n";

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
