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
#include "llvm/Support/Casting.h"
#include "llvm/Transforms/Utils/Cloning.h"

#include <optional>
#include <string>

using namespace llvm;
using namespace std;

namespace {
struct debug {
template<class T>
debug &operator<<(const T &s)
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
  debug() << "[slicer] slicing value" << V << "\n";

  Instruction *vi = cast<Instruction>(&V);
  BasicBlock *vbb = vi->getParent();
  Loop *loopv = LI.getLoopFor(vbb);
  if (loopv) {
    debug() << "[slicer] value is in " << *loopv;
    if (!loopv->isLoopSimplifyForm()) {
      // TODO: continue harvesting within loop boundary, even loop is not in
      // normal form.
      debug() << "[slicer] loop is not in normal form\n";
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
      debug() << "[slicer] max depth reached, stop harvesting";
      continue;
    }

    if (Instruction *I = dyn_cast<Instruction>(W)) {
      auto checkValueUnknown = [] (Value *V) {
        if (isa<ConstantExpr>(V)) {
          debug() << "[slicer] found instruction that uses ConstantExpr\n";
          return true;
        }
        Type *ty = V->getType();;
        if (ty->isStructTy() || ty->isFloatingPointTy() || ty->isPointerTy()) {
          debug() << "[slicer] found operands with type " << *ty;
          return true;
        }
        return false;
      };

      auto range = I->operands();
      if (isa<CallInst>(I))
        range = cast<CallInst>(I)->args();

      bool haveUnknownOperand = false;
      for (auto &op : range) {
        if (checkValueUnknown(op)) {
          haveUnknownOperand = true;
          break;
        }
      }
      if (haveUnknownOperand) {
        continue;
      }
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

  debug() << "[slicer] harvested " << Candidates.size() << " candidates\n";

  for (auto C : Candidates) {
    debug() << *C << "\n";
  }

  // remove unreachable code within same block
  SmallSet<Value*, 16> ClonedCandidates;
  for (auto C : Candidates) {
    ClonedCandidates.insert(VMap[C]);
    mapping[VMap[C]] = C;
  }

  ClonedCandidates.insert(Ret);

  debug() <<"[slicer] function before instruction delection\n"<< *F;

  for (auto &BB : *F) {
    Instruction *RI = &BB.back();
    while (RI) {
      Instruction *Prev = RI->getPrevNode();

      if (!ClonedCandidates.count(RI)) {
        debug() << "[slicer] erasing" << *RI << "\n";
        while(!RI->use_empty())
          RI->replaceAllUsesWith(PoisonValue::get(RI->getType()));
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

  debug() << "[slicer] create module " << *M;

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
