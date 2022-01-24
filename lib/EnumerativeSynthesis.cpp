// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "EnumerativeSynthesis.h"
#include "ConstantSynthesis.h"
#include "IR.h"
#include "LLVMGen.h"

#include "Type.h"
#include "ir/globals.h"
#include "smt/smt.h"
#include "tools/transform.h"
#include "util/symexec.h"
#include "util/config.h"
#include "util/dataflow.h"
#include "util/version.h"
#include "llvm_util/llvm2alive.h"

#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/CGSCCPassManager.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Transforms/Scalar/DCE.h"
#include "llvm/Transforms/Utils/Cloning.h"

#include <iostream>
#include <queue>
#include <vector>
#include <set>
#include <map>

using namespace tools;
using namespace util;
using namespace std;
using namespace IR;

void calculateAndInitConstants(Transform &t);

namespace minotaur {

static void findInputs(llvm::Value *Root,
                       set<unique_ptr<Var>> &Cands,
                       /*set<unique_ptr<Ptr>> &Pointers,*/
                       unsigned Max) {
  // breadth-first search
  unordered_set<llvm::Value *> Visited;
  queue<llvm::Value *> Q;
  Q.push(Root);

  while (!Q.empty()) {
    llvm::Value *V = Q.front();
    Q.pop();
    if (Visited.insert(V).second) {
      if (auto I = llvm::dyn_cast<llvm::Instruction>(V)) {
        for (auto &Op : I->operands()) {
          Q.push(Op);
        }
      }

      if (llvm::isa<llvm::Constant>(V))
        continue;
      if (V == Root)
        continue;
      if (V->getType()->isIntOrIntVectorTy())
        Cands.insert(make_unique<Var>(V));
      /*else if (V->getType()->isPointerTy())
        Pointers.insert(make_unique<Ptr>(V));*/
      if (Cands.size() >= Max)
        return;
    }
  }
}

static bool getSketches(llvm::Value *V,
                        set<unique_ptr<Var>> &Inputs,
                        //set<unique_ptr<Ptr>> &Pointers,
                        vector<pair<unique_ptr<Inst>,
                        set<unique_ptr<ReservedConst>>>> &R) {
  auto &Ctx = V->getContext();
  R.clear();
  vector<Inst*> Comps;
  for (auto &I : Inputs) {
    Comps.emplace_back(I.get());
  }

  auto RC1 = make_unique<ReservedConst>(type(-1, -1));
  Comps.emplace_back(RC1.get());

  llvm::Type *ty = V->getType();
  // Unary operators
  for (unsigned K = UnaryInst::Op::copy; K <= UnaryInst::Op::copy; ++K) {
    for (auto Op = Comps.begin(); Op != Comps.end(); ++Op) {
      set<unique_ptr<ReservedConst>> RCs;
      Inst *I = nullptr;
      if (dynamic_cast<ReservedConst *>(*Op)) {
        auto T = make_unique<ReservedConst>(ty);
        I = T.get();
        RCs.insert(move(T));
      } else if (dynamic_cast<Var *>(*Op)) {
        // TODO;
        continue;
      }
      UnaryInst::Op op = static_cast<UnaryInst::Op>(K);
      auto UO = make_unique<UnaryInst>(op, *I);
      R.push_back(make_pair(move(UO), move(RCs)));
    }
  }

  for (unsigned K = BinaryInst::Op::band; K <= BinaryInst::Op::mul; ++K) {
    BinaryInst::Op Op = static_cast<BinaryInst::Op>(K);
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      auto Op1 = BinaryInst::isCommutative(Op) ? Op0 : Comps.begin();
      for (; Op1 != Comps.end(); ++Op1) {
        Inst *I = nullptr, *J = nullptr;
        set<unique_ptr<ReservedConst>> RCs;

        // (op rc, var)
        if (dynamic_cast<ReservedConst *>(*Op0)) {
          if (auto R = dynamic_cast<Var *>(*Op1)) {
            // ignore icmp temporarily
            if (R->V()->getType() != ty)
              continue;
            auto T = make_unique<ReservedConst>(R->getType());
            I = T.get();
            RCs.insert(move(T));
            J = R;
            if (BinaryInst::isCommutative(Op)) {
              swap(I, J);
            }
          } else continue;
        }
        // (op var, rc)
        else if (dynamic_cast<ReservedConst *>(*Op1)) {
          if (auto L = dynamic_cast<Var *>(*Op0)) {
            // do not generate (- x 3) which can be represented as (+ x -3)
            if (Op == BinaryInst::Op::sub)
              continue;
            if (L->V()->getType() != ty)
              continue;
            I = L;
            auto T = make_unique<ReservedConst>(L->getType());
            J = T.get();
            RCs.insert(move(T));
          } else continue;
        }
        // (op var, var)
        else {
          if (auto L = dynamic_cast<Var *>(*Op0)) {
            if (auto R = dynamic_cast<Var *>(*Op1)) {
              if (L->V()->getType() != R->V()->getType())
                continue;
              if (L->V()->getType() != ty)
                continue;
            };
          };
          I = *Op0;
          J = *Op1;
        }
        auto BO = make_unique<BinaryInst>(Op, *I, *J);
        R.push_back(make_pair(move(BO), move(RCs)));
      }
    }

    // BinaryIntrinsics
    for (unsigned K =  X86IntrinBinOp::Op::sse2_psrl_w;
                  K <= X86IntrinBinOp::Op::ssse3_pshuf_b_128;
         ++K) {
      // typecheck for return val
      if (!ty->isVectorTy())
        continue;
      llvm::VectorType *vty = llvm::cast<llvm::FixedVectorType>(ty);
      // FIX: Better typecheck
      if (!vty->getElementType()->isIntegerTy())
        continue;

      X86IntrinBinOp::Op op = static_cast<X86IntrinBinOp::Op>(K);
      if (X86IntrinBinOp::shape_ret[op].first != vty->getElementCount().getKnownMinValue())
        continue;
      if (X86IntrinBinOp::shape_ret[op].second != vty->getScalarSizeInBits())
        continue;

      for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
        for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
          Inst *I = nullptr, *J = nullptr;
          set<unique_ptr<ReservedConst>> RCs;

          // syntactic prunning
          if (auto L = dynamic_cast<Var *> (*Op0)) {
            // typecheck for op0
            if (!L->V()->getType()->isVectorTy())
              continue;
            llvm::VectorType *aty = llvm::cast<llvm::FixedVectorType>(L->V()->getType());
            // FIX: Better typecheck
            if (aty != vty) continue;
            if (X86IntrinBinOp::shape_op0[op].first != aty->getElementCount().getKnownMinValue())
              continue;
            if (X86IntrinBinOp::shape_op0[op].second != aty->getScalarSizeInBits()) {
              continue;
            }
          }
          if (auto R = dynamic_cast<Var *>(*Op1)) {
            // typecheck for op1
            if (!R->V()->getType()->isVectorTy())
              continue;
            llvm::VectorType *bty = llvm::cast<llvm::FixedVectorType>(R->V()->getType());
            // FIX: Better typecheck
            if (bty != vty) continue;
            if (X86IntrinBinOp::shape_op1[op].first != bty->getElementCount().getKnownMinValue())
              continue;
            if (X86IntrinBinOp::shape_op1[op].second != bty->getScalarSizeInBits())
              continue;
          }

          // (op rc, var)
          if (dynamic_cast<ReservedConst *>(*Op0)) {
            if (auto R = dynamic_cast<Var *>(*Op1)) {
              unsigned lanes = X86IntrinBinOp::shape_op0[op].first;
              unsigned bits = X86IntrinBinOp::shape_op0[op].second;
              auto aty = llvm::FixedVectorType::get(llvm::IntegerType::get(Ctx, bits), lanes);
              auto T = make_unique<ReservedConst>(aty);
              I = T.get();
              RCs.insert(move(T));
              J = R;
            } else continue;
          }
          // (op var, rc)
          else if (dynamic_cast<ReservedConst *>(*Op1)) {
            if (auto L = dynamic_cast<Var *>(*Op0)) {
              unsigned lanes = X86IntrinBinOp::shape_op1[op].first;
              unsigned bits = X86IntrinBinOp::shape_op1[op].second;
              auto bty = llvm::FixedVectorType::get(llvm::IntegerType::get(Ctx, bits), lanes);
              auto T = make_unique<ReservedConst>(bty);
              J = T.get();
              RCs.insert(move(T));
              I = L;
            } else continue;
          }
          // (op var, var)
          else {
            I = *Op0;
            J = *Op1;
          }
          auto BO = make_unique<SIMDBinOpInst>(op, *I, *J);
          R.push_back(make_pair(move(BO), move(RCs)));
        }
      }
    }
  }

  // shufflevector
  if (V->getType()->isVectorTy()) {
    for (auto Op0 = Comps.begin(); Op0 != Comps.end(); ++Op0) {
      for (auto Op1 = Comps.begin(); Op1 != Comps.end(); ++Op1) {
        auto vty = llvm::cast<llvm::VectorType>(V->getType());

        Inst *I = nullptr, *J = nullptr;
        set<unique_ptr<ReservedConst>> RCs;

        // (shufflevecttor rc, *, *), skip
        if (dynamic_cast<ReservedConst *>(*Op0)) {
            continue;
        }
        // (shufflevector var, rc, mask)
        else if (dynamic_cast<ReservedConst *>(*Op1)) {
          if (auto L = dynamic_cast<Var *>(*Op0)) {
            if (!L->V()->getType()->isVectorTy())
              continue;
            auto lvty = llvm::cast<llvm::VectorType>(L->V()->getType());
            if (lvty->getElementType() != vty->getElementType())
              continue;
            I = L;
            auto T = make_unique<ReservedConst>(L->V()->getType());
            J = T.get();
            RCs.insert(move(T));
          } else continue;
        }
        // (shufflevector, var, var, mask)
        else {
          if (auto L = dynamic_cast<Var *>(*Op0)) {
            if (auto R = dynamic_cast<Var *>(*Op1)) {
              if (L->getType() != R->getType())
                continue;
              if (!L->getType().isVector())
                continue;
              auto lvty = llvm::cast<llvm::VectorType>(L->V()->getType());
              if (lvty->getElementType() != vty->getElementType())
                continue;
            };
          };
          I = *Op0;
          J = *Op1;
        }
        auto mty = llvm::VectorType::get(llvm::Type::getInt32Ty(V->getContext()), vty->getElementCount());
        auto mask = make_unique<ReservedConst>(mty);
        auto SVI = make_unique<ShuffleVectorInst>(*I, *J, *mask.get());
        RCs.insert(move(mask));
        R.push_back(make_pair(move(SVI), move(RCs)));
      }
    }
  }

  for (auto &I : Inputs) {
    if (I->V()->getType() != V->getType())
      continue;
    set<unique_ptr<ReservedConst>> RCs;
    auto V = make_unique<Var>(I->V());
    R.push_back(make_pair(move(V), move(RCs)));
  }

  /*
  // Load
  for (auto &P : Pointers) {
    auto elemTy = llvm::cast<llvm::PointerType>(P->V()->getType())->getElementType();
    if (elemTy != ty)
      continue;
    set<unique_ptr<ReservedConst>> RCs;
    auto V = make_unique<Load>(*P, elemTy);
    R.push_back(make_pair(move(V), move(RCs)));
  }*/
  return true;
}

