// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "parse.h"
#include "expr.h"
#include "lexer.h"

#include "iostream"
#include "ir/instr.h"
#include "util/compiler.h"
#include "llvm/ADT/APInt.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Support/raw_ostream.h"
#include <string_view>

#define YYDEBUG 0

using namespace std;
using namespace minotaur;

namespace parse {

static void error(string &&s) {
  throw ParseException(std::move(s), yylineno);
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
      throw ParseException(std::move(e.str), e.lineno);
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
  /*
  tokenizer.ensure(BITS);
  unsigned width = yylval.num;
  tokenizer.ensure(REGISTER);
  string id(yylval.str);
  tokenizer.ensure(RPAREN);

  auto V = make_unique<Var>(id, type);
  Var *T = V.get();
  exprs.emplace_back(std::move(V));
  return T;
  */

  // TODO: fix me
  return nullptr;
}

unsigned parse_number() {
  tokenizer.ensure(BITS);
  return yylval.num;;
}

ReservedConst* parse_const(vector<unique_ptr<minotaur::Inst>>&exprs) {
  //fixme: parse const
  return nullptr;
  /*
  type t = parse_type();
  vector<llvm::APInt> values;

  if (t.isVector()) {
    tokenizer.ensure(LCURLY);
    for (unsigned i = 0 ; i < t.getLane() ; i ++) {
      tokenizer.ensure(NUM_STR);
      values.push_back(llvm::APInt(t.getBits(), yylval.str, 10));
      if (i != t.getLane() - 1)
        tokenizer.ensure(COMMA);
    }
    tokenizer.ensure(RCURLY);
  } else if (t.isScalar()) {
    tokenizer.ensure(NUM_STR);
    values.push_back(llvm::APInt(t.getBits(), yylval.str, 10));
  } else {
    UNREACHABLE();
  }
  tokenizer.ensure(RPAREN);
  auto RC = make_unique<ReservedConst>(t, values);
  ReservedConst *T = RC.get();
  exprs.emplace_back(move(RC));
  return T;
  */
}


Value* parse_copy(vector<unique_ptr<minotaur::Inst>>&exprs) {
  tokenizer.ensure(LPAREN);
  tokenizer.ensure(CONST);
  auto a = parse_const(exprs);
  tokenizer.ensure(RPAREN);

  auto CI = make_unique<Copy>(*a);
  Value *T = CI.get();
  exprs.emplace_back(std::move(CI));
  return T;
}

Value* parse_unary(token op_token, vector<unique_ptr<minotaur::Inst>>&exprs) {
  UnaryOp::Op op;
  switch (op_token) {
  case BITREVERSE:
    op = UnaryOp::bitreverse; break;
  case BSWAP:
    op = UnaryOp::bswap; break;
  case CTPOP:
    op = UnaryOp::ctpop; break;
  /*case CTLZ:
    op = UnaryOp::ctlz; break;
  case CTTZ:
    op = UnaryOp::cttz; break;*/
  // TODO: add
  default:
    UNREACHABLE();
  }
  auto workty = parse_vector_type();
  auto a = parse_expr(exprs);

  tokenizer.ensure(RPAREN);
  auto UI = make_unique<UnaryOp>(op, *a, workty);
  Value *T = UI.get();
  exprs.emplace_back(std::move(UI));
  return T;
}

Value* parse_binary(token op_token, vector<unique_ptr<minotaur::Inst>>&exprs) {
  BinaryOp::Op op;
  switch (op_token) {
  case BAND:
    op = BinaryOp::band; break;
  case BOR:
    op = BinaryOp::bor; break;
  case BXOR:
    op = BinaryOp::bxor; break;
  case ADD:
    op = BinaryOp::add; break;
  case SUB:
    op = BinaryOp::sub; break;
  case MUL:
    op = BinaryOp::mul; break;
  case SDIV:
    op = BinaryOp::sdiv; break;
  case UDIV:
    op = BinaryOp::udiv; break;
  case LSHR:
    op = BinaryOp::lshr; break;
  case ASHR:
    op = BinaryOp::ashr; break;
  case SHL:
    op = BinaryOp::shl; break;
  // TODO: add
  default:
    UNREACHABLE();
  }
  auto workty = parse_vector_type();
  auto a = parse_expr(exprs);
  auto b = parse_expr(exprs);

  tokenizer.ensure(RPAREN);
  auto BI = make_unique<BinaryOp>(op, *a, *b, workty);
  Value *T = BI.get();
  exprs.emplace_back(std::move(BI));
  return T;
}

Value* parse_icmp(token op_token, vector<unique_ptr<minotaur::Inst>>&exprs) {
  ICmp::Cond op;
  switch (op_token) {
  case EQ:
    op = ICmp::eq; break;
  case NE:
    op = ICmp::ne; break;
  case ULT:
    op = ICmp::ult; break;
  case ULE:
    op = ICmp::ule; break;
  case SLT:
    op = ICmp::slt; break;
  case SLE:
    op = ICmp::sle; break;
  // TODO: add
  default:
    UNREACHABLE();
  }
  auto a = parse_expr(exprs);
  auto b = parse_expr(exprs);

  unsigned width = parse_number();

  tokenizer.ensure(RPAREN);
  auto II = make_unique<ICmp>(op, *a, *b, width);
  Value *T = II.get();
  exprs.emplace_back(std::move(II));
  return T;
}

Value* parse_shuffle(token op_token, vector<unique_ptr<minotaur::Inst>>&exprs) {

  auto workty = parse_vector_type();
  auto lhs = parse_expr(exprs);
  auto rhs = op_token == BLEND ? parse_expr(exprs) : nullptr;
  tokenizer.ensure(LPAREN);
  tokenizer.ensure(CONST);
  auto mask = parse_const(exprs);
  auto SI = make_unique<FakeShuffleInst>(*lhs, rhs, *mask, workty);
  Value *T = SI.get();
  exprs.emplace_back(std::move(SI));
  return T;
}

Value* parse_conv(token op_token, vector<unique_ptr<minotaur::Inst>>&exprs) {
  ConversionOp::Op op;
  switch (op_token) {
  case CONV_ZEXT:
    op = ConversionOp::zext; break;
  case CONV_SEXT:
    op = ConversionOp::sext; break;
  case CONV_TRUNC:
    op = ConversionOp::trunc; break;
  default:
    UNREACHABLE();
  }
  auto a = parse_expr(exprs);
  auto from = parse_vector_type();
  auto to   = parse_vector_type();

  tokenizer.ensure(RPAREN);
  auto CI = make_unique<ConversionOp>(op, *a, from.getLane(), from.getBits(), to.getBits());
  Value *T = CI.get();
  exprs.emplace_back(std::move(CI));
  return T;
}


Value* parse_x86(string_view ops, vector<unique_ptr<minotaur::Inst>>&exprs) {
  IR::X86IntrinBinOp::Op op;
  #define PROCESS(NAME,A,B,C,D,E,F) if (ops == #NAME) op = IR::X86IntrinBinOp::NAME;
  #include "ir/intrinsics_binop.h"
  #undef PROCESS

  auto a = parse_expr(exprs);
  auto b = parse_expr(exprs);

  tokenizer.ensure(RPAREN);
  auto CI = make_unique<SIMDBinOpInst>(op, *a, *b);
  Value *T = CI.get();
  exprs.emplace_back(std::move(CI));
  return T;
}

Value* parse_expr(vector<unique_ptr<minotaur::Inst>>&exprs) {
  tokenizer.ensure(LPAREN);

  switch (auto t = *tokenizer) {
  case COPY:
    return parse_copy(exprs);
  case BITREVERSE:
  case BSWAP:
  case CTPOP:
  case CTLZ:
  case CTTZ:
    return parse_unary(t, exprs);
  case BAND:
  case BOR:
  case BXOR:
  case ADD:
  case SUB:
  case MUL:
  case SDIV:
  case UDIV:
  case LSHR:
  case ASHR:
  case SHL:
    return parse_binary(t, exprs);
  case EQ:
  case NE:
  case ULT:
  case ULE:
  case SLT:
  case SLE:
    return parse_icmp(t, exprs);
  case SHUFFLE:
  case BLEND:
    return parse_shuffle(t, exprs);
  case CONV_ZEXT:
  case CONV_SEXT:
  case CONV_TRUNC:
    return parse_conv(t, exprs);
  case X86BINARY:
    return parse_x86(yylval.str, exprs);
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