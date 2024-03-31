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
  return lane == rhs.lane && bits == rhs.bits &&
         fp == rhs.fp;
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
  if (!isValid()) {
    report_fatal_error("invalid minotaur type");
  }

  Type *Ty = nullptr;

  if (fp) {
    Ty = getFloatingPointType(C, bits);
  } else {
    Ty = Type::getIntNTy(C, bits);
  }

  if (isVector()) {
    Ty = FixedVectorType::get(Ty, lane);
  }

  return Ty;
}

unsigned type::getWidth() const {
  return lane * bits;
}

unsigned type::getLane() const {
  return lane;
}

unsigned type::getBits() const {
  return bits;
}

bool type::isFP() const {
  return fp;
}

bool type::isValid() const{
  return lane != 0 && bits != 0;
}

bool type::isBool() const {
  return lane == 1 && bits == 1;
}

type type::getAsScalar() const {
  return type(1, bits, fp);
}

type type::getAsVector(unsigned lane) const {
  return type(lane, bits, fp);
}

type type::getAsIntTy() const {
  return fp ? type::Integer(getWidth()): type::IntegerVectorizable(lane, bits);
}

raw_ostream& operator<<(raw_ostream &os, const type &ty) {
  if (!ty.isValid()) {
    os<<"null";
    return os;
  }
  if (ty.isVector())
    os<<"<"<<ty.lane<<" x ";
  if (ty.isFP()) {
    switch(ty.bits) {
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
  } else {
    os<<"i"<<ty.bits;
  }
  if (ty.isVector())
    os<<">";
  return os;
}

type getIntrinsicOp0Ty(IR::X86IntrinBinOp::Op op) {
  return type::IntegerVectorizable(IR::X86IntrinBinOp::shape_op0[op].first,
                                   IR::X86IntrinBinOp::shape_op0[op].second);
}

type getIntrinsicOp1Ty(IR::X86IntrinBinOp::Op op) {
  return type::IntegerVectorizable(IR::X86IntrinBinOp::shape_op1[op].first,
                                   IR::X86IntrinBinOp::shape_op1[op].second);
}

type getIntrinsicRetTy(IR::X86IntrinBinOp::Op op) {
  return type::IntegerVectorizable(IR::X86IntrinBinOp::shape_ret[op].first,
                                   IR::X86IntrinBinOp::shape_ret[op].second);
}

vector<type> getIntegerVectorTypes(type ty) {
  unsigned width = ty.getWidth();

  if (width % 8 != 0) {
    return { ty };
  }

  vector<unsigned> bits{64, 32, 16, 8};
  vector<type> types;
  for (unsigned i = 0 ; i < 4 ; ++ i) {
    if (width % bits[i] == 0 && width >= bits[i]) {
      types.push_back(type::IntegerVectorizable(width/bits[i], bits[i]));
    }
  }
  return types;
}

} // namespace minotaur