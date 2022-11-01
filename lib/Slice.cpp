// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "util/compiler.h"
#include "util/sort.h"
#include "Config.h"
#include "Slice.h"
#include "Utils.h"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Constants.h"
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

#include <optional>
#include <queue>
#include <unordered_map>
#include <unordered_set>

using namespace llvm;
using namespace std;

static constexpr unsigned MAX_DEPTH = 5;
static constexpr unsigned MAX_INSTNS = 20;
static constexpr unsigned MAX_BLOCKS = 10;
static constexpr unsigned MAX_WORKLIST=500;

// place instructions within a basicblock with topology sort
static
bool cmp(const pair<Instruction*, unsigned>& lhs,
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

unsigned getInstructionIdx(const Instruction *I) {
  auto &instlist = I->getParent()->getInstList();
  unsigned idx = 0;
  for (auto &ii : instlist) {
    if (&ii == I)
      break;
    ++idx;
  }
  return idx;
}

namespace minotaur {

//  * if a external value is outside the loop, and it does not dominates v,
//    do not extract it
optional<reference_wrapper<Function>> Slice::extractExpr(Value &v) {
  if(config::debug_slicer) {
    llvm::errs() << ">>> slicing value " << v << ">>>\n";
  }

  if (!v.getType()->isIntOrIntVectorTy())
    return nullopt;

  assert(isa<Instruction>(&v) && "Expr to be extracted must be a Instruction");
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

  LLVMContext &ctx = m->getContext();
  unordered_set<Value *> visited;

  queue<pair<Value *, unsigned>> worklist;

  ValueToValueMapTy vmap;
  vector<Instruction *> insts;
  unordered_map<BasicBlock *, vector<pair<Instruction*,unsigned>>> bb_insts;
  unordered_set<BasicBlock *> blocks;
  set<Value*> pointers;

  // set of predecessor bb a bb depends on
  unordered_map<BasicBlock *, unordered_set<BasicBlock *>> bb_deps;

  worklist.push({&v, 0});

  // pass 1;
  // + duplicate instructions, leave the operands untouched
  // + if there are intrinsic calls, create declares in the new module
  // * if the def of a use is not copied, the use will be treated as unknown,
  //   we will create an function argument for the def and replace the use
  //   with the argument.
  while (!worklist.empty()) {
    auto &[w, depth] = worklist.front();
    worklist.pop();

    if (isa<LandingPadInst>(w))
      continue;

    if (isa<FreezeInst>(w)) {
      continue;
    }

    if (!visited.insert(w).second)
      continue;

    if (Instruction *i = dyn_cast<Instruction>(w)) {
      bool haveUnknownOperand = false;
      for (unsigned op_i = 0; op_i < i->getNumOperands(); ++op_i ) {
        if (isa<CallInst>(i) && op_i == 0) {
          continue;
        }

        auto op = i->getOperand(op_i);
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


      // do not harvest instructions beyond loop boundry.
      BasicBlock *ibb = i->getParent();
      Loop *loopi = LI.getLoopFor(ibb);

      if (loopi != loopv)
        continue;

      // handle callsites
      if (CallInst *ci = dyn_cast<CallInst>(i)) {
        Function *callee = ci->getCalledFunction();
        if (!callee) {
          if(config::debug_slicer)
            llvm::errs() << "[INFO] indirect call found\n";
          continue;
        }
        if (!callee->isIntrinsic()) {
          if(config::debug_slicer)
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

          if (!isa<Instruction>(phi->getIncomingValue(i))) {
            phiHasUnknownIncome = true;
            break;
          }

          Loop *loopbb = LI.getLoopFor(block);
          if (loopbb != loopv) {
            phiHasUnknownIncome = true;
            break;
          }
        }

        // if a phi node has unknown income, do not harvest
        if (phiHasUnknownIncome) {
          if(config::debug_slicer) {
            llvm::errs()<<"[INFO]"<<*phi<<" has external income\n";
          }
          continue;
        }

        unsigned e = phi->getNumIncomingValues();
        for (unsigned pi = 0 ; pi != e ; ++pi) {
          auto vi = phi->getIncomingValue(pi);
          BasicBlock *income = phi->getIncomingBlock(pi);
          blocks.insert(income);
          if (!isa<Instruction>(vi))
            continue;

          BasicBlock *bb_i = cast<Instruction>(vi)->getParent();
          auto inc_pds = predecessors(income);
          if (find(inc_pds.begin(), inc_pds.end(), bb_i) == inc_pds.end())
            bb_deps[income].insert(bb_i);
        }
      } else if (auto LI = dyn_cast<LoadInst>(i)) {
        continue;
        auto dep = MD.getDependency(LI);
        if (dep.isDef() || dep.isClobber()) {
          auto st = dep.getInst();

          if (st->getParent() == ibb) {
            insts.push_back(st);
            bb_insts[ibb].push_back({st, getInstructionIdx(st)});
          }
        }
      }

      if (insts.size() > MAX_INSTNS)
        return nullopt;

      insts.push_back(i);


      bb_insts[ibb].push_back({i, getInstructionIdx(i)});

      // BB->getInstList().push_front(c);

      bool never_visited = blocks.insert(ibb).second;

      if (depth > MAX_DEPTH)
        continue;

      // add condition to worklist
      if (ibb != vbb && never_visited) {
        Instruction *term = ibb->getTerminator();
        if(!isa<BranchInst>(term))
          return nullopt;
        BranchInst *bi = cast<BranchInst>(term);
        if (bi->isConditional()) {
          if (Instruction *c = dyn_cast<Instruction>(bi->getCondition())) {
            BasicBlock *cbb = cast<Instruction>(c)->getParent();
            auto pds = predecessors(ibb);
            if (cbb != ibb && find(pds.begin(), pds.end(), cbb) == pds.end())
              bb_deps[ibb].insert(cbb);
            worklist.push({c, depth + 1});
          }
        }
      }

      for (auto &op : i->operands()) {
        if (!isa<Instruction>(op))
          continue;

        auto preds = predecessors(i->getParent());
        BasicBlock *bb_i = cast<Instruction>(op)->getParent();
        if (find(preds.begin(), preds.end(), bb_i) == preds.end())
          bb_deps[i->getParent()].insert(bb_i);
        worklist.push({op, depth + 1});
      }
    } else {
      llvm::report_fatal_error("[ERROR] Unknown value:" + w->getName() + "\n");
    }
  }

  // if no instructions satisfied the criteria of cloning, return null.
  if (insts.empty()) {
    if(config::debug_slicer) {
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
  // TODO: better object management.
  for (auto &[bb, deps] : bb_deps) {
    unordered_set<Value *> visited;
    queue<pair<unordered_set<BasicBlock *>, BasicBlock *>> worklist;
    worklist.push({{bb}, bb});
    // unordered_set<BasicBlock*> unreachable;

    while (!worklist.empty()) {
      auto [path, ibb] = worklist.front();
      worklist.pop();

      if (deps.contains(ibb)) {
        if (blocks.size() > MAX_BLOCKS)
          return nullopt;
        blocks.insert(path.begin(), path.end());
        if(visited.insert(ibb).second) {
          path.clear();
          path.insert(ibb);
        } else {
          continue;
        }
      }

      for (BasicBlock *pred : predecessors(ibb)) {
        // do not allow loop
        if (path.count(pred)) {
          return nullopt;
        }
        // if (unreachable.contains(pred)) {
        //   continue;
        // }
        // SmallVector<BasicBlock*, 8> sv_deps(deps.begin(), deps.end());
        // if (!isPotentiallyReachableFromMany(sv_deps, pred, nullptr, &DT, &LI)) {
        //   unreachable.insert(pred);
        //   continue;
        // }
        path.insert(pred);
        if (worklist.size() > MAX_WORKLIST)
          return nullopt;
        worklist.push({path, pred});
      }
    }
  }

  // FIXME: Do not handle switch for now
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
        bmap.at(bis.first)->getInstList().push_back(cast<Instruction>(vmap[inst]));
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
      insts.push_back(bi);
      cloned_insts.push_back(cloned_bi);
      //bb_insts[orig_bb].push_back(bi);
      vmap[bi] = cloned_bi;
    }

    // create ret
    ReturnInst *ret = ReturnInst::Create(ctx, vmap[&v]);
    bmap.at(vbb)->getInstList().push_back(ret);
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
      } else if (isa<Constant>(op)) {
        continue;
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

  unordered_set<BasicBlock *> block_without_preds;
  for (auto block : cloned_blocks) {
    auto preds = predecessors(block);
    if (preds.empty()) {
      block_without_preds.insert(block);
    }
  }
  if (block_without_preds.size() > 1)
    // argument for switch
    argTys.push_back(Type::getInt8Ty(ctx));

  // create function
  Function *F = Function::Create(FunctionType::get(v.getType(), argTys, false),
                                 GlobalValue::ExternalLinkage, "src", *m);

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

  if (block_without_preds.size() == 0) {
    llvm::report_fatal_error("[ERROR] no entry block found");
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
    SwitchInst *sw = SwitchInst::Create(F->getArg(idx), sinkbb, 1, entry);
    unsigned idx  = 0;
    for (BasicBlock *no_pred : block_without_preds) {
      sw->addCase(ConstantInt::get(IntegerType::get(ctx, 8), idx ++), no_pred);
    }
    entry->insertInto(F);
    for (auto block : cloned_blocks) {
      block->insertInto(F);
    }
  }
  sinkbb->insertInto(F);

  DominatorTree FDT = DominatorTree();
  FDT.recalculate(*F);
  auto FLI = new LoopInfoBase<BasicBlock, Loop>();
  FLI->analyze(FDT);

  // make sure sliced function is loop free.
  if (!FLI->empty())
    llvm::report_fatal_error("[ERROR] a loop is generated");

  eliminate_dead_code(*F);
  // validate the created function
  string err;
  llvm::raw_string_ostream err_stream(err);
  bool illformed = llvm::verifyFunction(*F, &err_stream);
  if (illformed) {
    llvm::errs() << "[ERROR] found errors in the generated function\n";
    F->dump();
    llvm::errs() << err << "\n";
    return nullopt;
    //llvm::report_fatal_error("illformed function generated");
  }
  if (config::debug_slicer) {
    F->dump();
    llvm::errs() << "<<< end of %" << v.getName() << " <<<\n";
  }
  return optional<reference_wrapper<Function>>(*F);
}

} // namespace minotaur
