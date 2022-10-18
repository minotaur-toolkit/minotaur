// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "Parse.h"
#include "Expr.h"
#include "Lexer.h"

#include "iostream"
#include "util/compiler.h"
#include "llvm/ADT/APInt.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Support/raw_ostream.h"

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

static Value* parse_expr(vector<unique_ptr<minotaur::Inst>>&);

static type parse_vector_type() {
  tokenizer.ensure(VECTOR_TYPE_PREFIX);
  unsigned elements = yylval.num;

  tokenizer.ensure(INT_TYPE);
  unsigned bits = yylval.num;
  tokenizer.ensure(CSGT);
  return type(elements, bits, false);
}

static type parse_scalar_type() {
  tokenizer.ensure(INT_TYPE);
  unsigned bits = yylval.num;
  return type(1, bits, false);
}

static type parse_type() {
  if (tokenizer.isScalarType())
    return parse_scalar_type();
  else if (tokenizer.isVectorType())
    return parse_vector_type();
  UNREACHABLE();
}

static Var* parse_var(vector<unique_ptr<minotaur::Inst>>&exprs) {
  tokenizer.ensure(BITS);
  unsigned width = yylval.num;
  tokenizer.ensure(REGISTER);
  string id(yylval.str);
  tokenizer.ensure(RPAREN);
  auto V = make_unique<Var>(id, width);
  Var *T = V.get();
  exprs.emplace_back(move(V));
  return T;
}

ReservedConst* parse_const(vector<unique_ptr<minotaur::Inst>>&exprs) {
  type t = parse_type();
  vector<llvm::APInt> values;

  ReservedConst *RC = nullptr;
  if (t.isVector()) {
    tokenizer.ensure(LCURLY);
    for (unsigned i = 0 ; i < t.getLane() ; i ++) {
      tokenizer.ensure(NUM_STR);
      string_view st = yylval.str;
      llvm::APInt(t.getBits(), st, 10).dump();
      values.push_back(llvm::APInt(t.getBits(),st, 10));
      if (i != t.getLane() - 1)
        tokenizer.ensure(COMMA);
    }
    tokenizer.ensure(RCURLY);
  } else {
    tokenizer.ensure(NUM_STR);
    string_view st = yylval.str;
    llvm::APInt(t.getBits(), st, 10).dump();
    values.push_back(llvm::APInt(t.getBits(),st, 10));
  }
  tokenizer.ensure(RPAREN);
  auto T = make_unique<ReservedConst>(t, values);
  RC = T.get();
  exprs.emplace_back(move(T));
  return RC;
}


Value* parse_binop(token op_token, vector<unique_ptr<minotaur::Inst>>&exprs) {
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
  auto workty = parse_vector_type();
  auto a = parse_expr(exprs);
  auto b = parse_expr(exprs);

  tokenizer.ensure(RPAREN);
  auto BI = make_unique<BinaryInst>(op, *a, *b, workty);
  Value *T = BI.get();
  exprs.emplace_back(move(BI));
  return T;
}

Value* parse_expr(vector<unique_ptr<minotaur::Inst>>&exprs) {
  tokenizer.ensure(LPAREN);

  switch (auto t = *tokenizer) {
  case BAND:
  case BOR:
  case BXOR:
  case ADD:
  case SUB:
  case MUL:
    return parse_binop(t, exprs);
  case VAR:
    return parse_var(exprs);
  case CONST:
    return parse_const(exprs);
  default:
    UNREACHABLE();
  }
}

void match_vars(llvm::Function &F, vector<unique_ptr<minotaur::Inst>>&exprs) {
  unordered_map<std::string, llvm::Value*> name_map;
  for (llvm::inst_iterator I = llvm::inst_begin(F), E = inst_end(F); I != E; ++I) {
    if (I->getType()->isVoidTy())
      continue;
    string name;
    llvm::raw_string_ostream ss(name);
    I->printAsOperand(ss, false);
    ss.flush();
    if (name_map.contains(name)) {
      llvm::report_fatal_error("why there's duplicated names");
    }
    name_map[name] = &*I;
  }
  for (unsigned i = 0 ; i < F.arg_size() ; ++i) {
    llvm::Argument *arg = F.getArg(i);
    string name;
    llvm::raw_string_ostream ss(name);
    arg->printAsOperand(ss, false);
    ss.flush();
    if (name_map.contains(name)) {
      llvm::report_fatal_error("why there's duplicated names");
    }
    name_map[name] = arg;
  }
  for (auto &expr : exprs) {
    auto E = expr.get();
    if (Var *V = dynamic_cast<Var*>(E)) {
      if (!name_map.contains(V->getName()))
        llvm::report_fatal_error("value not found");
      else
        V->setValue(name_map.at(V->getName()));
    }
  }
}

minotaur::Inst* parse(string_view buf, vector<unique_ptr<minotaur::Inst>>&exprs) {
  yylex_init(buf);
  if (tokenizer.empty())
    llvm::report_fatal_error("cannot parse empty string");

  return parse_expr(exprs);
}

}