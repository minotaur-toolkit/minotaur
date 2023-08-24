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
  type(const type &t)
  : lane(t.getLane()), bits(t.getBits()), fp(t.isFP()) {}
  type(llvm::Type *t);

  bool isVector() const { return lane > 1; }
  bool isScalar() const { return lane == 1; }

  bool operator==(const type &rhs) const;
  bool same_width(const type &rhs) const;

  friend std::ostream& operator<<(std::ostream &os, const type &val);

  llvm::Type *toLLVM(llvm::LLVMContext &C) const;
  unsigned getWidth() const { return lane * bits; }
  unsigned getLane() const { return lane; }
  unsigned getBits() const  { return bits; }
  bool isFP() const { return fp; }

  static std::vector<type> getVectorTypes(unsigned width) {
    std::vector<unsigned> bits = {64, 32, 16, 8};
    std::vector<type> types;

    for (unsigned i = 0 ; i < bits.size() ; ++ i) {
      if (width % bits[i] == 0 && width > bits[i]) {
        types.push_back(type(width/bits[i], bits[i], false));
      }
    }
    return types;
  }
};

type getIntrinsicRetTy(IR::X86IntrinBinOp::Op);
type getIntrinsicOp0Ty(IR::X86IntrinBinOp::Op);
type getIntrinsicOp1Ty(IR::X86IntrinBinOp::Op);

std::vector<type> getBinaryInstWorkTypes(unsigned width);

}