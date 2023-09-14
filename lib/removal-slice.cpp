// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "config.h"
#include "removal-slice.h"
#include "utils.h"

#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/Casting.h"
#include "llvm/Transforms/Utils/Cloning.h"

#include <optional>
#include <string>

using namespace llvm;
using namespace std;

struct debug {
template<class T>
debug &operator<<(const T &s)
{
  if (minotaur::config::debug_slicer)
    llvm::errs()<<s;
  return *this;
}
};

static unsigned remove_unreachable() {
  return 0;
}

namespace minotaur {

optional<reference_wrapper<Function>> RemovalSlice::extractExpr(Value &V) {
  assert(isa<Instruction>(&v) && "Expr to be extracted must be a Instruction");
  debug() << "[slicer] slicing value" << V << "\n";

  if (discarded_at_precheck) {
    debug() << "[slicer] discard flag is set, skip\n";
    return nullopt;
  }

  // only support slicing integer and fp values as of now
  auto scalarTy = V.getType()->getScalarType();
  if (!scalarTy->isIntegerTy() && !scalarTy->isIEEELikeFPTy()) {
    debug() << "[slicer] value is not a integer or fp value, skip\n";
    return nullopt;
  }

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
  SmallSet<Instruction*, 16> Candidates;
  while (!Worklist.empty()) {
    auto &[W, Depth] = Worklist.front();
    Worklist.pop();

    if (Depth > config::slicer_max_depth) {
      debug() << "[slicer] max depth reached, stop harvesting\n";
      continue;
    }

    if (Instruction *I = dyn_cast<Instruction>(W)) {
      auto checkValueUnknown = [](Value *V) {
        if (isa<ConstantExpr>(V)) {
          debug() << "[slicer] found instruction that uses ConstantExpr\n";
          return true;
        }
        Type *ty = V->getType()->getScalarType();
        if (!ty->isIEEELikeFPTy() && !ty->isIntegerTy() && !ty->isLabelTy()) {
          debug() << "[slicer] found operand with type "
                  << *V->getType() << "\n";
          return true;
        }
        return false;
      };

      if (CallInst *CI = dyn_cast<CallInst>(I)) {
        auto callee = CI->getCalledFunction();
        if (!callee || !callee->isIntrinsic()) {
          debug() << "[slicer] unknown callee found "
                  << callee->getName() << "\n";
          continue;
        }
      }

      auto ops = I->operands();

      if (isa<CallInst>(I)) {
        ops = cast<CallInst>(I)->args();
      }

      bool haveUnknownOperand = false;
      for (auto &op : ops) {
        if (checkValueUnknown(op)) {
          haveUnknownOperand = true;
          break;
        }
      }

      if (haveUnknownOperand) {
        continue;
      }
      if(!Candidates.insert(I).second)
        continue;

      for (auto &Op : I->operands()) {
        if (!isa<Instruction>(Op))
          continue;
        Worklist.push({Op, Depth + 1});
      }
    }
  }

  // populate argument list for the new function
  unsigned idx = 0;
  DenseMap<Value *, unsigned> argMap;
  SmallVector<Type *, 4> argTys;
  for (auto &arg : VF.args()) {
    argTys.push_back(arg.getType());
    argMap[&arg] = idx++;
  }

  for (auto I : Candidates) {
    for (auto &op : I->operands()) {
       if (Instruction *op_i = dyn_cast<Instruction>(op)) {
        auto unknown = find(Candidates.begin(), Candidates.end(), op_i);
        if (unknown != Candidates.end())
          continue;
        debug() << *op_i << "\n";

        if (argMap.count(op.get()))
          continue;
        argTys.push_back(op->getType());
        argMap[op.get()] = idx++;
      }
    }
  }

  // TODO: Add more arguments for the new function.
  FunctionType *FTy = FunctionType::get(V.getType(), argTys, false);
  Function *F = Function::Create(FTy, GlobalValue::ExternalLinkage, "slice", *M);

  ValueToValueMapTy VMap;

  for (auto &varg : VF.args()) {
    Argument *arg = F->getArg(argMap[&varg]);
    arg->setName(varg.getName());
    VMap[&varg] = arg;
    mapping[arg] = &varg;
  }

  for (auto C : Candidates) {
    if (CallInst *CI = dyn_cast<CallInst>(C)) {
      Function *callee = CI->getCalledFunction();
      assert(callee->isIntrinsic() && "callee must be an intrinsic");
      FunctionCallee intrindecl =
          M->getOrInsertFunction(callee->getName(), callee->getFunctionType(),
                                  callee->getAttributes());
      VMap[callee] = intrindecl.getCallee();
    }
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

  SmallSet<Instruction*, 16> ClonedCandidates;
  SmallSet<PHINode*, 16> ClonedPhis;

  for (auto C : Candidates) {
    auto NewC = cast<Instruction>(VMap[C]);
    mapping[NewC] = C;
    for (auto &U : C->operands()) {
      if (!isa<Instruction>(U))
        continue;
      if (Candidates.count(cast<Instruction>(U)))
        continue;
      mapping[VMap[U]] = U.get();
    }
    ClonedCandidates.insert(NewC);

    if (isa<PHINode>(NewC)) {
      ClonedPhis.insert(cast<PHINode>(NewC));
    }

    for (auto &op : NewC->operands()) {
      auto vop = mapping[op];
      if (!argMap.count(vop))
        continue;
      op.set(F->getArg(argMap[vop]));
    }
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

  F->removeRetAttr(Attribute::NoAlias);
  F->removeRetAttr(Attribute::NonNull);

  debug() << "[slicer] create module " << *M;

  string err;
  llvm::raw_string_ostream err_stream(err);
  bool illformed = verifyFunction(*F, &err_stream);
  if (illformed) {
    llvm::errs() << "[slicer] found errors in the generated function\n";
    F->dump();
    llvm::errs() << err << "\n";
    llvm::report_fatal_error("illformed function generated");
    return nullopt;
  }

  return optional<reference_wrapper<Function>>(*F);
}

} // namespace minotaur
