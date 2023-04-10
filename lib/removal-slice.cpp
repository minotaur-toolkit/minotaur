// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "config.h"
#include "removal-slice.h"

#include "llvm/ADT/SmallSet.h"
#include "llvm/IR/Function.h"

#include <optional>

using namespace llvm;
using namespace std;

namespace minotaur {

static void remove_unreachable() {

}

optional<reference_wrapper<Function>> RemovalSlice::extractExpr(Value &v) {
  assert(isa<Instruction>(&v) && "Expr to be extracted must be a Instruction");
  if(config::debug_slicer) {
    llvm::errs() << ">>> slicing value " << v << ">>>\n";
  }

  Instruction *vi = cast<Instruction>(&v);
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


  SmallSet<Value*, 16> Harvested;


  queue<pair<Value *, unsigned>> worklist;
  worklist.push({&v, 0});

  while (!worklist.empty()) {
    auto &[w, depth] = worklist.front();
    worklist.pop();

    if (depth > config::slicer_max_depth) {
      if(config::debug_slicer) {
        llvm::errs() << "[INFO] max depth reached, stop harvesting";
      }
  }


  SmallVector<Type *, 4> argTys;
  Function *F = Function::Create(FunctionType::get(v.getType(), argTys, false),
                                 GlobalValue::ExternalLinkage, "rewrite", *m);
  return optional<reference_wrapper<Function>>(*F);
}

} // namespace minotaur
