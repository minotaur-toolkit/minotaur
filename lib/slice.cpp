// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "util/compiler.h"
#include "util/sort.h"
#include "config.h"
#include "slice.h"
#include "utils.h"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <functional>
#include <optional>
#include <queue>
#include <unordered_map>
#include <unordered_set>

using namespace llvm;
using namespace std;

struct debug {
  template<class T>
  debug &operator<<(const T &s)
  {
    if (minotaur::config::debug_slicer)
      minotaur::config::dbg()<<s;
    return *this;
  }
};


// place instructions within a basicblock with topology sort
static bool cmp(const pair<Instruction*, unsigned>& lhs,
                const pair<Instruction*, unsigned>& rhs) {
  return lhs.second < rhs.second;
}

static vector<Instruction*>
schedule_insts(vector<pair<Instruction*, unsigned>> &iis) {
  std::sort(iis.begin(), iis.end(), cmp);

  vector<Instruction*> sorted_iis;
  for (auto ii : iis) {
    sorted_iis.push_back(ii.first);
  }
  return sorted_iis;
}

static unsigned getInstructionIdx(const Instruction *I) {
  unsigned idx = 0;
  for (auto &ii : *(I->getParent())) {
    if (&ii == I)
      break;
    ++idx;
  }
  return idx;
}

static bool isUnsupportedTy(llvm::Type *ty) {
  Type *vsty = ty->getScalarType();
  return ty->isStructTy() || vsty->isPointerTy() ||
         (vsty->isFloatingPointTy() && !vsty->isIEEELikeFPTy()) ||
         ty->isScalableTy() || vsty->isX86_MMXTy() || vsty->isX86_AMXTy();
}

static bool walk(BasicBlock* current, BasicBlock* target,
                 unordered_set<BasicBlock*> &blocks,
                 DominatorTree &DT) {
  auto s = [&DT](auto self,
                 BasicBlock* current,
                 BasicBlock* target,
                 unordered_set<BasicBlock*>& visited,
                 unordered_set<BasicBlock*>& result) -> bool {

    /*if (result.contains(current)) {
      return true;
    }*/
    if (visited.size() > 20) {
      debug() << "[slicer] block too distant from root, skipping\n";
      return false;
    }

    if (target == current) {
        result.insert(visited.begin(), visited.end());
        return true;
    } else {
      for (BasicBlock* pred : predecessors(current)) {
        bool t = true;
        if (visited.find(pred) == visited.end() && DT.dominates(target, pred)) {
            visited.insert(pred);  // Backtrack
            t = self(self, pred, target, visited, result);
            visited.erase(pred);
        }
        if (!t)
          return false;
      }
      return true;
    }
  };
  /*debug () << "[slicer] start walking from " << current->getName() << " to "
           << target->getName() << "\n";*/

  unordered_set<BasicBlock*> visited = { current };

  return s(s, current, target, visited, blocks);
}

