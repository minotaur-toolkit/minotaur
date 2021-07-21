// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include <Slice.h>

#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"

#include <unordered_set>

using namespace llvm;
using namespace std;

namespace minotaur {

Function &Slice::extractExpr(Value &v) {
  // SmallSetVector<const Value *, 8> Worklist;
  SmallVector<Type *, 4> ArgTys;

  unordered_set<Value *> visited;

  BasicBlock *BB = BasicBlock::Create(*ctx, "entry");

  vector<Value *> worklist;
  worklist.push_back(&v);
  while (!worklist.empty()) {
    auto *w = worklist.front();
    worklist.pop_back();
    if (!visited.insert(w).second)
      continue;

    if (Instruction *i = dyn_cast<Instruction>(w)) {
      Instruction *c = i->clone();
      BB->getInstList().push_back(c);

      for (auto &u : i->operands()) {
        worklist.push_back(u);
      }
    } else {
      // Handle other type of values, such as llvm::Argument
    }
  }

  // Create a new function with MyArgs as arguments
  Function *F = Function::Create(FunctionType::get(v.getType(), ArgTys, false),
                                 GlobalValue::ExternalLinkage, v.getName(), *m);

  BB->insertInto(F);
  return *F;
}

} // namespace minotaur