
// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "LLVMGen.h"

#include "IR.h"
#include "ir/instr.h"

#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicsX86.h"

#include <iostream>

using namespace std;
using namespace llvm;

namespace minotaur {

llvm::Value *LLVMGen::codeGen(Inst *I, ValueToValueMapTy &VMap,
                              unordered_map<Argument *, Constant *> *constMap) {
  if (auto V = dynamic_cast<Var *>(I)) {
    if (VMap.empty()) {
      return V->V();
    } else {
      return VMap[V->V()];
    }
  } else if (auto P = dynamic_cast<Ptr *>(I)) {
    if (VMap.empty()) {
      return P->V();
    } else {
      return VMap[P->V()];
    }
  } else if (auto U = dynamic_cast<UnaryOp *>(I)) {
    auto op0 = codeGen(U->Op0(), VMap, constMap);
    llvm::Value *r = nullptr;
    switch (U->K()) {
    case UnaryOp::copy:
      r = op0;
      break;
    default:
      UNREACHABLE();
    }
    return r;
  } else if (auto B = dynamic_cast<BinOp *>(I)) {
    auto op0 = codeGen(B->L(), VMap, constMap);
    auto op1 = codeGen(B->R(), VMap, constMap);
    llvm::Value *r = nullptr;
    switch (B->K()) {
    case BinOp::band:
      r = b.CreateAnd(op0, op1, "and");
      break;
    case BinOp::bor:
      r = b.CreateOr(op0, op1, "or");
      break;
    case BinOp::bxor:
      r = b.CreateXor(op0, op1, "xor");
      break;
    case BinOp::add:
      r = b.CreateAdd(op0, op1, "add");
      break;
    case BinOp::sub:
      r = b.CreateSub(op0, op1, "sub");
      break;
    case BinOp::mul:
      r = b.CreateMul(op0, op1, "mul");
      break;
    case BinOp::sdiv:
      r = b.CreateSDiv(op0, op1, "sdiv");
      break;
    case BinOp::udiv:
      r = b.CreateUDiv(op0, op1, "udiv");
      break;
    case BinOp::lshr:
      r = b.CreateLShr(op0, op1, "lshr");
      break;
    case BinOp::ashr:
      r = b.CreateAShr(op0, op1, "ashr");
      break;
    case BinOp::shl:
      r = b.CreateShl(op0, op1, "shl");
      break;
    default:
      UNREACHABLE();
    }
    return r;
  } else if (auto B = dynamic_cast<SIMDBinOpIntr *>(I)) {
    auto op0 = codeGen(B->L(), VMap, constMap);
    auto op1 = codeGen(B->R(), VMap, constMap);
    llvm::Function *decl = nullptr;
    switch (B->K()) {
    case IR::X86IntrinBinOp::Op::sse2_psrl_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_psrl_w);
      break;
    case IR::X86IntrinBinOp::Op::sse2_psrl_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_psrl_d);
      break;
    case IR::X86IntrinBinOp::Op::sse2_psrl_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_psrl_q);
      break;
    case IR::X86IntrinBinOp::Op::avx2_psrl_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrl_w);
      break;
    case IR::X86IntrinBinOp::Op::avx2_psrl_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrl_d);
      break;
    case IR::X86IntrinBinOp::Op::avx2_psrl_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrl_q);
      break;
    case IR::X86IntrinBinOp::Op::sse2_pavg_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_pavg_w);
      break;
    case IR::X86IntrinBinOp::Op::avx2_pavg_b:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pavg_b);
      break;
    case IR::X86IntrinBinOp::Op::avx2_pavg_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pavg_w);
      break;
    case IR::X86IntrinBinOp::Op::avx2_pshuf_b:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pshuf_b);
      break;
    case IR::X86IntrinBinOp::Op::ssse3_pshuf_b_128:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_ssse3_pshuf_b_128);
      break;
    case IR::X86IntrinBinOp::Op::mmx_padd_b:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_padd_b);
      break;
    case IR::X86IntrinBinOp::Op::mmx_padd_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_padd_w);
      break;
    case IR::X86IntrinBinOp::Op::mmx_padd_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_padd_d);
      break;
    case IR::X86IntrinBinOp::Op::mmx_punpckhbw:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_punpckhbw);
      break;
    case IR::X86IntrinBinOp::Op::mmx_punpckhwd:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_punpckhwd);
      break;
    case IR::X86IntrinBinOp::Op::mmx_punpckhdq:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_punpckhdq);
      break;
    case IR::X86IntrinBinOp::Op::mmx_punpcklbw:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_punpcklbw);
      break;
    case IR::X86IntrinBinOp::Op::mmx_punpcklwd:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_punpcklwd);
      break;
    case IR::X86IntrinBinOp::Op::mmx_punpckldq:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_mmx_punpckldq);
      break;
    case IR::X86IntrinBinOp::Op::sse2_psrai_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_psrai_w);
      break;
    case IR::X86IntrinBinOp::Op::sse2_psrai_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_psrai_d);
      break;
    case IR::X86IntrinBinOp::Op::avx2_psrai_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrai_w);
      break;
    case IR::X86IntrinBinOp::Op::avx2_psrai_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrai_d);
      break;
    case IR::X86IntrinBinOp::Op::avx512_psrai_w_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_psrai_w_512);
      break;
    case IR::X86IntrinBinOp::Op::avx512_psrai_d_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_psrai_d_512);
      break;
    case IR::X86IntrinBinOp::Op::avx512_psrai_q_128:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_psrai_q_128);
      break;
    case IR::X86IntrinBinOp::Op::avx512_psrai_q_256:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_psrai_q_256);
      break;
    case IR::X86IntrinBinOp::Op::avx512_psrai_q_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_psrai_q_512);
      break;
    case IR::X86IntrinBinOp::Op::sse2_psrli_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_psrli_w);
      break;
    case IR::X86IntrinBinOp::Op::sse2_psrli_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_psrli_d);
      break;
    case IR::X86IntrinBinOp::Op::sse2_psrli_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_psrli_q);
      break;
    case IR::X86IntrinBinOp::Op::avx2_psrli_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrli_w);
      break;
    case IR::X86IntrinBinOp::Op::avx2_psrli_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrli_d);
      break;
    case IR::X86IntrinBinOp::Op::avx2_psrli_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrli_q);
      break;
    case IR::X86IntrinBinOp::Op::avx512_psrli_w_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_psrli_w_512);
      break;
    case IR::X86IntrinBinOp::Op::avx512_psrli_d_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_psrli_d_512);
      break;
    case IR::X86IntrinBinOp::Op::avx512_psrli_q_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_psrli_q_512);
    case IR::X86IntrinBinOp::Op::sse2_pslli_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_pslli_w);
      break;
    case IR::X86IntrinBinOp::Op::sse2_pslli_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_pslli_d);
      break;
    case IR::X86IntrinBinOp::Op::sse2_pslli_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_sse2_pslli_q);
      break;
    case IR::X86IntrinBinOp::Op::avx2_pslli_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pslli_w);
      break;
    case IR::X86IntrinBinOp::Op::avx2_pslli_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pslli_d);
      break;
    case IR::X86IntrinBinOp::Op::avx2_pslli_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pslli_q);
      break;
    case IR::X86IntrinBinOp::Op::avx512_pslli_w_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_pslli_w_512);
      break;
    case IR::X86IntrinBinOp::Op::avx512_pslli_d_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_pslli_d_512);
      break;
    case IR::X86IntrinBinOp::Op::avx512_pslli_q_512:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx512_pslli_q_512);
    /*
    case IR::SIMDBinOp::Op::x86_avx2_packssdw:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_packssdw);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_packsswb:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_packsswb);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_packusdw:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_packusdw);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_packuswb:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_packuswb);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_phadd_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_phadd_d);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_phadd_sw:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_phadd_sw);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_phadd_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_phadd_w);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_phsub_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_phsub_d);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_phsub_sw:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_phsub_sw);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_phsub_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_phsub_w);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_pmadd_ub_sw:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pmadd_ub_sw);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_pmadd_wd:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pmadd_wd);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_pmul_hr_sw:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pmul_hr_sw);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_pmulh_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pmulh_w);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_pmulhu_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_pmulhu_w);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psign_b:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psign_b);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psign_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psign_d);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psign_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psign_w);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psll_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psll_d);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psll_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psll_q);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psll_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psll_w);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psllv_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psllv_d);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psllv_d_256:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psllv_d_256);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psllv_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psllv_q);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psllv_q_256:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psllv_q_256);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrav_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrav_d);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrav_d_256:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrav_d_256);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrl_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrav_d);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrl_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrl_q);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrl_w:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrl_w);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrlv_d:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrlv_d);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrlv_d_256:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrlv_d_256);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrlv_q:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrlv_q);
      break;
    case IR::SIMDBinOp::Op::x86_avx2_psrlv_q_256:
      decl = Intrinsic::getDeclaration(M, Intrinsic::x86_avx2_psrlv_q_256);
      break; */
    default:
      UNREACHABLE();
    }
    IntrinsicDecls.insert(decl);
    return CallInst::Create(decl, ArrayRef<llvm::Value *>({op0, op1}), "intr",
                            cast<Instruction>(b.GetInsertPoint()));
  } else if (auto RC = dynamic_cast<ReservedConst *>(I)) {
    if (!constMap) {
      return RC->getA();
    } else {
      return (*constMap)[RC->getA()];
    }
#if (false)
  } else if (auto SV = dynamic_cast<minotaur::ShuffleVector *>(I)) {
    // TODO
    (void)SV;
    auto op0 = codeGen(SV->L(), b, VMap, F, constMap);
    auto op1 = codeGen(SV->R(), b, VMap, F, constMap);
    auto M = codeGen(SV->M(), b, VMap, F, constMap);
    return b.CreateShuffleVector(op0, op1, M);
  }
#endif
}
else if (auto L = dynamic_cast<minotaur::Load *>(I)) {
  auto op0 = codeGen(L->addr(), VMap, constMap);
  return b.CreateLoad(L->elemTy(), op0);
}
return nullptr;
}
}