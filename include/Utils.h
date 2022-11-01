// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once
#include <unordered_set>
#include "llvm/IR/Function.h"

struct redisContext;

namespace minotaur {
void eliminate_dead_code(llvm::Function &F);

bool hGet(const char* s, unsigned sz, std::string &Value, redisContext *c);
void hSetRewrite(const char*, unsigned, const char *, unsigned, llvm::StringRef,
                 redisContext *c, unsigned, unsigned, llvm::StringRef);
void hSetNoSolution(const char*, unsigned, redisContext *c, llvm::StringRef);
void removeUnusedDecls(std::unordered_set<llvm::Function *>);
}