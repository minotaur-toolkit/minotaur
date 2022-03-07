
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
/* sse2_pavg_w */           llvm::Intrinsic::x86_sse2_pavg_w,
/* sse2_pavg_b */           llvm::Intrinsic::x86_sse2_pavg_b,
/* avx2_pavg_w */           llvm::Intrinsic::x86_avx2_pavg_w,
/* avx2_pavg_b */           llvm::Intrinsic::x86_avx2_pavg_b,
/* avx512_pavg_w_512 */     llvm::Intrinsic::x86_avx512_pavg_w_512,
/* avx512_pavg_b_512 */     llvm::Intrinsic::x86_avx512_pavg_b_512,
/* avx2_pshuf_b */          llvm::Intrinsic::x86_avx2_pshuf_b,
/* ssse3_pshuf_b_128 */     llvm::Intrinsic::x86_ssse3_pshuf_b_128,
/* avx512_pshuf_b_512 */    llvm::Intrinsic::x86_avx512_pshuf_b_512,
/* sse2_psrl_w */           llvm::Intrinsic::x86_sse2_psrl_w,
/* sse2_psrl_d */           llvm::Intrinsic::x86_sse2_psrl_d,
/* sse2_psrl_q */           llvm::Intrinsic::x86_sse2_psrl_q,
/* avx2_psrl_w */           llvm::Intrinsic::x86_avx2_psrl_w,
/* avx2_psrl_d */           llvm::Intrinsic::x86_avx2_psrl_d,
/* avx2_psrl_q */           llvm::Intrinsic::x86_avx2_psrl_q,
/* avx512_psrl_w_512 */     llvm::Intrinsic::x86_avx512_psrl_w_512,
/* avx512_psrl_d_512 */     llvm::Intrinsic::x86_avx512_psrl_d_512,
/* avx512_psrl_q_512 */     llvm::Intrinsic::x86_avx512_psrl_q_512,
/* sse2_psrli_w */          llvm::Intrinsic::x86_sse2_psrli_w,
/* sse2_psrli_d */          llvm::Intrinsic::x86_sse2_psrli_d,
/* sse2_psrli_q */          llvm::Intrinsic::x86_sse2_psrli_q,
/* avx2_psrli_w */          llvm::Intrinsic::x86_avx2_psrli_w,
/* avx2_psrli_d */          llvm::Intrinsic::x86_avx2_psrli_d,
/* avx2_psrli_q */          llvm::Intrinsic::x86_avx2_psrli_q,
/* avx512_psrli_w_512 */    llvm::Intrinsic::x86_avx512_psrli_w_512,
/* avx512_psrli_d_512 */    llvm::Intrinsic::x86_avx512_psrli_d_512,
/* avx512_psrli_q_512 */    llvm::Intrinsic::x86_avx512_psrli_q_512,
/* avx2_psrlv_d */          llvm::Intrinsic::x86_avx2_psrlv_d,
/* avx2_psrlv_d_256 */      llvm::Intrinsic::x86_avx2_psrlv_d_256,
/* avx2_psrlv_q */          llvm::Intrinsic::x86_avx2_psrlv_q,
/* avx2_psrlv_q_256 */      llvm::Intrinsic::x86_avx2_psrlv_q_256,
/* avx512_psrlv_d_512 */    llvm::Intrinsic::x86_avx512_psrlv_d_512,
/* avx512_psrlv_q_512 */    llvm::Intrinsic::x86_avx512_psrlv_q_512,
/* avx512_psrlv_w_128 */    llvm::Intrinsic::x86_avx512_psrlv_w_128,
/* avx512_psrlv_w_256 */    llvm::Intrinsic::x86_avx512_psrlv_w_256,
/* avx512_psrlv_w_512 */    llvm::Intrinsic::x86_avx512_psrlv_w_512,
/* sse2_psra_w */           llvm::Intrinsic::x86_sse2_psra_w,
/* sse2_psra_d */           llvm::Intrinsic::x86_sse2_psra_d,
/* avx2_psra_w */           llvm::Intrinsic::x86_avx2_psra_w,
/* avx2_psra_d */           llvm::Intrinsic::x86_avx2_psra_d,
/* avx512_psra_q_128 */     llvm::Intrinsic::x86_avx512_psra_q_128,
/* avx512_psra_q_256 */     llvm::Intrinsic::x86_avx512_psra_q_256,
/* avx512_psra_w_512 */     llvm::Intrinsic::x86_avx512_psra_w_512,
/* avx512_psra_d_512 */     llvm::Intrinsic::x86_avx512_psra_d_512,
/* avx512_psra_q_512 */     llvm::Intrinsic::x86_avx512_psra_q_512,
/* sse2_psrai_w */          llvm::Intrinsic::x86_sse2_psrai_w,
/* sse2_psrai_d */          llvm::Intrinsic::x86_sse2_psrai_d,
/* avx2_psrai_w */          llvm::Intrinsic::x86_avx2_psrai_w,
/* avx2_psrai_d */          llvm::Intrinsic::x86_avx2_psrai_d,
/* avx512_psrai_w_512 */    llvm::Intrinsic::x86_avx512_psrai_w_512,
/* avx512_psrai_d_512 */    llvm::Intrinsic::x86_avx512_psrai_d_512,
/* avx512_psrai_q_128 */    llvm::Intrinsic::x86_avx512_psrai_q_128,
/* avx512_psrai_q_256 */    llvm::Intrinsic::x86_avx512_psrai_q_256,
/* avx512_psrai_q_512 */    llvm::Intrinsic::x86_avx512_psrai_q_512,
/* avx2_psrav_d */          llvm::Intrinsic::x86_avx2_psrav_d,
/* avx2_psrav_d_256 */      llvm::Intrinsic::x86_avx2_psrav_d_256,
/* avx512_psrav_d_512 */    llvm::Intrinsic::x86_avx512_psrav_d_512,
/* avx512_psrav_q_128 */    llvm::Intrinsic::x86_avx512_psrav_q_128,
/* avx512_psrav_q_256 */    llvm::Intrinsic::x86_avx512_psrav_q_256,
/* avx512_psrav_q_512 */    llvm::Intrinsic::x86_avx512_psrav_q_512,
/* avx512_psrav_w_128 */    llvm::Intrinsic::x86_avx512_psrav_w_128,
/* avx512_psrav_w_256 */    llvm::Intrinsic::x86_avx512_psrav_w_256,
/* avx512_psrav_w_512 */    llvm::Intrinsic::x86_avx512_psrav_w_512,
/* sse2_psll_w */           llvm::Intrinsic::x86_sse2_psll_w,
/* sse2_psll_d */           llvm::Intrinsic::x86_sse2_psll_d,
/* sse2_psll_q */           llvm::Intrinsic::x86_sse2_psll_q,
/* avx2_psll_w */           llvm::Intrinsic::x86_avx2_psll_w,
/* avx2_psll_d */           llvm::Intrinsic::x86_avx2_psll_d,
/* avx2_psll_q */           llvm::Intrinsic::x86_avx2_psll_q,
/* avx512_psll_w_512 */     llvm::Intrinsic::x86_avx512_psll_w_512,
/* avx512_psll_d_512 */     llvm::Intrinsic::x86_avx512_psll_d_512,
/* avx512_psll_q_512 */     llvm::Intrinsic::x86_avx512_psll_q_512,
/* sse2_pslli_w */          llvm::Intrinsic::x86_sse2_pslli_w,
/* sse2_pslli_d */          llvm::Intrinsic::x86_sse2_pslli_d,
/* sse2_pslli_q */          llvm::Intrinsic::x86_sse2_pslli_q,
/* avx2_pslli_w */          llvm::Intrinsic::x86_avx2_pslli_w,
/* avx2_pslli_d */          llvm::Intrinsic::x86_avx2_pslli_d,
/* avx2_pslli_q */          llvm::Intrinsic::x86_avx2_pslli_q,
/* avx512_pslli_w_512 */    llvm::Intrinsic::x86_avx512_pslli_w_512,
/* avx512_pslli_d_512 */    llvm::Intrinsic::x86_avx512_pslli_d_512,
/* avx512_pslli_q_512 */    llvm::Intrinsic::x86_avx512_pslli_q_512,
/* avx2_psllv_d */          llvm::Intrinsic::x86_avx2_psllv_d,
/* avx2_psllv_d_256 */      llvm::Intrinsic::x86_avx2_psllv_d_256,
/* avx2_psllv_q */          llvm::Intrinsic::x86_avx2_psllv_q,
/* avx2_psllv_q_256 */      llvm::Intrinsic::x86_avx2_psllv_q_256,
/* avx512_psllv_d_512 */    llvm::Intrinsic::x86_avx512_psllv_d_512,
/* avx512_psllv_q_512 */    llvm::Intrinsic::x86_avx512_psllv_q_512,
/* avx512_psllv_w_128 */    llvm::Intrinsic::x86_avx512_psllv_w_128,
/* avx512_psllv_w_256 */    llvm::Intrinsic::x86_avx512_psllv_w_256,
/* avx512_psllv_w_512 */    llvm::Intrinsic::x86_avx512_psllv_w_512,
/* ssse3_psign_b_128 */     llvm::Intrinsic::x86_ssse3_psign_b_128,
/* ssse3_psign_w_128 */     llvm::Intrinsic::x86_ssse3_psign_w_128,
/* ssse3_psign_d_128 */     llvm::Intrinsic::x86_ssse3_psign_d_128,
/* avx2_psign_b */          llvm::Intrinsic::x86_avx2_psign_b,
/* avx2_psign_w */          llvm::Intrinsic::x86_avx2_psign_w,
/* avx2_psign_d */          llvm::Intrinsic::x86_avx2_psign_d,
/* ssse3_phadd_w_128 */     llvm::Intrinsic::x86_ssse3_phadd_w_128,
/* ssse3_phadd_d_128 */     llvm::Intrinsic::x86_ssse3_phadd_d_128,
/* ssse3_phadd_sw_128 */    llvm::Intrinsic::x86_ssse3_phadd_sw_128,
/* avx2_phadd_w */          llvm::Intrinsic::x86_avx2_phadd_w,
/* avx2_phadd_d */          llvm::Intrinsic::x86_avx2_phadd_d,
/* avx2_phadd_sw */         llvm::Intrinsic::x86_avx2_phadd_sw,
/* ssse3_phsub_w_128 */     llvm::Intrinsic::x86_ssse3_phsub_w_128,
/* ssse3_phsub_d_128 */     llvm::Intrinsic::x86_ssse3_phsub_d_128,
/* ssse3_phsub_sw_128 */    llvm::Intrinsic::x86_ssse3_phsub_sw_128,
/* avx2_phsub_w */          llvm::Intrinsic::x86_avx2_phsub_w,
/* avx2_phsub_d */          llvm::Intrinsic::x86_avx2_phsub_d,
/* avx2_phsub_sw */         llvm::Intrinsic::x86_avx2_phsub_sw,
/* sse2_pmulh_w */          llvm::Intrinsic::x86_sse2_pmulh_w,
/* avx2_pmulh_w */          llvm::Intrinsic::x86_avx2_pmulh_w,
/* avx512_pmulh_w_512 */    llvm::Intrinsic::x86_avx512_pmulh_w_512,
/* sse2_pmulhu_w */         llvm::Intrinsic::x86_sse2_pmulhu_w,
/* avx2_pmulhu_w */         llvm::Intrinsic::x86_avx2_pmulhu_w,
/* avx512_pmulhu_w_512 */   llvm::Intrinsic::x86_avx512_pmulhu_w_512,
/* sse2_pmadd_wd */         llvm::Intrinsic::x86_sse2_pmadd_wd,
/* avx2_pmadd_wd */         llvm::Intrinsic::x86_avx2_pmadd_wd,
/* avx512_pmaddw_d_512 */   llvm::Intrinsic::x86_avx512_pmaddw_d_512,
/* ssse3_pmadd_ub_sw_128 */ llvm::Intrinsic::x86_ssse3_pmadd_ub_sw_128,
/* avx2_pmadd_ub_sw */      llvm::Intrinsic::x86_avx2_pmadd_ub_sw,
/* avx512_pmaddubs_w_512 */ llvm::Intrinsic::x86_avx512_pmaddubs_w_512,
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