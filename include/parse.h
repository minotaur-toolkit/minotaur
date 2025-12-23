// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once
#include "expr.h"
#include "lexer.h"
#include "llvm/IR/Function.h"

namespace parse {

struct ParseException {
  std::string str;
  unsigned lineno;

  ParseException(std::string &&str, unsigned lineno)
    : str(std::move(str)), lineno(lineno) {}
};

class Parser {
  std::vector<std::unique_ptr<minotaur::Inst>> exprs;
  llvm::Function &F;

  minotaur::Var             *parse_var();
  minotaur::ReservedConst   *parse_const();
  minotaur::Copy            *parse_copy();
  minotaur::UnaryOp         *parse_unary(token);
  minotaur::BinaryOp        *parse_binary(token);
  minotaur::ICmp            *parse_icmp(token);
  minotaur::FCmp            *parse_fcmp(token);
  minotaur::FakeShuffleInst *parse_shuffle(token);
  minotaur::IntConversion   *parse_intconv(token);
  minotaur::FPConversion    *parse_fpconv(token);
  minotaur::SIMDBinOpInst   *parse_x86(std::string_view ops);
  minotaur::Select          *parse_select();
  minotaur::InsertElement   *parse_insertelement();
  minotaur::ExtractElement  *parse_extractelement();
  minotaur::Value* parse_expr();

public:
  Parser(llvm::Function &F) : F(F) {}
  std::vector<minotaur::Rewrite> parse(const llvm::Function&, std::string_view);
};



} // end namespace minotaur