// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once
#include "expr.h"
#include "llvm/IR/Function.h"

namespace minotaur {

struct ParseException {
  std::string str;
  unsigned lineno;

  ParseException(std::string &&str, unsigned lineno)
    : str(std::move(str)), lineno(lineno) {}
};

class Parser {
  std::vector<std::unique_ptr<minotaur::Inst>> exprs;
public:
  std::vector<Rewrite> parse(const llvm::Function&, std::string_view);
};



} // end namespace minotaur