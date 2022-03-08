// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once
#include "IR.h"
#include "llvm/IR/Function.h"

namespace parse {

struct ParseException {
  std::string str;
  unsigned lineno;

  ParseException(std::string &&str, unsigned lineno)
    : str(std::move(str)), lineno(lineno) {}
};

minotaur::Inst* parse_rewrite(const llvm::Function &F, std::string rewrite);
minotaur::Inst* parse(std::string rewrite);

}