// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "Parse.h"
#include "IR.h"
#include "Lexer.h"

#include "iostream"
#include "util/compiler.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/ErrorHandling.h"

#define YYDEBUG 0

using namespace std;
using namespace minotaur;

namespace parse {

static void error(string &&s) {
  throw ParseException(move(s), yylineno);
}

struct tokenizer_t {
  token last;
  // true if token last was 'unget' and should be returned next
  bool returned = false;

  token operator*() {
    if (returned) {
      returned = false;
      return last;
    }
    return get_new_token();
  }

  token peek() {
    if (returned)
      return last;
    returned = true;
    return last = get_new_token();
  }

  bool consumeIf(token expected) {
    auto token = peek();
    if (token == expected) {
      returned = false;
      return true;
    }
    return false;
  }

  void ensure(token expected) {
    auto t = **this;
    if (t != expected)
      error(string("expected token: ") + token_name[expected] + ", got: " +
            token_name[t]);
  }

  void unget(token t) {
    assert(returned == false);
    returned = true;
    last = t;
  }

  bool empty() {
    return peek() == END;
  }

  bool isType() {
    return isScalarType() || isVectorType();
  }

  bool isScalarType() {
    return peek() == INT_TYPE;
  }

  bool isVectorType() {
    return peek() == VECTOR_TYPE_PREFIX;
  }

private:
  token get_new_token() const {
    try {
      auto t = yylex();
#if YYDEBUG
      cout << "token: " << token_name[t] << '\n';
#endif
      return t;
    } catch (LexException &e) {
      throw ParseException(move(e.str), e.lineno);
    }
  }
};

static tokenizer_t tokenizer;

Inst* parse_expr(vector<unique_ptr<minotaur::Inst>>&);

Var* parse_var(vector<unique_ptr<minotaur::Inst>>&exprs) {
  tokenizer.ensure(NUM);
  unsigned width = yylval.num;
  tokenizer.ensure(REGISTER);
  string id(yylval.str);
  tokenizer.ensure(RPAREN);
  auto V = make_unique<Var>(id, width);
  Var *T = V.get();
  exprs.emplace_back(move(V));
  return T;
}

type parse_type() {
  return type(8, 8, false);
}


Inst* parse_binop(token op_token, vector<unique_ptr<minotaur::Inst>>&exprs) {
  BinaryInst::Op op;
  switch (op_token) {
  case BAND:
    op = BinaryInst::band; break;
  case BOR:
    op = BinaryInst::bor; break;
  case BXOR:
    op = BinaryInst::bxor; break;
  case ADD:
    op = BinaryInst::add; break;
  case SUB:
    op = BinaryInst::sub; break;
  case MUL:
    op = BinaryInst::mul; break;
  // TODO: add
  default:
    UNREACHABLE();
  }
  auto workty = parse_type();
  auto a = parse_expr(exprs);
  auto b = parse_expr(exprs);

  tokenizer.ensure(RPAREN);
  auto BI = make_unique<BinaryInst>(op, *a, *b, workty);
  Inst *T = BI.get();
  exprs.emplace_back(move(BI));
  return T;
}

Inst* parse_expr(vector<unique_ptr<minotaur::Inst>>&exprs) {
  tokenizer.ensure(LPAREN);

  switch (auto t = *tokenizer) {
  case ADD:
  case SUB:
    return parse_binop(t, exprs);
  case VAR:
    return parse_var(exprs);
  default:
    UNREACHABLE();
  }
}

minotaur::Inst* parse_rewrite(const llvm::Function &F, std::string rewrite) {
  return nullptr;
}



minotaur::Inst* parse(string_view buf, vector<unique_ptr<minotaur::Inst>>&exprs) {
  yylex_init(buf);
  if (tokenizer.empty())
    llvm::report_fatal_error("cannot parse empty string");

  return parse_expr(exprs);
}

}