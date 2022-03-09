
// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "LLVMGen.h"

#include "IR.h"
#include "ir/instr.h"

#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicsX86.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/ErrorHandling.h"

#include <iostream>

using namespace std;
using namespace llvm;

namespace minotaur {

static constexpr std::array<llvm::Intrinsic::ID, X86IntrinBinOp::numOfX86Intrinsics> IntrinsicIDs = {
#define PROCESS(NAME,A,B,C,D,E,F) llvm::Intrinsic::NAME,
#include "ir/intrinsics.h"
#undef PROCESS
};

static llvm::Intrinsic::ID getIntrinsicID(X86IntrinBinOp::Op op) {
  return IntrinsicIDs[op];
}

llvm::Value *LLVMGen::codeGen(Inst *I, ValueToValueMapTy &VMap) {
  if (auto V = dynamic_cast<Var*>(I)) {
    if (VMap.empty()) {
      return V->V();
    } else {
      if (VMap.count(V->V()))
        return VMap[V->V()];
      else {
        V->V()->dump();
        llvm::report_fatal_error("Value is not found in VMap");
      }
    }
  } /*else if (auto P = dynamic_cast<Ptr *>(I)) {
    if (VMap.empty()) {
      return P->V();
    } else {
      return VMap[P->V()];
    }
  } */
  else if (auto U = dynamic_cast<CopyInst*>(I)) {
    auto op0 = codeGen(U->Op0(), VMap);
    return op0;
  } else if (auto B = dynamic_cast<BinaryInst*>(I)) {
    type workty = B->getWorkTy();
    auto op0 = codeGen(B->L(), VMap);
    if(B->L()->getWidth() != workty.getWidth())
      report_fatal_error("left operand width mismatch");
    op0 = b.CreateBitCast(op0, workty.toLLVM(C));

    auto op1 = codeGen(B->R(), VMap);
    if(B->R()->getWidth() != workty.getWidth())
      report_fatal_error("left operand width mismatch");
    op1 = b.CreateBitCast(op1, workty.toLLVM(C));

    llvm::Value *r = nullptr;
    switch (B->K()) {
    case BinaryInst::band:
      r = b.CreateAnd(op0, op1, "and");
      break;
    case BinaryInst::bor:
      r = b.CreateOr(op0, op1, "or");
      break;
    case BinaryInst::bxor:
      r = b.CreateXor(op0, op1, "xor");
      break;
    case BinaryInst::add:
      r = b.CreateAdd(op0, op1, "add");
      break;
    case BinaryInst::sub:
      r = b.CreateSub(op0, op1, "sub");
      break;
    case BinaryInst::mul:
      r = b.CreateMul(op0, op1, "mul");
      break;
    case BinaryInst::sdiv:
      r = b.CreateSDiv(op0, op1, "sdiv");
      break;
    case BinaryInst::udiv:
      r = b.CreateUDiv(op0, op1, "udiv");
      break;
    case BinaryInst::lshr:
      r = b.CreateLShr(op0, op1, "lshr");
      break;
    case BinaryInst::ashr:
      r = b.CreateAShr(op0, op1, "ashr");
      break;
    case BinaryInst::shl:
      r = b.CreateShl(op0, op1, "shl");
      break;
    default:
      UNREACHABLE();
    }
    return r;
  } else if (auto IC = dynamic_cast<ICmpInst*>(I)) {
    auto op0 = codeGen(IC->L(), VMap);
    auto workty = type(I->getWidth(), IC->L()->getWidth()/I->getWidth(), false);
    op0 = b.CreateBitCast(op0, workty.toLLVM(C));

    auto op1 = codeGen(IC->R(), VMap);
    op1 = b.CreateBitCast(op1, workty.toLLVM(C));
    llvm::Value *r = nullptr;
    switch (IC->K()) {
    case ICmpInst::eq:
      r = b.CreateICmp(CmpInst::ICMP_EQ, op0, op1, "ieq");
      break;
    case ICmpInst::ne:
      r = b.CreateICmp(CmpInst::ICMP_NE, op0, op1, "ine");
      break;
    case ICmpInst::ult:
      r = b.CreateICmp(CmpInst::ICMP_ULT, op0, op1, "iult");
      break;
    case ICmpInst::ule:
      r = b.CreateICmp(CmpInst::ICMP_ULE, op0, op1, "iule");
      break;
    case ICmpInst::slt:
      r = b.CreateICmp(CmpInst::ICMP_SLT, op0, op1, "islt");
      break;
    case ICmpInst::sle:
      r = b.CreateICmp(CmpInst::ICMP_SLE, op0, op1, "isle");
      break;
    }
    return r;

  } else if (auto B = dynamic_cast<SIMDBinOpInst*>(I)) {
    type op0_ty = type::getIntrinsicOp0Ty(B->K());
    type op1_ty = type::getIntrinsicOp1Ty(B->K());
    auto op0 = codeGen(B->L(), VMap);
    if(B->L()->getWidth() != op0_ty.getWidth())
      report_fatal_error("left operand width mismatch");
    op0 = b.CreateBitCast(op0, op0_ty.toLLVM(C));

    auto op1 = codeGen(B->R(), VMap);
    if(B->R()->getWidth() != op1_ty.getWidth())
      report_fatal_error("right operand width mismatch");
    op1 = b.CreateBitCast(op1, op1_ty.toLLVM(C));

    llvm::Function *decl = Intrinsic::getDeclaration(M, getIntrinsicID(B->K()));
    IntrinsicDecls.insert(decl);


    llvm::Value *CI = CallInst::Create(decl, ArrayRef<llvm::Value *>({op0, op1}),
                                       "intr",
                                       cast<Instruction>(b.GetInsertPoint()));
    return CI;
  } else if (auto RC = dynamic_cast<ReservedConst *>(I)) {
    llvm::Constant *C = RC->getC();
    if (C) {
      return C;
    } else {
      return RC->getA();
    }
  } /*else if (auto SV = dynamic_cast<minotaur::ShuffleVectorInst *>(I)) {
    // TODO
    std::vector<llvm::Type*> Doubles(Args.size(),
                              Type::getDoubleTy(getGlobalContext()));
    FunctionType *FT = FunctionType::get(Type::getDoubleTy(getGlobalContext()),
                                        Doubles, false);

    Function *F = Function::Create(FT, Function::ExternalLinkage, Name, TheModule);
    auto op0 = codeGen(SV->L(), VMap, constMap);
    auto op1 = codeGen(SV->R(), VMap, constMap);
    auto M = codeGen(SV->M(), VMap, constMap);
    return b.CreateCall(op0, op1, M, "syn");
  }
  else if (auto L = dynamic_cast<minotaur::Load *>(I)) {
    auto op0 = codeGen(L->addr(), VMap, constMap);
    return b.CreateLoad(L->elemTy(), op0);
  }*/
  llvm::report_fatal_error("[ERROR] unknown instruction found in LLVMGen");
  UNREACHABLE();
}
}