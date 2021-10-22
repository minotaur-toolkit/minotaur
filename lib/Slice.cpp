// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "util/compiler.h"
#include <Slice.h>

#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <queue>
#include <set>
#include <sstream>
#include <unordered_map>
#include <unordered_set>

using namespace llvm;
using namespace std;

// TODO: add search depth limitation
// static constexpr unsigned slice_depth = 5;

static void cfgWalk(BasicBlock *bb) {
  vector<BasicBlock *> workList;

  workList.push_back(bb);

  while (!workList.empty()) {
    auto b = workList.front();
    workList.pop_back();

    for (BasicBlock *pred : predecessors(b)) {
      workList.push_back(pred);
    }
  }
}

namespace {
std::string getNameOrAsOperand(Value *v) {
  if (!v->getName().empty())
    return std::string(v->getName());

  std::string BBName;
  raw_string_ostream OS(BBName);
  v->printAsOperand(OS, false);
  return "v" + OS.str().substr(1);
}
} // namespace

namespace minotaur {

optional<std::reference_wrapper<Function>> Slice::extractExpr(Value &v) {
  assert(isa<Instruction>(&v));

  LLVMContext &ctx = m->getContext();
  unordered_set<Value *> visited;

  if (Instruction *i = dyn_cast<Instruction>(&v)) {
    // cfgWalk(i->getParent());
  }

  queue<Value *> worklist;
  ValueToValueMapTy vmap;
  vector<Instruction *> copiedinsts;
  set<BasicBlock *> blockstocopy;
  worklist.push(&v);

  bool havePhi = false;
  // pass 1;
  // + duplicate instructions, leave the operands untouched
  // + if there are intrinsic calls, create declares in the new module
  while (!worklist.empty()) {
    auto *w = worklist.front();
    worklist.pop();
    if (!visited.insert(w).second)
      continue;

    if (Instruction *i = dyn_cast<Instruction>(w)) {
      if (CallInst *ci = dyn_cast<CallInst>(i)) {
        Function *callee = ci->getCalledFunction();
        if (!callee->isIntrinsic()) {
          llvm::errs() << "unknown callee found " << callee->getName() << "\n";
          continue;
        }
        FunctionCallee intrindecl =
            m->getOrInsertFunction(callee->getName(), callee->getFunctionType(),
                                   callee->getAttributes());

        vmap[callee] = intrindecl.getCallee();
      } else if (PHINode *phi = dyn_cast<PHINode>(i)) {
        havePhi = true;
      }

      Instruction *c = i->clone();
      blockstocopy.insert(i->getParent());

      /*
      BasicBlock *origBB = i->getParent();
      BasicBlock *BB = nullptr;
      if (!bmap.count(i->getParent())) {
        BB = BasicBlock::Create(ctx, i->getParent()->getName());
        bmap[origBB] = BB;
      } else {
        BB = bmap.at(i->getParent());
      }*/
      /*
      if (i == &v) {
        ReturnInst *ret = ReturnInst::Create(ctx, c);
        BB->getInstList().push_front(ret);
      }*/
      copiedinsts.push_back(c);
      c->setName(getNameOrAsOperand(i) + ".copied");
      vmap[i] = c;
      // BB->getInstList().push_front(c);

      for (auto &op : i->operands()) {
        worklist.push(op);
      }
    } else if (isa<Constant>(w) || isa<Argument>(w)) {
      continue;
    } else {
      llvm::errs() << "Unhandled value founded:" << w->getName() << "\n";
      UNREACHABLE();
    }
  }

  // pass 2
  // + copy blocks
  set<BasicBlock *> blocks;
  unordered_map<BasicBlock *, BasicBlock *> bmap;
  // handle BBs
  if (havePhi) {
    // pass 1;
    // + duplicate BB;
    for (BasicBlock *origBB : blockstocopy) {
      BasicBlock *bb = BasicBlock::Create(ctx, origBB->getName());
      bmap[origBB] = bb;
    }
    // pass 2:
    // wire branch
    for (BasicBlock *origBB : blockstocopy) {
      Instruction *term = origBB->getTerminator();
      assert(isa<BranchInst>(term));

      

      //BranchInst(BB)
    }
    //llvm::report_fatal_error("working");
  } else {
    // Phi free
    BasicBlock *bb = BasicBlock::Create(ctx, "entry");
    for (auto i : copiedinsts) {
      bb->getInstList().push_front(i);
    }
    ReturnInst *ret = ReturnInst::Create(ctx, vmap[&v]);
    bb->getInstList().push_back(ret);
    blocks.insert(bb);
  }



  // pass 3;
  // + remap the operands of duplicated instructions with vmap from pass 1
  // + if a operand value is unknown, reserve a function parameter for it
  SmallVector<Type *, 4> argTys;
  DenseMap<Value *, unsigned> argMap;
  unsigned idx = 0;
  for (auto &i : copiedinsts) {
    RemapInstruction(i, vmap, RF_IgnoreMissingLocals);
    for (auto &op : i->operands()) {
      if (isa<Constant>(op)) {
        continue;
      } else if (Argument *op_i = dyn_cast<Argument>(op)) {
          argTys.push_back(op->getType());
          argMap[op.get()] = idx++;
      } else if (Instruction *op_i = dyn_cast<Instruction>(op)) {
        if(find(copiedinsts.begin(), copiedinsts.end(), op_i) != copiedinsts.end())
          continue;
        if (!argMap.count(op.get())) {
          argTys.push_back(op->getType());
          argMap[op.get()] = idx++;
        }
      }
    }
  }

  /*
    for (auto &i : *BB) {
      // copy declaration of callee if needed
      if (CallInst *ci = dyn_cast<CallInst>(&i)) {
        Function *callee = ci->getCalledFunction();
        if (!callee->isIntrinsic()) {
          return std::nullopt;
        }

      }
    }
  */

  // create function
  auto func_name = "sliced_" + v.getName();
  Function *F = Function::Create(FunctionType::get(v.getType(), argTys, false),
                                 GlobalValue::ExternalLinkage, func_name, *m);

  // pass 3:
  // + replace the use of unknown value with the function parameter
  for (auto &i : copiedinsts) {
    for (auto &op : i->operands()) {
      if (argMap.count(op.get())) {
        op.set(F->getArg(argMap[op.get()]));
      }
    }
  }

  for (auto block : blocks) {
    block->insertInto(F);
  }

  llvm::errs() << ">>> slicing value %" << v.getName() << " >>>\n";
  F->dump();

  // validate the created function
  string err;
  llvm::raw_string_ostream err_stream(err);
  bool illformed = llvm::verifyFunction(*F, &err_stream);
  if (illformed) {
    llvm::errs() << "=== found errors in the generated function ===\n";
    llvm::errs() << err << "\n";
  }
  llvm::errs() << "<<< end of %" << v.getName() << " <<<\n";
  return std::optional<std::reference_wrapper<Function>>(*F);
}

} // namespace minotaur