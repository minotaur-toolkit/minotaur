// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"

namespace minotaur {

struct type {
  unsigned lane, bits;
  type(unsigned l, unsigned b) : lane(l), bits(b) {};

  bool isVector() {
    return lane != 1;
  }
  bool operator==(const type &rhs) const {
    return lane == rhs.lane && bits == rhs.bits;
  }

  type(llvm::Type *t) {
    if (t->isIntegerTy()) {
      lane = 1;
      bits = t->getPrimitiveSizeInBits();
    } else if (t->isVectorTy()) {
      if (llvm::isa<llvm::ScalableVectorType>(t))
        llvm::report_fatal_error("scalable vector type not yet supported");
      llvm::FixedVectorType *fty = cast<llvm::FixedVectorType>(t);
      lane = fty->getNumElements(),
      bits = t->getPrimitiveSizeInBits();
    } else {
      llvm::report_fatal_error("unrecognized type");
    }
  }
};

llvm::Type* getLLVMType (type t, llvm::LLVMContext &C);
}