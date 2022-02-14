// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "util/compiler.h"
#include "util/sort.h"
#include <Slice.h>

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <map>
#include <optional>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <unordered_map>
#include <unordered_set>

using namespace llvm;
using namespace std;

// TODO: add search depth limitation
static constexpr unsigned MAX_DEPTH = 5;
static constexpr unsigned MAX_WORKLIST = 1000;
static constexpr unsigned MAX_PHI = 3;
static constexpr unsigned DEBUG_LEVEL = 0;

using edgesTy = std::vector<std::unordered_set<unsigned>>;
// simple Tarjan topological sort ignoring loops
static vector<unsigned> top_sort(const edgesTy &edges) {
  vector<unsigned> sorted;
  vector<unsigned char> marked;
  marked.resize(edges.size());

  function<void(unsigned)> visit = [&](unsigned v) {
    if (marked[v])
      return;
    marked[v] = true;

    for (auto child : edges[v]) {
      visit(child);
    }
    sorted.emplace_back(v);
  };

  for (unsigned i = 1, e = edges.size(); i < e; ++i)
    visit(i);
  if (!edges.empty())
    visit(0);

  reverse(sorted.begin(), sorted.end());
  return sorted;
}

// place instructions within a basicblock with topology sort
static vector<Instruction*> schedule_insts(const vector<Instruction*> &iis) {
  edgesTy edges(iis.size());
  unordered_map<const Instruction*, unsigned> inst_map;

  unsigned i = 0;
  for (auto ii : iis) {
    inst_map.emplace(ii, i++);
  }

  i = 0;
  for (auto ii : iis) {
    for (auto &op : ii->operands()) {
      if (!isa<Instruction>(op))
        continue;
      auto dst_I = inst_map.find(cast<Instruction>(&op));
      if (dst_I != inst_map.end())
        edges[dst_I->second].emplace(i);
    }
    ++i;
  }

  i = 0;
  for (auto ii : iis) {
    unsigned j = 0;
    for (auto jj : iis) {
      if (isa<PHINode>(ii) && !isa<PHINode>(jj)) {
        edges[i].emplace(j);
      }
      ++j;
    }
    ++i;
  }

  vector<Instruction*> sorted_iis;
  sorted_iis.reserve(iis.size());
  for (auto v : top_sort(edges)) {
    sorted_iis.emplace_back(iis[v]);
  }

  assert(sorted_iis.size() == bbs.size());
  return sorted_iis;
}