static optional<smt::smt_initializer> smt_init;
static bool compareFunctions(IR::Function &Func1, IR::Function &Func2,
                             unsigned &goodCount,
                             unsigned &badCount, unsigned &errorCount) {
  TransformPrintOpts print_opts;
  smt_init->reset();
  Transform t;
  t.src = move(Func1);
  t.tgt = move(Func2);

  t.preprocess();
  t.tgt.syncDataWithSrc(t.src);
  calculateAndInitConstants(t);
  TransformVerify verifier(t, false);
  t.print(cout, print_opts);

  {
    auto types = verifier.getTypings();
    if (!types) {
      cerr << "Transformation doesn't verify!\n"
              "ERROR: program doesn't type check!\n\n";
      ++errorCount;
      return true;
    }
    assert(types.hasSingleTyping());
  }

  Errors errs = verifier.verify();
  bool result(errs);
  if (result) {
    if (errs.isUnsound()) {
      cerr << "Transformation doesn't verify!\n" << errs << endl;
      ++badCount;
    } else {
      cerr << errs << endl;
      ++errorCount;
    }
  } else {
    cerr << "Transformation seems to be correct!\n\n";
    ++goodCount;
  }

  return result;
}

static bool
constantSynthesis(IR::Function &Func1, IR::Function &Func2,
                  unsigned &goodCount, unsigned &badCount, unsigned &errorCount,
                  unordered_map<const IR::Value *, llvm::Argument *> &inputMap,
                  unordered_map<llvm::Argument *, llvm::Constant *> &constMap) {
  TransformPrintOpts print_opts;
  smt_init->reset();
  Transform t;
  t.src = move(Func1);
  t.tgt = move(Func2);

  t.preprocess();
  t.tgt.syncDataWithSrc(t.src);
  ::calculateAndInitConstants(t);

  ConstantSynthesis S(t);
  t.print(cout, print_opts);
  // assume type verifies
  std::unordered_map<const IR::Value *, smt::expr> result;
  Errors errs = S.synthesize(result);

  bool ret(errs);
  if (result.empty())
    return ret;

  for (auto p : inputMap) {
    auto &ty = p.first->getType();
    auto lty = p.second->getType();

    if (ty.isIntType()) {
      // TODO, fix, do not use numeral_string()
      constMap[p.second] = llvm::ConstantInt::get(llvm::cast<llvm::IntegerType>(lty), result[p.first].numeral_string(), 10);
    } else if (ty.isFloatType()) {
      //TODO
      UNREACHABLE();
    } else if (ty.isVectorType()) {
      auto trunk = result[p.first];
      llvm::FixedVectorType *vty = llvm::cast<llvm::FixedVectorType>(lty);
      llvm::IntegerType *ety = llvm::cast<llvm::IntegerType>(vty->getElementType());
      vector<llvm::Constant *> v;
      for (int i = vty->getElementCount().getKnownMinValue() - 1 ; i >= 0 ; i --) {
        unsigned bits = ety->getBitWidth();
        auto elem = trunk.extract((i + 1) * bits - 1, i * bits);
        // TODO: support undef
        if (!elem.isConst())
          return ret;
        v.push_back(llvm::ConstantInt::get(ety, elem.numeral_string(), 10));
      }
      constMap[p.second] = llvm::ConstantVector::get(v);
    }
  }

  goodCount++;

  return ret;
}

