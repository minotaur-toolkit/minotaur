// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once
#include "llvm/IR/Function.h"

struct redisContext;

namespace minotaur {
void eliminate_dead_code(llvm::Function &F);

bool hGet(const char* s, unsigned sz, std::string &Value, redisContext *c);
void hSet(const char* s, unsigned sz, llvm::StringRef Value,
          redisContext *c, unsigned, unsigned, llvm::StringRef);
}