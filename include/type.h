// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "ir/instr.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

namespace minotaur {

class type {
  unsigned lane, bits;
  bool scalar;
  bool fp;
  type(unsigned l, unsigned b, bool s, bool f) :
    lane(l), bits(b), scalar(s), fp(f) {};

public:
  static type Scalar(unsigned bits, bool fp) {
    return type(1, bits, true, fp);
  }
  static type Integer(unsigned bits) {
    return Scalar(bits, false);
  }
  static type Vector(unsigned lane, unsigned bits, bool fp) {
    if (lane == 1) {
      llvm::report_fatal_error("vector with lane 1 is scalar");
    }
    return type(lane, bits, false, fp);
  }
  static type IntegerVector(unsigned lane, unsigned bits) {
    return Vector(lane, bits, false);
  }
  static type Null() {
    return type(0, 0, false, false);
  }

  type(const type &t)
  : lane(t.getLane()), bits(t.getBits()), scalar(t.isScalar()), fp(t.isFP()) {}
  type(llvm::Type *t);

  bool isVector() const { return !scalar; }
  bool isScalar() const { return scalar; }

  bool operator==(const type &rhs) const;
  bool same_width(const type &rhs) const;

  friend llvm::raw_ostream& operator<<(llvm::raw_ostream &os, const type &val);

  llvm::Type *toLLVM(llvm::LLVMContext&) const;

  unsigned getWidth() const;
  unsigned getLane() const;
  unsigned getBits() const;
  bool isFP() const;
  bool isValid() const;
  bool isBool() const;
  type getAsScalar() const;
  type getAsIntTy() const;
};

type getIntrinsicRetTy(IR::X86IntrinBinOp::Op);
type getIntrinsicOp0Ty(IR::X86IntrinBinOp::Op);
type getIntrinsicOp1Ty(IR::X86IntrinBinOp::Op);

std::vector<type> getIntegerVectorTypes(type);

} // namespace minotaur