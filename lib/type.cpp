// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "type.h"

#include "ir/instr.h"
#include "util/compiler.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ErrorHandling.h"
#include <string>

using namespace std;
using namespace llvm;

namespace minotaur {

type::type(llvm::Type *t) {
  if (t->isIntegerTy() || t->isIEEELikeFPTy()) {
    lane = 1;
    bits = t->getPrimitiveSizeInBits();
    fp = t->isIEEELikeFPTy();
  } else if (t->isVectorTy()) {
    if (isa<llvm::ScalableVectorType>(t))
      report_fatal_error("scalable vector type not yet supported");

    FixedVectorType *fty = cast<FixedVectorType>(t);
    Type *elemty = fty->getElementType();
    lane = fty->getNumElements();
    bits = elemty->getPrimitiveSizeInBits();
    if (elemty->isIntegerTy()) {
      fp = false;
    } else if (elemty->isIEEELikeFPTy()) {
      fp = true;
    } else {
      report_fatal_error("non-trivial vectors are not supported\n");
    }
  } else {
    llvm::errs()<<"[expr] type: "<<*t<<"\n";
    report_fatal_error("[expr] unrecognized type");
  }
}

bool type::operator==(const type &rhs) const {
  return lane == rhs.lane && bits == rhs.bits && fp == rhs.fp;
}

bool type::same_width(const type &rhs) const {
  assert(valid());
  return getWidth() == rhs.getWidth();
}

static Type* getFloatingPointType(LLVMContext &C, unsigned bits) {
  switch (bits) {
  case 16:
    return Type::getHalfTy(C);
  case 32:
    return Type::getFloatTy(C);
  case 64:
    return Type::getDoubleTy(C);
  case 128:
    return Type::getFP128Ty(C);
  }
  UNREACHABLE();
}

Type* type::toLLVM(LLVMContext &C) const {
  if (!valid()) {
    report_fatal_error("error minotaur type");
  }

  Type *Ty = nullptr;

  if (fp) {
    Ty = getFloatingPointType(C, bits);
  } else {
    Ty = Type::getIntNTy(C, bits);
  }

  if (lane != 1) {
    Ty = FixedVectorType::get(Ty, lane);
  }

  return Ty;
}

raw_ostream& operator<<(raw_ostream &os, const type &val) {
  if (!val.valid()) {
    os<<"null";
    return os;
  }

  if (val.fp) {
    os<<"<"<<val.lane<<" x ";
    switch(val.bits) {
    case 16:
      os<<"half";
      break;
    case 32:
      os<<"float";
      break;
    case 64:
      os<<"double";
      break;
    case 128:
      os<<"fp128";
      break;
    default:
      UNREACHABLE();
    }
    os<<">";
  } else {
    os<<"<"<<val.lane<<" x i"<<val.bits<<">";
  }
  return os;
}

type getIntrinsicOp0Ty(IR::X86IntrinBinOp::Op op) {
  return type(IR::X86IntrinBinOp::shape_op0[op].first,
              IR::X86IntrinBinOp::shape_op0[op].second, false);
}

type getIntrinsicOp1Ty(IR::X86IntrinBinOp::Op op) {
  return type(IR::X86IntrinBinOp::shape_op1[op].first,
              IR::X86IntrinBinOp::shape_op1[op].second, false);
}

type getIntrinsicRetTy(IR::X86IntrinBinOp::Op op) {
  return type(IR::X86IntrinBinOp::shape_ret[op].first,
              IR::X86IntrinBinOp::shape_ret[op].second, false);
}

vector<type> getIntegerVectorTypes(type ty) {
  unsigned width = ty.getWidth();
  vector<unsigned> bits = {64, 32, 16, 8};
  vector<type> types;
  if (width % 8 != 0) {
    return { ty };
  }
  for (unsigned i = 0 ; i < bits.size() ; ++ i) {
    if (width % bits[i] == 0 && width >= bits[i]) {
      types.push_back(type(width/bits[i], bits[i], false));
    }
  }
  return types;
}

} // namespace minotaur