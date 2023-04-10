// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "config.h"
#include "removal-slice.h"

#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Value.h"
#include "llvm/Transforms/Utils/Cloning.h"

#include <optional>

using namespace llvm;
using namespace std;

namespace minotaur {

static void remove_unreachable() {

}

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

  SmallVector<Type *, 4> argTys;

  llvm::SmallVector<llvm::ReturnInst*, 8> _returns;

  Function *F = Function::Create(FunctionType::get(V.getType(), argTys, false),
                                 GlobalValue::ExternalLinkage, "rewrite", *M);
  ValueToValueMapTy VMap;
  llvm::CloneFunctionInto(F, &VF, VMap,
    llvm::CloneFunctionChangeType::LocalChangesOnly, _returns);


  return optional<reference_wrapper<Function>>(*F);
}

} // namespace minotaur
