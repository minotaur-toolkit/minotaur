// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "config.h"
#include "removal-slice.h"

#include "llvm/IR/Function.h"

#include <optional>

using namespace llvm;
using namespace std;

namespace minotaur {

optional<reference_wrapper<Function>> RemovalSlice::extractExpr(Value &v) {
  if(config::debug_slicer) {
    llvm::errs() << ">>> slicing value " << v << ">>>\n";
  }
  SmallVector<Type *, 4> argTys;
  Function *F = Function::Create(FunctionType::get(v.getType(), argTys, false),
                                 GlobalValue::ExternalLinkage, "rewrite", *m);
  return optional<reference_wrapper<Function>>(*F);
}

} // namespace minotaur
