// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "codegen.h"
#include "expr.h"

#include "ir/instr.h"

#include "llvm/CodeGen/MachineValueType.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicsX86.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

#include <iostream>

using namespace std;
using namespace llvm;

namespace {
struct debug {
template<class T>
debug &operator<<(const T &s)
{
  if (minotaur::config::debug_codegen)
    minotaur::config::dbg() << s;
  return *this;
}
};
}

namespace minotaur {

static constexpr
std::array<llvm::Intrinsic::ID, IR::X86IntrinBinOp::numOfX86Intrinsics> IntrinsicBinOpIDs = {
#define PROCESS(NAME,A,B,C,D,E,F) llvm::Intrinsic::NAME,
#include "ir/intrinsics_binop.h"
#undef PROCESS
};

static llvm::Intrinsic::ID getIntrinsicID(IR::X86IntrinBinOp::Op op) {
  return IntrinsicBinOpIDs[op];
}

static constexpr
std::array<llvm::Intrinsic::ID, IR::X86IntrinTerOp::numOfX86Intrinsics> IntrinsicTerOpIDs = {
#define PROCESS(NAME,A,B,C,D,E,F,G,H) llvm::Intrinsic::NAME,
#include "ir/intrinsics_terop.h"
#undef PROCESS
};

static llvm::Intrinsic::ID getIntrinsicID(IR::X86IntrinTerOp::Op op) {
  return IntrinsicTerOpIDs[op];
}

llvm::Value *LLVMGen::bitcastTo(llvm::Value *V, llvm::Type *to) {
  if (auto BC = dyn_cast<BitCastInst>(V)) {
    V = BC->getOperand(0);
  }
  debug() << "bitcastTo: " << *V << " to " << *to << "\n";
  return b.CreateBitCast(V, to);
}

llvm::Value*
LLVMGen::codeGenImpl(Inst *I, ValueToValueMapTy &VMap) {
  if (auto V = dynamic_cast<Var*>(I)) {
    if (VMap.empty()) {
      return V->V();
    } else {
      if (VMap.count(V->V())) {
        return VMap[V->V()];
      } else {
        llvm::errs()<<*V<<"\n";
        llvm::report_fatal_error("Value is not found in VMap");
      }
    }
  } else if (auto RC = dynamic_cast<ReservedConst*>(I)) {
    if (RC->getC()) {
      return RC->getC();
    } else {
      return RC->getA();
    }
  } else if (auto U = dynamic_cast<UnaryOp*>(I)) {
    type workty = U->getWorkTy();
    auto op0 = codeGenImpl(U->V(), VMap);
    if(!U->V()->getType().same_width(workty))
      report_fatal_error("operand width mismatch");
    op0 = bitcastTo(op0, workty.toLLVM(C));

    auto K = U->K();
    if (K == UnaryOp::fneg)
      return b.CreateFNeg(op0);

    Intrinsic::ID iid = 0;
    switch (K) {
    case UnaryOp::bitreverse: iid = Intrinsic::bitreverse; break;
    case UnaryOp::bswap:      iid = Intrinsic::bswap;      break;
    case UnaryOp::ctpop:      iid = Intrinsic::ctpop;      break;
    case UnaryOp::ctlz:       iid = Intrinsic::ctlz;       break;
    case UnaryOp::cttz:       iid = Intrinsic::cttz;       break;
    case UnaryOp::fabs:       iid = Intrinsic::fabs;       break;
    case UnaryOp::fceil:      iid = Intrinsic::ceil;       break;
    case UnaryOp::ffloor:     iid = Intrinsic::floor;      break;
    case UnaryOp::frint:      iid = Intrinsic::rint;       break;
    case UnaryOp::fnearbyint: iid = Intrinsic::nearbyint;  break;
    case UnaryOp::fround:     iid = Intrinsic::round;      break;
    case UnaryOp::froundeven: iid = Intrinsic::roundeven;  break;
    case UnaryOp::ftrunc:     iid = Intrinsic::trunc;      break;
    default: UNREACHABLE();
    }

    CallInst *CI = nullptr;
    if (K == UnaryOp::ctlz || K == UnaryOp::cttz) {
      CI = b.CreateBinaryIntrinsic(iid, op0, b.getFalse());
    } else {
      CI = b.CreateUnaryIntrinsic(iid, op0);
    }
    IntrinsicDecls.insert(CI->getCalledFunction());
    return CI;
  } else if (auto U = dynamic_cast<Copy*>(I)) {
    auto op0 = codeGenImpl(U->V(), VMap);
    return op0;
  } else if (auto CI = dynamic_cast<IntConversion*>(I)) {
    auto op0 = codeGenImpl(CI->V(), VMap);
    op0 = bitcastTo(op0, CI->getPrevTy().toLLVM(C));
    Type *new_type = CI->getNewTy().toLLVM(C);
    llvm::Value *r = nullptr;
    switch (CI->K()) {
    case IntConversion::sext:
      r = b.CreateSExt(op0, new_type);
      break;
    case IntConversion::zext:
      r = b.CreateZExt(op0, new_type);
      break;
    case IntConversion::trunc:
      r = b.CreateTrunc(op0, new_type);
      break;
    }
    return r;
  } else if (auto FI = dynamic_cast<FPConversion*>(I)) {
    auto op0 = codeGenImpl(FI->V(), VMap);
    op0 = bitcastTo(op0, FI->getPrevTy().toLLVM(C));
    Type* new_type = FI->getNewTy().toLLVM(C);
    llvm::Value *r = nullptr;

    switch (FI->K()) {
    case FPConversion::fptrunc:
      r = b.CreateFPTrunc(op0, new_type);
      break;
    case FPConversion::fpext:
      r = b.CreateFPExt(op0, new_type);
      break;
    case FPConversion::fptoui:
      r = b.CreateFPToUI(op0, new_type);
      break;
    case FPConversion::fptosi:
      r = b.CreateFPToSI(op0, new_type);
      break;
    case FPConversion::uitofp:
      r = b.CreateUIToFP(op0, new_type);
      break;
    case FPConversion::sitofp:
      r = b.CreateSIToFP(op0, new_type);
      break;
    }
    return r;
  } else if (auto B = dynamic_cast<BinaryOp*>(I)) {
    type workty = B->getWorkTy();
    auto op0 = codeGenImpl(B->L(), VMap);
    if(!workty.same_width(B->L()->getType()))
      report_fatal_error("left operand width mismatch");
    op0 = bitcastTo(op0, workty.toLLVM(C));

    auto op1 = codeGenImpl(B->R(), VMap);
    if(!workty.same_width(B->R()->getType()))
      report_fatal_error("left operand width mismatch");
    op1 = bitcastTo(op1, workty.toLLVM(C));

    Intrinsic::ID iid = 0;
    switch (B->K()) {
    case BinaryOp::fmaxnum:    iid = Intrinsic::maxnum;     break;
    case BinaryOp::fminnum:    iid = Intrinsic::minnum;     break;
    case BinaryOp::fmaximum:   iid = Intrinsic::maximum;    break;
    case BinaryOp::fminimum:   iid = Intrinsic::minimum;    break;
    case BinaryOp::copysign:   iid = Intrinsic::copysign;   break;
    case BinaryOp::umax:       iid = Intrinsic::umax;       break;
    case BinaryOp::umin:       iid = Intrinsic::umin;       break;
    case BinaryOp::smax:       iid = Intrinsic::smax;       break;
    case BinaryOp::smin:       iid = Intrinsic::smin;       break;
    default: break;
    }
    if (iid) {
      CallInst *C = b.CreateBinaryIntrinsic(iid, op0, op1);
      IntrinsicDecls.insert(C->getCalledFunction());
      return C;
    }

    llvm::Value *r = nullptr;
    switch (B->K()) {
    case BinaryOp::band:
      r = b.CreateAnd(op0, op1, "and");
      break;
    case BinaryOp::bor:
      r = b.CreateOr(op0, op1, "or");
      break;
    case BinaryOp::bxor:
      r = b.CreateXor(op0, op1, "xor");
      break;
    case BinaryOp::add:
      r = b.CreateAdd(op0, op1, "add");
      break;
    case BinaryOp::sub:
      r = b.CreateSub(op0, op1, "sub");
      break;
    case BinaryOp::mul:
      r = b.CreateMul(op0, op1, "mul");
      break;
    case BinaryOp::sdiv:
      r = b.CreateSDiv(op0, op1, "sdiv");
      break;
    case BinaryOp::udiv:
      r = b.CreateUDiv(op0, op1, "udiv");
      break;
    case BinaryOp::lshr:
      r = b.CreateLShr(op0, op1, "lshr");
      break;
    case BinaryOp::ashr:
      r = b.CreateAShr(op0, op1, "ashr");
      break;
    case BinaryOp::shl:
      r = b.CreateShl(op0, op1, "shl");
      break;
    case BinaryOp::fadd:
      r = b.CreateFAdd(op0, op1, "fadd");
      break;
    case BinaryOp::fsub:
      r = b.CreateFSub(op0, op1, "fsub");
      break;
    case BinaryOp::fmul:
      r = b.CreateFMul(op0, op1, "fmul");
      break;
    case BinaryOp::fdiv:
      r = b.CreateFDiv(op0, op1, "fdiv");
      break;
    // case BinaryOp::frem:
    //   r = b.CreateFRem(op0, op1, "frem");
  //   break;
    default:
      UNREACHABLE();
    }
    return r;
  } else if (auto IC = dynamic_cast<ICmp*>(I)) {
    auto op0 = codeGenImpl(IC->L(), VMap);
    auto IC_ty = IC->getType();
    auto workty = type::IntegerVectorizable(IC_ty.getLane(), IC->getBits());
    op0 = bitcastTo(op0, workty.toLLVM(C));

    auto op1 = codeGenImpl(IC->R(), VMap);
    op1 = bitcastTo(op1, workty.toLLVM(C));
    llvm::Value *r = nullptr;
    switch (IC->K()) {
    case ICmp::eq:
      r = b.CreateICmp(CmpInst::ICMP_EQ, op0, op1, "ieq");
      break;
    case ICmp::ne:
      r = b.CreateICmp(CmpInst::ICMP_NE, op0, op1, "ine");
      break;
    case ICmp::ult:
      r = b.CreateICmp(CmpInst::ICMP_ULT, op0, op1, "iult");
      break;
    case ICmp::ule:
      r = b.CreateICmp(CmpInst::ICMP_ULE, op0, op1, "iule");
      break;
    case ICmp::slt:
      r = b.CreateICmp(CmpInst::ICMP_SLT, op0, op1, "islt");
      break;
    case ICmp::sle:
      r = b.CreateICmp(CmpInst::ICMP_SLE, op0, op1, "isle");
      break;
    case ICmp::ugt:
      r = b.CreateICmp(CmpInst::ICMP_UGT, op0, op1, "iugt");
      break;
    case ICmp::uge:
      r = b.CreateICmp(CmpInst::ICMP_UGE, op0, op1, "iuge");
      break;
    case ICmp::sgt:
      r = b.CreateICmp(CmpInst::ICMP_SGT, op0, op1, "isgt");
      break;
    case ICmp::sge:
      r = b.CreateICmp(CmpInst::ICMP_SGE, op0, op1, "isge");
      break;
    }
    return r;

  } else if (auto FC = dynamic_cast<FCmp*>(I)) {
    auto op0 = codeGenImpl(FC->L(), VMap);
    auto op1 = codeGenImpl(FC->R(), VMap);
    llvm::Value *r = nullptr;

    switch (FC->K()) {
    case FCmp::f:
      r = ConstantInt::getFalse(C);
      if (FC->getLanes() > 1)
        r = b.CreateVectorSplat(FC->getLanes(), r);
      break;
    case FCmp::ord:
      r = b.CreateFCmpORD(op0, op1, "ord");
      break;
    case FCmp::oeq:
      r = b.CreateFCmpOEQ(op0, op1, "oeq");
      break;
    case FCmp::ogt:
      r = b.CreateFCmpOGT(op0, op1, "ogt");
      break;
    case FCmp::oge:
      r = b.CreateFCmpOGE(op0, op1, "oge");
      break;
    case FCmp::olt:
      r = b.CreateFCmpOLT(op0, op1, "olt");
      break;
    case FCmp::ole:
      r = b.CreateFCmpOLE(op0, op1, "ole");
      break;
    case FCmp::one:
      r = b.CreateFCmpONE(op0, op1, "one");
      break;
    case FCmp::ueq:
      r = b.CreateFCmpUEQ(op0, op1, "ueq");
      break;
    case FCmp::ugt:
      r = b.CreateFCmpUGT(op0, op1, "ugt");
      break;
    case FCmp::uge:
      r = b.CreateFCmpUGE(op0, op1, "uge");
      break;
    case FCmp::ult:
      r = b.CreateFCmpULT(op0, op1, "ult");
      break;
    case FCmp::ule:
      r = b.CreateFCmpULE(op0, op1, "ule");
      break;
    case FCmp::une:
      r = b.CreateFCmpUNE(op0, op1, "une");
      break;
    case FCmp::uno:
      r = b.CreateFCmpUNO(op0, op1, "uno");
      break;
    case FCmp::t:
      r = ConstantInt::getTrue(C);
      if (FC->getLanes() > 1)
        r = b.CreateVectorSplat(FC->getLanes(), r);
      break;
    }
    return r;
  } else if (auto B = dynamic_cast<SIMDBinOpInst*>(I)) {
    type op0_ty = getIntrinsicOp0Ty(B->K());
    type op1_ty = getIntrinsicOp1Ty(B->K());
    auto op0 = codeGenImpl(B->L(), VMap);
    if(!op0_ty.same_width(B->L()->getType()))
      report_fatal_error("left operand width mismatch");
    op0 = bitcastTo(op0, op0_ty.toLLVM(C));

    auto op1 = codeGenImpl(B->R(), VMap);
    if(!op1_ty.same_width(B->R()->getType()))
      report_fatal_error("right operand width mismatch");
    op1 = bitcastTo(op1, op1_ty.toLLVM(C));

    llvm::Function *decl = Intrinsic::getDeclaration(M, getIntrinsicID(B->K()));
    IntrinsicDecls.insert(decl);

    llvm::Value *CI = CallInst::Create(decl,
                                       ArrayRef<llvm::Value *>({op0, op1}),
                                       "intr",
                                       cast<Instruction>(b.GetInsertPoint()));
    return CI;
  // TODO: handle terop
  } else if (auto FSV = dynamic_cast<FakeShuffleInst*>(I)) {
    auto op0 = codeGenImpl(FSV->L(), VMap);
    llvm::Type *op_ty = FSV->getInputTy().toLLVM(C);
    op0 = bitcastTo(op0, op_ty);
    llvm::Value *op1 = nullptr;
    if (FSV->R()) {
      op1 = bitcastTo(codeGenImpl(FSV->R(), VMap), op_ty);
    } else {
      op1 = llvm::PoisonValue::get(op_ty);
    }
    auto mask = codeGenImpl(FSV->M(), VMap);
    llvm::Value *SV = nullptr;
    if (isa<Constant>(mask)) {
      SV = b.CreateShuffleVector(op0, op1, mask, "sv");
    } else {
      std::vector<llvm::Type*> Args(2, op_ty);
      Args.push_back(FSV->M()->getType().toLLVM(C));
      FunctionType *FT = FunctionType::get(FSV->getRetTy().toLLVM(C), Args, false);
      llvm::Function *F =
        llvm::Function::Create(FT, llvm::Function::ExternalLinkage, "__fksv", M);
      IntrinsicDecls.insert(F);
      SV = b.CreateCall(F, { op0, op1, mask }, "sv");
    }
    return SV;
  } else if (auto FEE = dynamic_cast<ExtractElement*>(I)) {
    auto op0 = codeGenImpl(FEE->V(), VMap);
    llvm::Type *op_ty = FEE->getInputTy().toLLVM(C);
    op0 = bitcastTo(op0, op_ty);
    auto idx = codeGenImpl(FEE->Idx(), VMap);
    return b.CreateExtractElement(op0, idx, "ee");
  } else if (auto IE = dynamic_cast<InsertElement*>(I)) {
    auto op0 = codeGenImpl(IE->V(), VMap);
    llvm::Type *op_ty = IE->getInputTy().toLLVM(C);
    op0 = bitcastTo(op0, op_ty);
    auto op1 = codeGenImpl(IE->Elt(), VMap);
    op1 = bitcastTo(op1, op_ty->getScalarType());
    auto idx = codeGenImpl(IE->Idx(), VMap);
    return b.CreateInsertElement(op0, op1, idx, "ie");
  } else if (auto S = dynamic_cast<Select*>(I)) {
    auto cond = codeGenImpl(S->Cond(), VMap);
    auto op0 = codeGenImpl(S->L(), VMap);
    op0 = bitcastTo(op0, S->getType().toLLVM(C));
    auto op1 = codeGenImpl(S->R(), VMap);
    op1 = bitcastTo(op1, S->getType().toLLVM(C));
    return b.CreateSelect(cond, op0, op1, "sel");
  }
  llvm::report_fatal_error("[ERROR] unknown instruction found in LLVMGen");
}

llvm::Value *LLVMGen::codeGen(Inst *I, ValueToValueMapTy &VMap) {
  return codeGenImpl(I, VMap);
}

}