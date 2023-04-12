// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "config.h"
#include "removal-slice.h"
#include "utils.h"

#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
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

  SmallSet<Value*, 16> Insts;


  queue<pair<Value *, unsigned>> Worklist;
  Worklist.push({&V, 0});

  while (!Worklist.empty()) {
    auto &[W, Depth] = Worklist.front();
    Worklist.pop();

    if (Depth > config::slicer_max_depth) {
      if(config::debug_slicer)
        llvm::errs() << "[INFO] max depth reached, stop harvesting";
      continue;
    }

    if (Instruction *I = dyn_cast<Instruction>(W)) {
      bool haveUnknownOperand = false;
      for (unsigned op_i = 0; op_i < I->getNumOperands(); ++op_i ) {
        if (isa<CallInst>(I) && op_i == 0) {
          continue;
        }

        auto op = I->getOperand(op_i);
        if (isa<ConstantExpr>(op)) {
          if(config::debug_slicer)
            llvm::errs() << "[INFO] found instruction that uses ConstantExpr\n";
          haveUnknownOperand = true;
          break;
        }
        auto op_ty = op->getType();
        if (op_ty->isStructTy() || op_ty->isFloatingPointTy() || op_ty->isPointerTy()) {
          if(config::debug_slicer)
            llvm::errs() << "[INFO] found instruction with operands with type "
                         << *op_ty <<"\n";
          haveUnknownOperand = true;
          break;
        }
      }

      if (haveUnknownOperand) {
        continue;
      }

      Insts.insert(W);
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

  // remove unreachable code within same block
  Instruction *RI = &NewV->getParent()->back();
  RI->dump();
  while (RI != Ret) {
    RI->dump();
    Instruction *Prev = RI->getPrevNode();
    RI->eraseFromParent();
    RI = Prev;
  }

  //eliminate_dead_code(*F);

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