namespace minotaur {

//  * if a external value is outside the loop, and it does not dominates v,
//    do not extract it
optional<pair<reference_wrapper<Function>, Instruction*>>
Slice::extractExpr(Value &v) {
  debug() << "[slicer] slicing value " << v << ">>>\n";

  Type *vsty = v.getType()->getScalarType();
  if (isUnsupportedTy(vsty)) {
    debug() << "[slicer] unsupported type " << *vsty << "\n";
    return nullopt;
  }

  assert(isa<Instruction>(&v) && "Expr to be extracted must be a Instruction");
  Instruction *vi = cast<Instruction>(&v);
  BasicBlock *vbb = vi->getParent();

  Loop *loopv = LI.getLoopFor(vbb);
  if (loopv) {
    debug() << "[slicer] value is in " << *loopv;

    if (!loopv->isLoopSimplifyForm()) {
      debug() << "[slicer] loop is not in simplified form, skipping\n";
      return nullopt;
    }
  }

  LLVMContext &ctx = m->getContext();
  set<pair<Value*, BasicBlock*>> visited;

  queue<tuple<Value*, BasicBlock*, unsigned>> worklist;

  ValueToValueMapTy vmap;
  set<Instruction*> insts;
  unordered_map<BasicBlock*, vector<pair<Instruction*,unsigned>>> bb_insts;
  unordered_set<BasicBlock*> blocks;

  worklist.push({&v, vbb, 0});

  // pass 1;
  // + duplicate instructions, leave the operands untouched
  // + if there are intrinsic calls, create declares in the new module
  // * if the def of a use is not copied, the use will be treated as unknown,
  //   we will create an function argument for the def and replace the use
  //   with the argument.
  while (!worklist.empty()) {
    auto &[w, basebb, depth] = worklist.front();
    worklist.pop();

    if (depth > config::slicer_max_depth)
      continue;

    if (!visited.insert({w, basebb}).second)
      continue;

    if (Instruction *i = dyn_cast<Instruction>(w)) {
      BasicBlock *ibb = i->getParent();
      Loop *loopi = LI.getLoopFor(ibb);

      // do not harvest instructions beyond loop boundry.
      if (loopi != loopv)
        continue;

      if (loopi && !loopi->isLoopSimplifyForm()) {
        debug() << "[slicer] loop is not in simplified form, skipping\n";
        continue;
      }

      auto ops = i->operands();

      // filter unknown operation by instruction
      if (CallInst *call = dyn_cast<CallInst>(i)) {
        auto callee = call->getCalledFunction();
        if (!callee) {
          debug() << "[slicer] unknown callee \n";
          continue;
        }
        if (!callee->isIntrinsic()) {
          debug() << "[slicer] non-intrinsic call: "
                  << callee->getName() << "\n";
          continue;
        }

        FunctionCallee intrindecl =
            m->getOrInsertFunction(callee->getName(), callee->getFunctionType(),
                                   callee->getAttributes());

        vmap[callee] = intrindecl.getCallee();
        ops = call->args();
      } else if (auto phi = dyn_cast<PHINode>(i)) {
        bool phiHasUnknownIncome = false;
        unsigned incomes = phi->getNumIncomingValues();
        for (unsigned i = 0; i < incomes; i++) {
          BasicBlock *block = phi->getIncomingBlock(i);
          Loop *loopphi = LI.getLoopFor(block);
          if (loopphi != loopv) {
            phiHasUnknownIncome = true;
            break;
          }
        }
        // if a phi node has unknown income, do not harvest
        if (phiHasUnknownIncome) {
          debug() << "[slicer]" << *phi << " has external or constant income\n";
          continue;
        }
      }

      // filter unknown operation by operand type
      bool haveUnknownOperand = false;
      for (auto &op : ops) {
        if (isa<GlobalValue>(op)) {
          debug() << "[slicer] found instruction that uses GlobalValue\n";
          haveUnknownOperand = true;
          break;
        }
        if (isa<ConstantExpr>(op)) {
          debug() << "[slicer] found instruction that uses ConstantExpr\n";
          haveUnknownOperand = true;
          break;
        }
        // give up <i31 34, i31 ptrtoint (ptr @external_global to i31)>
        if (auto c = dyn_cast<Constant>(op)) {
          if (c->containsConstantExpression()) {
            haveUnknownOperand = true;
            break;
          }
        }
        auto op_ty = op->getType();
        if (isUnsupportedTy(op_ty)) {
          debug() << "[slicer] found instruction with operands with type "
                  << *op_ty <<"\n";
          haveUnknownOperand = true;
          break;
        }
      }
      if (haveUnknownOperand) {
        continue;
      }

      // bool never_visited = !blocks.count(ibb);
      unordered_set<BasicBlock*> walk_blocks;
      debug () << "[slicer] walking from " << basebb->getName() << " to "
               << ibb->getName()
               << " for " << *i << "\n";
      if (!walk(basebb, ibb, walk_blocks, DT)) {
        continue;
      }
      blocks.insert(walk_blocks.begin(), walk_blocks.end());

      /*if (PHINode *phi = dyn_cast<PHINode>(i)) {
        debug()<< "[slicer] checking phi " << *phi << "\n";
        bool PhiHasDistantIncome = false;
        unsigned incomes = phi->getNumIncomingValues();
        unordered_set<BasicBlock*> phi_blocks;
        for (unsigned i = 0; i < incomes; i++) {
          Value *income = phi->getIncomingValue(i);
          BasicBlock *income_bb = phi->getIncomingBlock(i);
          if (!isa<Instruction>(income)) {
            phi_blocks.insert(income_bb);
          } else {
            Instruction *income_i = cast<Instruction>(income);
            unordered_set<BasicBlock*> walk_blocks;
            if (!walk(income_bb, income_i->getParent(), walk_blocks, DT)) {
              PhiHasDistantIncome = true;
              break;
            }
            phi_blocks.insert(walk_blocks.begin(), walk_blocks.end());
          }
        }
        if (PhiHasDistantIncome) {
          continue;
        }
        blocks.insert(phi_blocks.begin(), phi_blocks.end());
      }*/

      if (!insts.insert(i).second)
        continue;

      bb_insts[ibb].push_back({i, getInstructionIdx(i)});

      // add condition to worklist
      if (ibb != vbb) {
        Instruction *term = ibb->getTerminator();
        if(!isa<BranchInst>(term)) {
          debug() << "found non branch terminator " << *term << ", skipping\n";
          return nullopt;
        }
        BranchInst *bi = cast<BranchInst>(term);
        if (bi->isConditional()) {
          if (Instruction *c = dyn_cast<Instruction>(bi->getCondition())) {
            /*if (!visited.count(c))
              continue;*/
            worklist.push({c, basebb, depth + 1});
          }
        }
      }

      if (auto *phi = dyn_cast<PHINode>(i)) {
        for (unsigned i = 0; i < phi->getNumIncomingValues(); i++) {
          BasicBlock *incomebb = phi->getIncomingBlock(i);
          blocks.insert(incomebb);
          if (Instruction *c = dyn_cast<Instruction>(phi->getIncomingValue(i))) {
            worklist.push({c, incomebb, depth + 1});
          }
        }
      } else {
        for (auto &op : i->operands()) {
          if (!isa<Instruction>(op))
            continue;
          worklist.push({op, basebb, depth + 1});
        }
      }
    } else {
      report_fatal_error("[slicer] Unknown value:" + w->getName() + "\n");
    }
  }

  // if no instructions satisfied the criteria of cloning, return null.
  if (insts.empty()) {
    debug() << "[slicer] no eligible instruction can be harvested, skipping\n";
    return nullopt;
  }

  debug () << "[slicer] " << insts.size() << " instructions are harvested\n";
  for (auto &i : insts) {
    debug() << "[slicer] harvested instruction " << *i << "\n";
  }

  for (auto &bb : blocks) {
    debug () << "[slicer] harvested block " << bb->getName() << "\n";
  }


  // pass 2
  for (BasicBlock *orig_bb : blocks) {
    Instruction *term = orig_bb->getTerminator();
    if (!isa<BranchInst>(term) && !isa<ReturnInst>(term))
      return nullopt;

    if (!isa<BranchInst>(term))
      continue;
    BranchInst *bi = cast<BranchInst>(term);

    // skip if condition of a branch is a ConstantExpr
    if (bi->isConditional()) {
      if (isa<ConstantExpr>(bi->getCondition()))
        return nullopt;
    }
  }

  // clone instructions
  vector<Instruction *> cloned_insts;
  unordered_set<Value *> inst_set(insts.begin(), insts.end());
  for (auto inst : insts) {
    Instruction *c = inst->clone();
    vmap[inst] = c;
    mapping[c] = inst;
    c->setValueName(nullptr);
    SmallVector<std::pair<unsigned, MDNode *>, 8> ClonedMeta;
    c->getAllMetadata(ClonedMeta);
    for (size_t i = 0; i < ClonedMeta.size(); ++i) {
      c->setMetadata(ClonedMeta[i].first, NULL);
    }
    cloned_insts.push_back(c);
  }

  // pass 3
  // + duplicate blocks
  BasicBlock *sinkbb = BasicBlock::Create(ctx, "sink");
  new UnreachableInst(ctx, sinkbb);

  unordered_set<BasicBlock *> cloned_blocks;
  unordered_map<BasicBlock *, BasicBlock *> bmap;
  {
    // pass 3.1.1;
    // + duplicate BB;
    for (BasicBlock *orig_bb : blocks) {
      BasicBlock *bb = BasicBlock::Create(ctx, orig_bb->getName());
      bmap[orig_bb] = bb;
      vmap[orig_bb] = bb;
      cloned_blocks.insert(bb);
    }

    // pass 3.1.2:
    // + put in instructions
    for (auto bis : bb_insts) {
      auto is = schedule_insts(bis.second);
      for (Instruction *inst : is) {
        if (isa<BranchInst>(inst))
          continue;
        BasicBlock *bb = bmap.at(bis.first);
        cast<Instruction>(vmap[inst])->insertInto(bb, bb->end());
      }
    }
    // pass 3.1.2:
    // + wire branch
    for (BasicBlock *orig_bb : blocks) {
      if (orig_bb == vbb)
        continue;
      BranchInst *bi = cast<BranchInst>(orig_bb->getTerminator());
      Loop *loopbb = LI.getLoopFor(orig_bb);

      // harvesting blocks for phis may bring in loops, we untie those loops.
      BasicBlock *header = nullptr;
      if (loopbb) {
        header = loopbb->getHeader();
      }

      BranchInst *cloned_bi = nullptr;
      if (bi->isConditional()) {
        BasicBlock *truebb = nullptr, *falsebb = nullptr;
        if(bmap.count(bi->getSuccessor(0)) && bi->getSuccessor(0) != header)
          truebb = bmap.at(bi->getSuccessor(0));
        else
          truebb = sinkbb;
        if(bmap.count(bi->getSuccessor(1)) && bi->getSuccessor(1) != header)
          falsebb = bmap.at(bi->getSuccessor(1));
        else
          falsebb = sinkbb;
        cloned_bi = BranchInst::Create(truebb, falsebb,
                                       bi->getCondition(), bmap.at(orig_bb));
      } else {
        BasicBlock *jumpbb = sinkbb;
        if(bi->getSuccessor(0) != header)
          jumpbb = bmap.at(bi->getSuccessor(0));
        cloned_bi = BranchInst::Create(jumpbb, bmap.at(orig_bb));
      }
      insts.insert(bi);
      cloned_insts.push_back(cloned_bi);
      //bb_insts[orig_bb].push_back(bi);
      vmap[bi] = cloned_bi;
    }

    // create ret
    ReturnInst *ret = ReturnInst::Create(ctx, vmap[&v]);
    BasicBlock *bb = bmap.at(vbb);
    ret->insertInto(bb, bb->end());
  }

  // pass 4;
  // + remap the operands of duplicated instructions with vmap from pass 1
  // + if a operand value is unknown, reserve a function parameter for it
  SmallVector<Type *, 4> argTys;
  DenseMap<Value *, unsigned> argMap;
  unsigned idx = 0;
  for (auto &i : cloned_insts) {
    RemapInstruction(i, vmap, RF_IgnoreMissingLocals);
    for (auto &op : i->operands()) {
      if (isa<Argument>(op) || isa<GlobalVariable>(op)) {
        if (argMap.count(op.get()))
          continue;
        argTys.push_back(op->getType());
        argMap[op.get()] = idx++;
      } else if (Instruction *op_i = dyn_cast<Instruction>(op)) {
        auto unknown = find(cloned_insts.begin(), cloned_insts.end(), op_i);
        if (unknown != cloned_insts.end())
          continue;
        if (argMap.count(op.get()))
          continue;

        argTys.push_back(op->getType());
        argMap[op.get()] = idx++;
      }
    }
  }
  argTys.push_back(Type::getInt8Ty(ctx));

  unordered_set<BasicBlock *> block_without_preds;
  for (auto block : cloned_blocks) {
    auto preds = predecessors(block);
    if (preds.empty()) {
      block_without_preds.insert(block);
    }
  }

  // create function
  Function *F = Function::Create(FunctionType::get(v.getType(), argTys, false),
                                 GlobalValue::ExternalLinkage,
                                 f.getName() + "_" + v.getName(), *m);

  // pass 5:
  // + replace the use of unknown value with the function parameter
  for (auto &i : cloned_insts) {
    for (auto &op : i->operands()) {
      if (argMap.count(op.get())) {
        Argument *Arg = F->getArg(argMap[op.get()]);
        mapping[Arg] = op;
        op.set(Arg);
      }
    }
  }

  if (block_without_preds.empty()) {
    report_fatal_error("[slicer] no entry block found, terminating\n");
  }

  for (auto bb : block_without_preds) {
    for (auto &I : make_early_inc_range(*bb)) {
      if (PHINode *phi = dyn_cast<PHINode>(&I)) {
        phi->replaceAllUsesWith(PoisonValue::get(phi->getType()));
        phi->eraseFromParent();
      }
    }
  }

  BasicBlock *entry = nullptr;
  if (block_without_preds.size() > 1) {
    entry = BasicBlock::Create(ctx, "entry");
    SwitchInst *sw = SwitchInst::Create(F->getArg(idx), sinkbb, 1, entry);
    unsigned idx  = 23;
    for (BasicBlock *no_pred : block_without_preds) {
      sw->addCase(ConstantInt::get(IntegerType::get(ctx, 8), idx ++), no_pred);
    }
  }
  else if (block_without_preds.size() == 1) {
    entry = *block_without_preds.begin();
  } else {
    report_fatal_error("[slicer] no entry block found, terminating\n");
  }

  entry->insertInto(F);

  for (auto &bb : f) {
    if (bmap.count(&bb)) {
      BasicBlock *nb = bmap[&bb];
      if (nb == entry)
        continue;
      nb->insertInto(F);
    }
  }

  sinkbb->insertInto(F);

  DominatorTree FDT = DominatorTree();
  FDT.recalculate(*F);
  auto FLI = new LoopInfoBase<BasicBlock, Loop>();
  FLI->analyze(FDT);

  // make sure sliced function is loop free.
  if (!FLI->empty())
    report_fatal_error("[slicer] a loop is generated, terminating\n");

  eliminate_dead_code(*F);
  // validate the created function
  string err;
  raw_string_ostream err_stream(err);
  bool illformed = verifyFunction(*F, &err_stream);
  if (illformed) {
    llvm::errs() << err << "\n" << *F;
    report_fatal_error("[slicer] illformed function generated, terminating\n");
  }

  debug()<< *F << "\n" << "<<< end of %" << v.getName() << " <<<\n";


  return pair<reference_wrapper<Function>, Instruction*>(*F,
    cast<Instruction>(vmap[&v]));
}

} // namespace minotaur
