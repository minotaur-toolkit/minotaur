// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "llvm/IR/DerivedTypes.h"
#include "llvm/Support/ErrorHandling.h"
#include <Type.h>

using namespace std;
using namespace llvm;

namespace minotaur {

Type* getLLVMType(type t, llvm::LLVMContext &C) {
    if (t.lane == -1 || t.bits == -1)
        report_fatal_error("error minotaur type");
    if (t.lane == 1) {
        return Type::getIntNTy(C, t.bits);
    } else {
        return FixedVectorType::get(Type::getIntNTy(C, t.bits), t.lane);
    }
}

}