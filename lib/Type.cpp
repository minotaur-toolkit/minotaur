// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "ir/instr.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/Support/ErrorHandling.h"
#include <Type.h>

using namespace std;
using namespace llvm;

namespace minotaur {

type::type(llvm::Type *t) {
  if (t->isIntegerTy()) {
    lane = 1;
    bits = t->getPrimitiveSizeInBits();
  } else if (t->isVectorTy()) {
    if (llvm::isa<llvm::ScalableVectorType>(t))
      llvm::report_fatal_error("scalable vector type not yet supported");
    llvm::FixedVectorType *fty = cast<llvm::FixedVectorType>(t);
    lane = fty->getNumElements();
    bits = fty->getElementType()->getPrimitiveSizeInBits();
  } else if (t->isPointerTy()) {

  } else {
    llvm::report_fatal_error("unrecognized type");
  }
}

Type* type::toLLVM(llvm::LLVMContext &C) {
  if (lane == 0 || bits == 0)
    report_fatal_error("error minotaur type");
  if (lane == 1) {
    return Type::getIntNTy(C, bits);
  } else {
    return FixedVectorType::get(Type::getIntNTy(C, bits), lane);
  }
}

ostream& operator<<(ostream &os, const type &val) {
  os<<"("<<val.lane<<" x i"<<val.bits<<")";
  return os;
}

type type::getIntrinsicOp0Ty(IR::X86IntrinBinOp::Op op) {
  return type(IR::X86IntrinBinOp::shape_op0[op].first,
              IR::X86IntrinBinOp::shape_op0[op].second, false);
}

type type::getIntrinsicOp1Ty(IR::X86IntrinBinOp::Op op) {
  return type(IR::X86IntrinBinOp::shape_op1[op].first,
              IR::X86IntrinBinOp::shape_op1[op].second, false);
}

type type::getIntrinsicRetTy(IR::X86IntrinBinOp::Op op) {
  return type(IR::X86IntrinBinOp::shape_ret[op].first,
              IR::X86IntrinBinOp::shape_ret[op].second, false);
}

} // namespace minotaur