// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "ir/instr.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Type.h"

namespace minotaur {

class type {
  unsigned lane, bits;
  bool fp;

public:
  type(unsigned l, unsigned b, bool f) : lane(l), bits(b), fp(f) {};
  type() : lane(0), bits(0), fp(false) {};
  type(const type &t)
  : lane(t.getLane()), bits(t.getBits()), fp(t.isFP()) {}
  type(llvm::Type *t);

  bool isVector() const { return lane > 1; }
  bool isScalar() const { return lane == 1; }

  bool operator==(const type &rhs) const;
  bool same_width(const type &rhs) const;

  friend llvm::raw_ostream& operator<<(llvm::raw_ostream &os, const type &val);

  llvm::Type *toLLVM(llvm::LLVMContext&) const;

  unsigned getWidth() const { return lane * bits; }
  unsigned getLane() const { return lane; }
  unsigned getBits() const  { return bits; }
  bool isFP() const { return fp; }
  bool isValid() const { return lane != 0 && bits != 0; }
};

type getIntrinsicRetTy(IR::X86IntrinBinOp::Op);
type getIntrinsicOp0Ty(IR::X86IntrinBinOp::Op);
type getIntrinsicOp1Ty(IR::X86IntrinBinOp::Op);

std::vector<type> getIntegerVectorTypes(type);

} // namespace minotaur