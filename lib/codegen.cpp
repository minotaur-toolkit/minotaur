// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "codegen.h"
#include "config.h"
#include "expr.h"

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

using namespace std;
using namespace llvm;

namespace minotaur {

using debug = config::DebugStream<
    &config::debug_codegen>;

static constexpr
std::array<llvm::Intrinsic::ID, numOfX86BinOpIntrinsics> IntrinsicBinOpIDs = {
#define PROCESS(NAME,A,B,C,D,E,F) llvm::Intrinsic::NAME,
#include "ir/x86_intrinsics_binop.inc"
#undef PROCESS
};

static llvm::Intrinsic::ID getIntrinsicID(IR::X86IntrinBinOp::Op op) {
  assert(static_cast<unsigned>(op) < numOfX86BinOpIntrinsics &&
         "X86IntrinBinOp::Op out of range");
  return IntrinsicBinOpIDs[op];
}

static constexpr
std::array<llvm::Intrinsic::ID, numOfX86TerOpIntrinsics> IntrinsicTerOpIDs = {
#define PROCESS(NAME,A,B,C,D,E,F,G,H) llvm::Intrinsic::NAME,
#include "ir/x86_intrinsics_terop.inc"
#undef PROCESS
};

// Used for ternary intrinsics (TODO: handle terop)
[[maybe_unused]]
static llvm::Intrinsic::ID getIntrinsicID(IR::X86IntrinTerOp::Op op) {
  assert(static_cast<unsigned>(op) < numOfX86TerOpIntrinsics &&
         "X86IntrinTerOp::Op out of range");
  return IntrinsicTerOpIDs[op];
}


llvm::Value *LLVMGen::bitcastTo(llvm::Value *V, llvm::Type *to) {
  if (auto BC = dyn_cast<BitCastInst>(V)) {
    V = BC->getOperand(0);
  }
  debug() << "bitcastTo: " << *V << " to " << *to << "\n";
  return Builder.CreateBitCast(V, to);
}

llvm::Value*
LLVMGen::codeGenImpl(Inst *I, ValueToValueMapTy &VMap) {
  if (auto V = dynamic_cast<Var*>(I)) {
    if (VMap.empty()) {
      return V->getValue();
    } else {
      if (VMap.count(V->getValue())) {
        return VMap[V->getValue()];
      } else {
        llvm::errs() << *V << "\n";
        llvm::report_fatal_error("Value is not found in VMap");
      }
    }
  } else if (auto RC = dynamic_cast<ReservedConst*>(I)) {
    if (RC->getConst()) {
      return RC->getConst();
    } else {
      return RC->getArg();
    }
  } else if (auto U = dynamic_cast<UnaryOp*>(I)) {
    type workty = U->getWorkTy();
    llvm::Type *lty = workty.toLLVM(Ctx);
    auto op0 = codeGenImpl(U->getOperand(), VMap);
    if (!U->getOperand()->getType().same_width(workty))
      report_fatal_error("operand width mismatch");
    op0 = bitcastTo(op0, lty);

    auto K = U->getOpcode();
    if (K == UnaryOp::fneg)
      return Builder.CreateFNeg(op0);

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
      CI = Builder.CreateIntrinsic(lty, iid, {op0, Builder.getFalse()});
    } else {
      CI = Builder.CreateIntrinsic(lty, iid, {op0});
    }
    IntrinsicDecls.insert(CI->getCalledFunction());
    return CI;
  } else if (auto U = dynamic_cast<Copy*>(I)) {
    auto op0 = codeGenImpl(U->getReservedConst(), VMap);
    return op0;
  } else if (auto CI = dynamic_cast<IntConversion*>(I)) {
    auto op0 = codeGenImpl(CI->getOperand(), VMap);
    op0 = bitcastTo(op0, CI->getPrevTy().toLLVM(Ctx));
    Type *new_type = CI->getNewTy().toLLVM(Ctx);
    llvm::Value *r = nullptr;
    switch (CI->getOpcode()) {
    case IntConversion::sext:
      r = Builder.CreateSExt(op0, new_type);
      break;
    case IntConversion::zext:
      r = Builder.CreateZExt(op0, new_type);
      break;
    case IntConversion::trunc:
      r = Builder.CreateTrunc(op0, new_type);
      break;
    }
    return r;
  } else if (auto FI = dynamic_cast<FPConversion*>(I)) {
    auto op0 = codeGenImpl(FI->getOperand(), VMap);
    op0 = bitcastTo(op0, FI->getPrevTy().toLLVM(Ctx));
    Type* new_type = FI->getNewTy().toLLVM(Ctx);
    llvm::Value *r = nullptr;

    switch (FI->getOpcode()) {
    case FPConversion::fptrunc:
      r = Builder.CreateFPTrunc(op0, new_type);
      break;
    case FPConversion::fpext:
      r = Builder.CreateFPExt(op0, new_type);
      break;
    case FPConversion::fptoui:
      r = Builder.CreateFPToUI(op0, new_type);
      break;
    case FPConversion::fptosi:
      r = Builder.CreateFPToSI(op0, new_type);
      break;
    case FPConversion::uitofp:
      r = Builder.CreateUIToFP(op0, new_type);
      break;
    case FPConversion::sitofp:
      r = Builder.CreateSIToFP(op0, new_type);
      break;
    }
    return r;
  } else if (auto B = dynamic_cast<BinaryOp*>(I)) {
    type workty = B->getWorkTy();
    llvm::Type *lty = workty.toLLVM(Ctx);
    auto op0 = codeGenImpl(B->getLHS(), VMap);
    if (!workty.same_width(B->getLHS()->getType()))
      report_fatal_error("left operand width mismatch");
    op0 = bitcastTo(op0, lty);

    auto op1 = codeGenImpl(B->getRHS(), VMap);
    if (!workty.same_width(B->getRHS()->getType()))
      report_fatal_error("right operand width mismatch");
    op1 = bitcastTo(op1, lty);

    Intrinsic::ID iid = 0;
    switch (B->getOpcode()) {
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
      CallInst *C = Builder.CreateIntrinsic(lty, iid, {op0, op1});
      IntrinsicDecls.insert(C->getCalledFunction());
      return C;
    }

    llvm::Value *r = nullptr;
    switch (B->getOpcode()) {
    case BinaryOp::band:
      r = Builder.CreateAnd(op0, op1, "and");
      break;
    case BinaryOp::bor:
      r = Builder.CreateOr(op0, op1, "or");
      break;
    case BinaryOp::bxor:
      r = Builder.CreateXor(op0, op1, "xor");
      break;
    case BinaryOp::add:
      r = Builder.CreateAdd(op0, op1, "add");
      break;
    case BinaryOp::sub:
      r = Builder.CreateSub(op0, op1, "sub");
      break;
    case BinaryOp::mul:
      r = Builder.CreateMul(op0, op1, "mul");
      break;
    case BinaryOp::sdiv:
      r = Builder.CreateSDiv(op0, op1, "sdiv");
      break;
    case BinaryOp::udiv:
      r = Builder.CreateUDiv(op0, op1, "udiv");
      break;
    case BinaryOp::lshr:
      r = Builder.CreateLShr(op0, op1, "lshr");
      break;
    case BinaryOp::ashr:
      r = Builder.CreateAShr(op0, op1, "ashr");
      break;
    case BinaryOp::shl:
      r = Builder.CreateShl(op0, op1, "shl");
      break;
    case BinaryOp::fadd:
      r = Builder.CreateFAdd(op0, op1, "fadd");
      break;
    case BinaryOp::fsub:
      r = Builder.CreateFSub(op0, op1, "fsub");
      break;
    case BinaryOp::fmul:
      r = Builder.CreateFMul(op0, op1, "fmul");
      break;
    case BinaryOp::fdiv:
      r = Builder.CreateFDiv(op0, op1, "fdiv");
      break;
    default:
      UNREACHABLE();
    }
    return r;
  } else if (auto IC = dynamic_cast<ICmp*>(I)) {
    auto op0 = codeGenImpl(IC->getLHS(), VMap);
    auto IC_ty = IC->getType();
    auto workty = type::IntegerVectorizable(IC_ty.getLane(), IC->getBits());
    op0 = bitcastTo(op0, workty.toLLVM(Ctx));

    auto op1 = codeGenImpl(IC->getRHS(), VMap);
    op1 = bitcastTo(op1, workty.toLLVM(Ctx));
    llvm::Value *r = nullptr;
    switch (IC->getCond()) {
    case ICmp::eq:
      r = Builder.CreateICmp(CmpInst::ICMP_EQ, op0, op1, "ieq");
      break;
    case ICmp::ne:
      r = Builder.CreateICmp(CmpInst::ICMP_NE, op0, op1, "ine");
      break;
    case ICmp::ult:
      r = Builder.CreateICmp(CmpInst::ICMP_ULT, op0, op1, "iult");
      break;
    case ICmp::ule:
      r = Builder.CreateICmp(CmpInst::ICMP_ULE, op0, op1, "iule");
      break;
    case ICmp::slt:
      r = Builder.CreateICmp(CmpInst::ICMP_SLT, op0, op1, "islt");
      break;
    case ICmp::sle:
      r = Builder.CreateICmp(CmpInst::ICMP_SLE, op0, op1, "isle");
      break;
    case ICmp::ugt:
      r = Builder.CreateICmp(CmpInst::ICMP_UGT, op0, op1, "iugt");
      break;
    case ICmp::uge:
      r = Builder.CreateICmp(CmpInst::ICMP_UGE, op0, op1, "iuge");
      break;
    case ICmp::sgt:
      r = Builder.CreateICmp(CmpInst::ICMP_SGT, op0, op1, "isgt");
      break;
    case ICmp::sge:
      r = Builder.CreateICmp(CmpInst::ICMP_SGE, op0, op1, "isge");
      break;
    }
    return r;

  } else if (auto FC = dynamic_cast<FCmp*>(I)) {
    auto op0 = codeGenImpl(FC->getLHS(), VMap);
    auto op1 = codeGenImpl(FC->getRHS(), VMap);
    llvm::Value *r = nullptr;

    switch (FC->getCond()) {
    case FCmp::f:
      r = ConstantInt::getFalse(Ctx);
      if (FC->getLanes() > 1)
        r = Builder.CreateVectorSplat(FC->getLanes(), r);
      break;
    case FCmp::ord:
      r = Builder.CreateFCmpORD(op0, op1, "ord");
      break;
    case FCmp::oeq:
      r = Builder.CreateFCmpOEQ(op0, op1, "oeq");
      break;
    case FCmp::ogt:
      r = Builder.CreateFCmpOGT(op0, op1, "ogt");
      break;
    case FCmp::oge:
      r = Builder.CreateFCmpOGE(op0, op1, "oge");
      break;
    case FCmp::olt:
      r = Builder.CreateFCmpOLT(op0, op1, "olt");
      break;
    case FCmp::ole:
      r = Builder.CreateFCmpOLE(op0, op1, "ole");
      break;
    case FCmp::one:
      r = Builder.CreateFCmpONE(op0, op1, "one");
      break;
    case FCmp::ueq:
      r = Builder.CreateFCmpUEQ(op0, op1, "ueq");
      break;
    case FCmp::ugt:
      r = Builder.CreateFCmpUGT(op0, op1, "ugt");
      break;
    case FCmp::uge:
      r = Builder.CreateFCmpUGE(op0, op1, "uge");
      break;
    case FCmp::ult:
      r = Builder.CreateFCmpULT(op0, op1, "ult");
      break;
    case FCmp::ule:
      r = Builder.CreateFCmpULE(op0, op1, "ule");
      break;
    case FCmp::une:
      r = Builder.CreateFCmpUNE(op0, op1, "une");
      break;
    case FCmp::uno:
      r = Builder.CreateFCmpUNO(op0, op1, "uno");
      break;
    case FCmp::t:
      r = ConstantInt::getTrue(Ctx);
      if (FC->getLanes() > 1)
        r = Builder.CreateVectorSplat(FC->getLanes(), r);
      break;
    }
    return r;
  } else if (auto B = dynamic_cast<SIMDBinOpInst*>(I)) {
    type op0_ty = getIntrinsicOp0Ty(B->getOpcode());
    type op1_ty = getIntrinsicOp1Ty(B->getOpcode());
    auto op0 = codeGenImpl(B->getLHS(), VMap);
    if (!op0_ty.same_width(B->getLHS()->getType()))
      report_fatal_error("left operand width mismatch");
    op0 = bitcastTo(op0, op0_ty.toLLVM(Ctx));

    auto op1 = codeGenImpl(B->getRHS(), VMap);
    if (!op1_ty.same_width(B->getRHS()->getType()))
      report_fatal_error("right operand width mismatch");
    op1 = bitcastTo(op1, op1_ty.toLLVM(Ctx));

    llvm::Function *decl = Intrinsic::getOrInsertDeclaration(Mod, getIntrinsicID(B->getOpcode()));
    IntrinsicDecls.insert(decl);

    llvm::Value *CI = CallInst::Create(decl,
                                       ArrayRef<llvm::Value *>({op0, op1}),
                                       "intr",
                                       Builder.GetInsertPoint());
    return CI;
  // TODO: handle terop
  } else if (auto FSV = dynamic_cast<FakeShuffleInst*>(I)) {
    auto op0 = codeGenImpl(FSV->getLHS(), VMap);
    llvm::Type *op_ty = FSV->getInputTy().toLLVM(Ctx);
    op0 = bitcastTo(op0, op_ty);
    llvm::Value *op1 = nullptr;
    if (FSV->getRHS()) {
      op1 = bitcastTo(codeGenImpl(FSV->getRHS(), VMap), op_ty);
    } else {
      op1 = llvm::PoisonValue::get(op_ty);
    }
    auto mask = codeGenImpl(FSV->getMask(), VMap);
    llvm::Value *SV = nullptr;
    if (isa<Constant>(mask)) {
      SV = Builder.CreateShuffleVector(op0, op1, mask, "sv");
    } else {
      std::vector<llvm::Type*> Args(2, op_ty);
      Args.push_back(FSV->getMask()->getType().toLLVM(Ctx));
      FunctionType *FT = FunctionType::get(FSV->getRetTy().toLLVM(Ctx), Args, false);
      llvm::Function *F =
        llvm::Function::Create(FT, llvm::Function::ExternalLinkage, "__fksv", Mod);
      IntrinsicDecls.insert(F);
      SV = Builder.CreateCall(F, { op0, op1, mask }, "sv");
    }
    return SV;
  } else if (auto FEE = dynamic_cast<ExtractElement*>(I)) {
    auto op0 = codeGenImpl(FEE->getVector(), VMap);
    llvm::Type *op_ty = FEE->getInputTy().toLLVM(Ctx);
    op0 = bitcastTo(op0, op_ty);
    auto idx = codeGenImpl(FEE->getIndex(), VMap);
    return Builder.CreateExtractElement(op0, idx, "ee");
  } else if (auto IE = dynamic_cast<InsertElement*>(I)) {
    auto op0 = codeGenImpl(IE->getVector(), VMap);
    llvm::Type *op_ty = IE->getInputTy().toLLVM(Ctx);
    op0 = bitcastTo(op0, op_ty);
    auto op1 = codeGenImpl(IE->getElement(), VMap);
    op1 = bitcastTo(op1, op_ty->getScalarType());
    auto idx = codeGenImpl(IE->getIndex(), VMap);
    return Builder.CreateInsertElement(op0, op1, idx, "ie");
  } else if (auto S = dynamic_cast<Select*>(I)) {
    auto cond = codeGenImpl(S->getCond(), VMap);
    auto op0 = codeGenImpl(S->getLHS(), VMap);
    op0 = bitcastTo(op0, S->getType().toLLVM(Ctx));
    auto op1 = codeGenImpl(S->getRHS(), VMap);
    op1 = bitcastTo(op1, S->getType().toLLVM(Ctx));
    return Builder.CreateSelect(
        cond, op0, op1, "sel");
  }
  llvm::report_fatal_error("[ERROR] unknown instruction found in LLVMGen");
}

llvm::Value *LLVMGen::codeGen(Inst *I, ValueToValueMapTy &VMap) {
  return codeGenImpl(I, VMap);
}

}