static void cleanup(llvm::Function &F) {
  llvm::FunctionAnalysisManager FAM;

  llvm::PassBuilder PB;
  PB.registerFunctionAnalyses(FAM);

  llvm::FunctionPassManager FPM;
  FPM.addPass(llvm::DCEPass());
  FPM.run(F, FAM);
}

static void removeUnusedDecls(unordered_set<llvm::Function *> IntrinsicDecls) {
  for (auto Intr : IntrinsicDecls) {
    if (Intr->isDeclaration() && Intr->use_empty()) {
      Intr->eraseFromParent();
    }
  }
}

bool synthesize(llvm::Function &F, llvm::TargetLibraryInfo *TLI) {
  config::disable_undef_input = true;
  config::disable_poison_input = true;
  config::src_unroll_cnt = 2;
  config::tgt_unroll_cnt = 2;

  bool changed = false;

  smt_init.emplace();
  Inst *R = nullptr;
  bool result = false;
  std::unordered_set<llvm::Function *> IntrinsicDecls;

  for (auto &BB : F) {
    for (llvm::BasicBlock::reverse_iterator I = BB.rbegin(), E = BB.rend(); I != E; I++) {
      if (!I->hasNUsesOrMore(1))
        continue;
      unordered_map<llvm::Argument *, llvm::Constant *> constMap;
      set<unique_ptr<Var>> Inputs;
      //set<unique_ptr<Ptr>> Pointers;
      findInputs(&*I, Inputs,/* Pointers,*/ 20);

      vector<pair<unique_ptr<Inst>,set<unique_ptr<ReservedConst>>>> Sketches;
      getSketches(&*I, Inputs, /*Pointers,*/ Sketches);

      if (Sketches.empty()) continue;

      cout<<"---------Sketches------------"<<endl;
      for (auto &Sketch : Sketches) {
        cout<<*Sketch.first<<endl;
      }
      cout<<"-----------------------------"<<endl;

      struct Comparator {
        bool operator()(tuple<llvm::Function *, llvm::Function *, Inst *, bool>& p1, tuple<llvm::Function *, llvm::Function *, Inst *, bool> &p2) {
          return get<0>(p1)->getInstructionCount() > get<0>(p2)->getInstructionCount();
        }
      };
      unordered_map<string, llvm::Argument *> constants;
      unsigned CI = 0;
      priority_queue<tuple<llvm::Function *, llvm::Function *, Inst *, bool>, vector<tuple<llvm::Function *, llvm::Function *, Inst *, bool>>, Comparator> Fns;

      auto FT = F.getFunctionType();
      // sketches -> llvm functions
      for (auto &Sketch : Sketches) {
        bool HaveC = !Sketch.second.empty();
        auto &G = Sketch.first;
        llvm::ValueToValueMapTy VMap;


        llvm::SmallVector<llvm::Type *, 8> Args;
        for (auto I: FT->params()) {
          Args.push_back(I);
        }

        for (auto &C : Sketch.second) {
          Args.push_back(getLLVMType(C->getType(), F.getContext()));
        }

        auto nFT = llvm::FunctionType::get(FT->getReturnType(), Args, FT->isVarArg());

        llvm::Function *Tgt = llvm::Function::Create(nFT, F.getLinkage(), F.getName(), F.getParent());

        llvm::SmallVector<llvm::ReturnInst *, 8> TgtReturns;
        llvm::Function::arg_iterator TgtArgI = Tgt->arg_begin();

        for (auto I = F.arg_begin(), E = F.arg_end(); I != E; ++I, ++TgtArgI) {
          VMap[I] = TgtArgI;
          TgtArgI->setName(I->getName());
        }

        // sketches with constants, duplicate F
        for (auto &C : Sketch.second) {
          string arg_name = "_reservedc_" + std::to_string(CI);
          TgtArgI->setName(arg_name);
          constants[arg_name] = TgtArgI;
          C->setA(TgtArgI);
          ++CI;
          ++TgtArgI;
        }

        llvm::CloneFunctionInto(Tgt, &F, VMap, llvm::CloneFunctionChangeType::LocalChangesOnly, TgtReturns);

        llvm::Function *Src;
        if (HaveC) {
          llvm::ValueToValueMapTy _vs;
          Src = llvm::CloneFunction(Tgt, _vs);
        } else {
          Src = &F;
        }

        llvm::Instruction *PrevI = llvm::cast<llvm::Instruction>(VMap[&*I]);
        llvm::Value *V = LLVMGen(PrevI, IntrinsicDecls).codeGen(G.get(), VMap, nullptr);
        PrevI->replaceAllUsesWith(V);

        cleanup(*Tgt);
        if (Tgt->getInstructionCount() >= F.getInstructionCount()) {
          if (HaveC)
            Src->eraseFromParent();
          Tgt->eraseFromParent();
          continue;
        }

        Fns.push(make_tuple(Tgt, Src, G.get(), !Sketch.second.empty()));
      }

      // llvm functions -> alive2 functions, followed by verification or constant synthesis
      while (!Fns.empty()) {
        auto [Tgt, Src, G, HaveC] = Fns.top();
        Fns.pop();
        auto Func1 = llvm_util::llvm2alive(*Src, *TLI);
        auto Func2 = llvm_util::llvm2alive(*Tgt, *TLI);
        unsigned goodCount = 0, badCount = 0, errorCount = 0;
        if (!HaveC) {
          result |= compareFunctions(*Func1, *Func2,
                                     goodCount, badCount, errorCount);
        } else {
          unordered_map<const IR::Value *, llvm::Argument *> inputMap;
          for (auto &I : Func2->getInputs()) {
            string input_name = I.getName();
            // remove "%"
            input_name.erase(0, 1);
            if (constants.count(input_name)) {
              inputMap[&I] = constants[input_name];
            }
          }
          constMap.clear();
          result |= constantSynthesis(*Func1, *Func2,
                                      goodCount, badCount, errorCount,
                                      inputMap, constMap);

          Src->eraseFromParent();
        }
        Tgt->eraseFromParent();
        if (goodCount) {
          R = G;
          break;
        }
      }

      // clean up
      while (!Fns.empty()) {
        auto [Tgt, Src, G, HaveC] = Fns.top();
        Fns.pop();
        (void) G;
        if (HaveC)
          Src->eraseFromParent();
        Tgt->eraseFromParent();
      }

      // replace
      if (R) {
        llvm::ValueToValueMapTy VMap;
        llvm::Value *V = LLVMGen(&*I, IntrinsicDecls).codeGen(R, VMap, &constMap);
        I->replaceAllUsesWith(V);
        cleanup(F);
        changed = true;
        break;
      }
    }
  }
  removeUnusedDecls(IntrinsicDecls);
  return changed;
}

};
