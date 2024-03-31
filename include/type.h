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
  bool fp;
  type(unsigned l, unsigned b, bool f) :
    lane(l), bits(b), fp(f) {};

public:
  static type Scalar(unsigned bits, bool fp) {
    return type(1, bits, fp);
  }
  static type Integer(unsigned bits) {
    return Scalar(bits, false);
  }
  static type Vectorizable(unsigned lane, unsigned bits, bool fp) {
    return type(lane, bits, fp);
  }
  static type IntegerVectorizable(unsigned lane, unsigned bits) {
    return Vectorizable(lane, bits, false);
  }
  static type Null() {
    return type(0, 0, false);
  }
  static type Float() {
    return Scalar(32, true);
  }
  static type Double() {
    return Scalar(64, true);
  }
  static type Half() {
    return Scalar(16, true);
  }
  static type FP128() {
    return Scalar(128, true);
  }

  type(const type &t)
  : lane(t.getLane()), bits(t.getBits()), fp(t.isFP()) {}
  type(llvm::Type *t);

  bool isVector() const { return lane  > 1; }
  bool isScalar() const { return lane == 1; }

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
  type getAsVector(unsigned lane) const;
  type getAsIntTy() const;
};

type getIntrinsicRetTy(IR::X86IntrinBinOp::Op);
type getIntrinsicOp0Ty(IR::X86IntrinBinOp::Op);
type getIntrinsicOp1Ty(IR::X86IntrinBinOp::Op);

std::vector<type> getIntegerVectorTypes(type);

} // namespace minotaur