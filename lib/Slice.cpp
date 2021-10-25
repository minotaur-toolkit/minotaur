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
  assert(isa<Instruction>(&v) && "Expr to be extracted must be a Instruction");
  Instruction *vi = cast<Instruction>(&v);

  LLVMContext &ctx = m->getContext();
  unordered_set<Value *> visited;

  queue<Value *> worklist;
  ValueToValueMapTy vmap;
  vector<Instruction *> cloned_insts;
  vector<Instruction *> insts;
  set<BasicBlock *> blocks;
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
      } else if (isa<PHINode>(i)) {
        havePhi = true;
      }

      Instruction *c = i->clone();
      insts.push_back(i);
      cloned_insts.push_back(c);
      c->setName(getNameOrAsOperand(i) + ".copied");
      vmap[i] = c;
      // BB->getInstList().push_front(c);

      BasicBlock *b = i->getParent();

      bool never_visited = blocks.insert(b).second;
      if (b != vi->getParent() && never_visited) {
        Instruction *term = b->getTerminator();
        assert(isa<BranchInst>(term) && "Unexpected terminator found");
        BranchInst *bi = cast<BranchInst>(term);
        if (bi->isConditional())
          worklist.push(bi->getCondition());
      }

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
  // + duplicate blocks
  set<BasicBlock *> cloned_blocks;
  unordered_map<BasicBlock *, BasicBlock *> bmap;
  if (havePhi) {
    // pass 2.1.1;
    // + duplicate BB;
    for (BasicBlock *orig_bb : blocks) {
      BasicBlock *bb = BasicBlock::Create(ctx, orig_bb->getName());
      bmap[orig_bb] = bb;
      vmap[orig_bb] = bb;
      cloned_blocks.insert(bb);
    }
    // pass 2.1.2:
    // + wire branch
    for (BasicBlock *orig_bb : blocks) {
      if (orig_bb == vi->getParent())
       continue;
      Instruction *term = orig_bb->getTerminator();
      assert(isa<BranchInst>(term) && "Unexpected terminator found");
      BranchInst *bi = cast<BranchInst>(term);

      BranchInst *cloned_bi = nullptr;
      if (bi->isConditional()) {
        //TODO: harvest conditional variable
        cloned_bi = BranchInst::Create(bmap[bi->getSuccessor(0)],
                                       bmap[bi->getSuccessor(1)],
                                       bi->getCondition(),
                                       bmap[orig_bb]);
      } else {
        cloned_bi = BranchInst::Create(bmap[bi->getSuccessor(0)],
                                       bmap[orig_bb]);        
      }
      insts.push_back(bi);
      cloned_insts.push_back(cloned_bi);
      vmap[bi] = cloned_bi;
    }
    // pass 2.1.3:
    // + put in instructions
    for (auto i : insts) {
      if (isa<BranchInst>(i))
        continue;
      bmap[i->getParent()]->getInstList().push_front(cast<Instruction>(vmap[i]));
    }

    // create ret
    ReturnInst *ret = ReturnInst::Create(ctx, vmap[&v]);
    bmap[vi->getParent()]->getInstList().push_back(ret);
  } else {
    // pass 2.2
    // + phi free
    BasicBlock *bb = BasicBlock::Create(ctx, "entry");
    for (auto i : cloned_insts) {
      bb->getInstList().push_front(i);
    }
    ReturnInst *ret = ReturnInst::Create(ctx, vmap[&v]);
    bb->getInstList().push_back(ret);
    cloned_blocks.insert(bb);
  }

  // pass 3;
  // + remap the operands of duplicated instructions with vmap from pass 1
  // + if a operand value is unknown, reserve a function parameter for it
  SmallVector<Type *, 4> argTys;
  DenseMap<Value *, unsigned> argMap;
  unsigned idx = 0;
  for (auto &i : cloned_insts) {
    RemapInstruction(i, vmap, RF_IgnoreMissingLocals);
    for (auto &op : i->operands()) {
      if (isa<Constant>(op)) {
        continue;
      } else if (isa<Argument>(op)) {
          argTys.push_back(op->getType());
          argMap[op.get()] = idx++;
      } else if (Instruction *op_i = dyn_cast<Instruction>(op)) {
        auto unknown = find(cloned_insts.begin(), cloned_insts.end(), op_i);
        if(unknown != cloned_insts.end())
          continue;
        if (!argMap.count(op.get())) {
          argTys.push_back(op->getType());
          argMap[op.get()] = idx++;
        }
      }
    }
  }

  // create function
  auto func_name = "sliced_" + v.getName();
  Function *F = Function::Create(FunctionType::get(v.getType(), argTys, false),
                                 GlobalValue::ExternalLinkage, func_name, *m);

  // pass 4:
  // + replace the use of unknown value with the function parameter
  for (auto &i : cloned_insts) {
    for (auto &op : i->operands()) {
      if (argMap.count(op.get())) {
        op.set(F->getArg(argMap[op.get()]));
      }
    }
  }

  for (auto block : cloned_blocks) {
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