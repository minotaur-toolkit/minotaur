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
  bool pointer;

public:
  type(unsigned l, unsigned b, bool p) : lane(l), bits(b), pointer(p) {};
  type(llvm::Type *t);
  type(const type &t)
  : lane(t.getLane()), bits(t.getBits()), pointer(t.isPointer()) {}

  bool isVector() const { return lane > 1; }

  bool isScalar() const { return lane == 1; }


  bool operator==(const type &rhs) const;
  bool same_width(const type &rhs) const;

  friend std::ostream& operator<<(std::ostream &os, const type &val);

  llvm::Type *toLLVM(llvm::LLVMContext &C);
  unsigned getWidth() const { return lane * bits; }
  unsigned getLane() const { return lane; }
  unsigned getBits() const  { return bits; }
  bool isPointer() const { return pointer; }

  type getStrippedType () {
    assert(pointer == true);
    return type(lane, bits, false);
  }

  static type getIntrinsicRetTy(IR::X86IntrinBinOp::Op);
  static type getIntrinsicOp0Ty(IR::X86IntrinBinOp::Op);
  static type getIntrinsicOp1Ty(IR::X86IntrinBinOp::Op);

  static std::vector<type> getBinaryInstWorkTypes(unsigned width) {
    std::vector<unsigned> bits = {64, 32, 16, 8};
    std::vector<type> types;
    if (width % 8 != 0) {
      types.push_back(type(1, width, false));
      return types;
    }

    for (unsigned i = 0 ; i < bits.size() ; ++ i) {
      if (width % bits[i] == 0) {
        types.push_back(type(width/bits[i], bits[i], false));
      }
    }
    return types;
  }
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

}