namespace minotaur {

//  * if a external value is outside the loop, and it does not dominates v,
//    do not extract it
optional<std::reference_wrapper<Function>> Slice::extractExpr(Value &v) {
  if (Instruction *i = dyn_cast<Instruction>(&v)) {
    if (CallInst *ci = dyn_cast<CallInst>(i)) {
      Function *callee = ci->getCalledFunction();
      if (!callee)
        return nullopt;
      if (!callee->isIntrinsic()) {
        return nullopt;
      }
    }
  }

  if(DEBUG_LEVEL > 0) {
    llvm::errs() << ">>> slicing value " << v << ">>>\n";
  }

  assert(isa<Instruction>(&v) && "Expr to be extracted must be a Instruction");
  Instruction *vi = cast<Instruction>(&v);
  BasicBlock *vbb = vi->getParent();

  Loop *loopv = LI.getLoopFor(vbb);
  if (loopv) {
    // TODO: why non innermost loops are returned?
    //if(!loopv->isInnermost()) return nullopt;
    if(DEBUG_LEVEL > 0) {
      llvm::errs() << "[INFO] value is in " << *loopv;
    }
    if (!loopv->isLoopSimplifyForm()) {
      // TODO: continue harvesting within loop boundary, even loop is not in
      // normal form.
      if(DEBUG_LEVEL > 0) {
        llvm::errs() << "[INFO] loop is not in normal form\n";
      }
      return nullopt;
    }
  }

  LLVMContext &ctx = m->getContext();
  unordered_set<Value *> visited;

  queue<pair<Value *, unsigned>> worklist;

  ValueToValueMapTy vmap;
  vector<Instruction *> insts;
  map<BasicBlock *, vector<Instruction *>> bb_insts;
  set<BasicBlock *> blocks;

  worklist.push({&v, 0});

  unsigned numPhi = 0;

  bool havePhi = false;
  // pass 1;
  // + duplicate instructions, leave the operands untouched
  // + if there are intrinsic calls, create declares in the new module
  // * if the def of a use is not copied, the use will be treated as unknown,
  //   we will create an function argument for the def and replace the use
  //   with the argument.
  while (!worklist.empty()) {
    auto &[w, depth] = worklist.front();
    worklist.pop();
    if (depth > MAX_DEPTH)
      continue;
    if (!visited.insert(w).second)
      continue;

    if (Instruction *i = dyn_cast<Instruction>(w)) {
      BasicBlock *ibb = i->getParent();
      Loop *loopi = LI.getLoopFor(ibb);

      // do not try to harvest instructions beyond loop boundry.
      if (loopi != loopv)
        continue;

      if (CallInst *ci = dyn_cast<CallInst>(i)) {
        Function *callee = ci->getCalledFunction();
        if (!callee) {
          if(DEBUG_LEVEL > 0)
            llvm::errs() << "[INFO] indirect call found" << "\n";
          continue;
        }
        if (!callee->isIntrinsic()) {
          if(DEBUG_LEVEL > 0)
            llvm::errs() << "[INFO] unknown callee found "
                         << callee->getName() << "\n";
          continue;
        }
        FunctionCallee intrindecl =
            m->getOrInsertFunction(callee->getName(), callee->getFunctionType(),
                                   callee->getAttributes());

        vmap[callee] = intrindecl.getCallee();
      } else if (auto phi = dyn_cast<PHINode>(i)) {
        bool phiHasUnknownIncome = false;

        unsigned incomes = phi->getNumIncomingValues();
        for (unsigned i = 0; i < incomes; i ++) {
          BasicBlock *block = phi->getIncomingBlock(i);

          if (!isa<Instruction>(phi->getIncomingValue(i)))
            return nullopt;
          // v is in loop l, block is not in l
          if (loopv && !loopv->contains(block)) {
            phiHasUnknownIncome = true;
            break;
          }
          // v is in toplevel, block is in a loop
          Loop *loopbb = LI.getLoopFor(block);
          if (loopv != loopbb) {
            phiHasUnknownIncome = true;
            break;
          }
        }

        if (phiHasUnknownIncome) {
          if(DEBUG_LEVEL > 0) {
            llvm::errs()<<"[INFO]"<<*phi<<" has external income\n";
          }
          continue;
        }

        havePhi = true;
        if (numPhi++ > MAX_PHI) return nullopt;
      }

      insts.push_back(i);
      bb_insts[ibb].push_back(i);

      // BB->getInstList().push_front(c);

      bool never_visited = blocks.insert(ibb).second;
      if (ibb != vbb && never_visited) {
        Instruction *term = ibb->getTerminator();
        assert(!isa<BranchInst>(term) && "Unexpected terminator found");
        BranchInst *bi = cast<BranchInst>(term);
        /*if (bi->isConditional())
          worklist.push({bi->getCondition(), 0});*/
      }

      for (auto &op : i->operands()) {
        if (isa<ConstantExpr>(op))
          return nullopt;
        worklist.push({op, depth + 1});
      }
    } else if (isa<Constant>(w) || isa<Argument>(w) || isa<GlobalValue>(w)) {
      continue;
    } else {
      llvm::report_fatal_error("[ERROR] Unknown value:" + w->getName() + "\n");
    }
  }

  // if no instructions satisfied the criteria of cloning, return null.
  if (insts.empty()) {
    if(DEBUG_LEVEL > 0) {
      llvm::errs()<<"[INFO] no instruction can be harvested\n";
    }
    return nullopt;
  }

  // pass 2
  // + find missed intermidiate blocks
  // For example,
  /*
         S
        / \
       A   B
       |   |
       |   I
        \  /
         T
  */
  // Suppose an instruction in T uses values defined in A and B, if we harvest
  // values by simply backward-traversing def/use tree, Block I will be missed.
  // To solve this issue,  we identify all such missed block by searching.
  {
    // set of predecessor bb a bb depends on
    map<BasicBlock *, set<BasicBlock *>> bb_deps;
    for (auto inst : insts) {
      auto preds = predecessors(inst->getParent());

      if (auto *phi = dyn_cast<PHINode>(inst)) {
        unsigned e = phi->getNumIncomingValues();
        for (unsigned i = 0 ; i != e ; ++i) {
          auto vi = phi->getIncomingValue(i);
          BasicBlock *income = phi->getIncomingBlock(i);
          blocks.insert(income);
          if (!isa<Instruction>(vi))
            continue;

          BasicBlock *bb_i = cast<Instruction>(vi)->getParent();
          //if (find(preds.begin(), preds.end(), bb_i) != preds.end())
          //  continue;
          bb_deps[phi->getIncomingBlock(i)].insert(bb_i);
        }
      } else {
        for (auto &op : inst->operands()) {
          if (!isa<Instruction>(op))
            continue;
          BasicBlock *bb_i = cast<Instruction>(op)->getParent();
          // skip if dep comes from immediate predecessor bb
          if (find(preds.begin(), preds.end(), bb_i) != preds.end())
            continue;
          bb_deps[inst->getParent()].insert(bb_i);
        }
      }
    }

    for (auto &[bb, deps] : bb_deps) {
      for (auto dep : deps) {
        queue<pair<unordered_set<BasicBlock *>, BasicBlock *>> worklist;
        worklist.push({{bb}, bb});

        while (!worklist.empty()) {
          // TODO: scale up the algorithm
          if (worklist.size() > MAX_WORKLIST)
            return nullopt;
          auto [path, ibb] = worklist.front();
          worklist.pop();

          if (dep == ibb) {
            blocks.insert(path.begin(), path.end());
          }

          auto preds = predecessors(ibb);
          for (BasicBlock *pred : preds) {
            // do not allow loop
            if (path.count(pred))
              return nullopt;

            /*if (!DT.dominates(dep, pred))
              continue;*/

            unordered_set<BasicBlock*> new_path(path);
            new_path.insert(pred);
            worklist.push({move(new_path), pred});
          }
        }
      }
    }
  }

  // FIXME: Do not handle switch for now
  for (BasicBlock *orig_bb : blocks) {
    Instruction *term = orig_bb->getTerminator();
    if (isa<SwitchInst>(term))
      return nullopt;
  }

  // clone instructions
  vector<Instruction *> cloned_insts;
  set<Value *> inst_set(insts.begin(), insts.end());
  for (auto inst : insts) {
    Instruction *c = inst->clone();
    vmap[inst] = c;
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

  set<BasicBlock *> cloned_blocks;
  unordered_map<BasicBlock *, BasicBlock *> bmap;
  if (havePhi) {
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
        bmap.at(bis.first)->getInstList().push_back(cast<Instruction>(vmap[inst]));
      }
    }
    // pass 3.1.2:
    // + wire branch
    for (BasicBlock *orig_bb : blocks) {
      if (orig_bb == vbb)
        continue;
      Instruction *term = orig_bb->getTerminator();
      assert(isa<BranchInst>(term) && "Unexpected terminator found");
      BranchInst *bi = cast<BranchInst>(term);

      BranchInst *cloned_bi = nullptr;
      if (bi->isConditional()) {
        BasicBlock *truebb = nullptr, *falsebb = nullptr;
        if(bmap.count(bi->getSuccessor(0)))
          truebb = bmap.at(bi->getSuccessor(0));
        else
          truebb = sinkbb;
        if(bmap.count(bi->getSuccessor(1)))
          falsebb = bmap.at(bi->getSuccessor(1));
        else
          falsebb = sinkbb;
        cloned_bi = BranchInst::Create(truebb, falsebb,
                                       bi->getCondition(), bmap.at(orig_bb));
      } else {
        // TODO: investigate me
        BasicBlock *jumpbb = nullptr;

          jumpbb = bmap.at(bi->getSuccessor(0));

        cloned_bi =
            BranchInst::Create(jumpbb, bmap.at(orig_bb));
      }
      insts.push_back(bi);
      cloned_insts.push_back(cloned_bi);
      //bb_insts[orig_bb].push_back(bi);
      vmap[bi] = cloned_bi;
    }

    // create ret
    ReturnInst *ret = ReturnInst::Create(ctx, vmap[&v]);
    bmap.at(vbb)->getInstList().push_back(ret);
  } else {
    // pass 3.2
    // + phi free
    BasicBlock *bb = BasicBlock::Create(ctx, "entry");
    auto is = schedule_insts(insts);
    for (auto inst : is) {
      bb->getInstList().push_back(cast<Instruction>(vmap[inst]));
    }
    ReturnInst *ret = ReturnInst::Create(ctx, vmap[&v]);
    bb->getInstList().push_back(ret);
    cloned_blocks.insert(bb);
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
        argTys.push_back(op->getType());
        argMap[op.get()] = idx++;
      } else if (isa<Constant>(op)) {
        continue;
      } else if (Instruction *op_i = dyn_cast<Instruction>(op)) {
        auto unknown = find(cloned_insts.begin(), cloned_insts.end(), op_i);
        if (unknown != cloned_insts.end())
          continue;
        if (!argMap.count(op.get())) {
          argTys.push_back(op->getType());
          argMap[op.get()] = idx++;
        }
      }
    }
  }
  // argument for switch
  argTys.push_back(Type::getInt64Ty(ctx));
  // create function
  auto func_name = "sliced_" + v.getName();
  Function *F = Function::Create(FunctionType::get(v.getType(), argTys, false),
                                 GlobalValue::ExternalLinkage, func_name, *m);

  // pass 5:
  // + replace the use of unknown value with the function parameter
  for (auto &i : cloned_insts) {
    for (auto &op : i->operands()) {
      if (argMap.count(op.get())) {
        op.set(F->getArg(argMap[op.get()]));
      }
    }
  }

  set<BasicBlock *> block_without_preds;
  for (auto block : cloned_blocks) {
    auto preds = predecessors(block);
    if (preds.empty()) {
      block_without_preds.insert(block);
    }
  }
  if (block_without_preds.size() == 0) {
    for (auto block : cloned_blocks) {
      block->insertInto(F);
    }
    sinkbb->insertInto(F);
    return nullopt;
    //llvm::report_fatal_error("[ERROR] no entry block found");
  } if (block_without_preds.size() == 1) {
    BasicBlock *entry = *block_without_preds.begin();
    entry->insertInto(F);
    for (auto block : cloned_blocks) {
      if (block == entry)
        continue;
      block->insertInto(F);
    }
  } else {
    BasicBlock *entry =  BasicBlock::Create(ctx, "entry");
    SwitchInst *sw = SwitchInst::Create(F->getArg(idx), sinkbb,
                                        1, entry);

    unsigned idx  = 0;
    for (BasicBlock *no_pred : block_without_preds) {
      sw->addCase(ConstantInt::get(IntegerType::get(ctx, 64), idx ++), no_pred);
    }
    entry->insertInto(F);
    for (auto block : cloned_blocks) {
      block->insertInto(F);
    }
  }
  sinkbb->insertInto(F);

  DominatorTree FDT = DominatorTree();
  FDT.recalculate(*F);
  auto FLI = new llvm::LoopInfoBase<llvm::BasicBlock, llvm::Loop>();
  FLI->releaseMemory();
  FLI->analyze(FDT);

  if (!FLI->empty())
    return nullopt;

  if (DEBUG_LEVEL > 0) {
    F->dump();
  }

  // validate the created function
  string err;
  llvm::raw_string_ostream err_stream(err);
  bool illformed = llvm::verifyFunction(*F, &err_stream);
  if (illformed) {
    F->dump();
    llvm::errs() << "[ERROR] found errors in the generated function\n";
    llvm::errs() << err << "\n";
    llvm::report_fatal_error("illformed function generated");
  }
  if (DEBUG_LEVEL > 0) {
    llvm::errs() << "<<< end of %" << v.getName() << " <<<\n";
  }
  return std::optional<std::reference_wrapper<Function>>(*F);
}

} // namespace minotaur