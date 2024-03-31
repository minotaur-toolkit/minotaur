// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "parse.h"
#include "expr.h"
#include "config.h"
#include "lexer.h"

#include "iostream"
#include "ir/instr.h"
#include "util/compiler.h"
#include "llvm/ADT/APInt.h"
#include "llvm/AsmParser/Parser.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/ValueSymbolTable.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include <string_view>

#define YYDEBUG 0

using namespace std;
using namespace minotaur;

struct debug {
  template<class T>
  debug &operator<<(const T &s)
  {
    if (minotaur::config::debug_parser)
      minotaur::config::dbg()<<s;
    return *this;
  }
};


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
    return peek() == INT_TYPE ||
           peek() == FLOAT || peek() == DOUBLE ||
           peek() == HALF || peek() == FP128;
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

static type parse_scalar_type() {
  switch (tokenizer.peek()) {
  case FLOAT:
    tokenizer.ensure(FLOAT);
    return type::Float();
  case DOUBLE:
    tokenizer.ensure(DOUBLE);
    return type::Double();
  case HALF:
    tokenizer.ensure(HALF);
    return type::Half();
  case FP128:
    tokenizer.ensure(FP128);
    return type::FP128();
  case INT_TYPE:
    tokenizer.ensure(INT_TYPE);
    return type::Scalar(yylval.num, false);
  default:
    UNREACHABLE();
  }
}

static type parse_vector_type() {
  tokenizer.ensure(VECTOR_TYPE_PREFIX);
  unsigned lane = yylval.num;
  auto type = parse_scalar_type();
  tokenizer.ensure(CSGT);
  return type.getAsVector(lane);
}

static type parse_type() {
  if (tokenizer.isScalarType())
    return parse_scalar_type();
  else if (tokenizer.isVectorType())
    return parse_vector_type();
  UNREACHABLE();
}

Var *Parser::parse_var() {
  type ty = parse_type();
  tokenizer.ensure(REGISTER);
  string id(yylval.str);
  id.erase(id.begin());
  tokenizer.ensure(RPAREN);

  llvm::Value *LV = F.getValueSymbolTable()->lookup(id);
  if (!LV) {
    debug()<<"[parser] value not found: "<<id<<"\n";
    llvm::report_fatal_error("[parser] terminating");
  }
  auto V = make_unique<Var>(LV);
  Var *T = V.get();
  exprs.emplace_back(std::move(V));
  return T;
}

unsigned parse_number() {
  tokenizer.ensure(BITS);
  return yylval.num;;
}

ReservedConst* Parser::parse_const() {
  type t = parse_type();

  tokenizer.ensure(LITERAL);
  string lt(yylval.str);
  lt.pop_back();
  lt.erase(lt.begin());

  debug() << "literal: " << lt << '\n';

  tokenizer.ensure(RPAREN);
  llvm::SMDiagnostic diag;
  llvm::Constant *C = llvm::parseConstantValue(lt, diag, *F.getParent());
  auto T = make_unique<ReservedConst>(t, C);
  ReservedConst *RC = T.get();
  exprs.emplace_back(std::move(T));

  return RC;
}


Copy* Parser::parse_copy() {
  tokenizer.ensure(LPAREN);
  tokenizer.ensure(CONST);
  auto a = parse_const();
  tokenizer.ensure(RPAREN);

  auto CI = make_unique<Copy>(*a);
  Copy *T = CI.get();
  exprs.emplace_back(std::move(CI));
  return T;
}

UnaryOp* Parser::parse_unary(token op_token) {
  UnaryOp::Op op;
  switch (op_token) {
  case BITREVERSE:
    op = UnaryOp::bitreverse; break;
  case BSWAP:
    op = UnaryOp::bswap; break;
  case CTPOP:
    op = UnaryOp::ctpop; break;
  case CTLZ:
    op = UnaryOp::ctlz; break;
  case CTTZ:
    op = UnaryOp::cttz; break;
  case FNEG:
    op = UnaryOp::fneg; break;
  case FABS:
    op = UnaryOp::fabs; break;
  case FCEIL:
    op = UnaryOp::fceil; break;
  case FFLOOR:
    op = UnaryOp::ffloor; break;
  case FRINT:
    op = UnaryOp::frint; break;
  case FNEARBYINT:
    op = UnaryOp::fnearbyint; break;
  case FROUND:
    op = UnaryOp::fround; break;
  case FROUNDEVEN:
    op = UnaryOp::froundeven; break;
  case FTRUNC:
    op = UnaryOp::ftrunc; break;
  // TODO: add
  default:
    UNREACHABLE();
  }
  type workty = parse_type();
  auto a = parse_expr();

  tokenizer.ensure(RPAREN);
  auto UI = make_unique<UnaryOp>(op, *a, workty);
  UnaryOp *T = UI.get();
  exprs.emplace_back(std::move(UI));
  return T;
}

BinaryOp *Parser::parse_binary(token op_token) {
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
  case SMAX:
    op = BinaryOp::smax; break;
  case SMIN:
    op = BinaryOp::smin; break;
  case UMAX:
    op = BinaryOp::umax; break;
  case UMIN:
    op = BinaryOp::umin; break;
  case FADD:
    op = BinaryOp::fadd; break;
  case FSUB:
    op = BinaryOp::fsub; break;
  case FMUL:
    op = BinaryOp::fmul; break;
  case FDIV:
    op = BinaryOp::fdiv; break;
  case FMAXNUM:
    op = BinaryOp::fmaxnum; break;
  case FMINNUM:
    op = BinaryOp::fminnum; break;
  case FMAXIMUM:
    op = BinaryOp::fmaximum; break;
  case FMINIMUM:
    op = BinaryOp::fminimum; break;
  case COPYSIGN:
    op = BinaryOp::copysign; break;
  // TODO: add
  default:
    UNREACHABLE();
  }
  auto workty = parse_type();
  auto a = parse_expr();
  auto b = parse_expr();

  tokenizer.ensure(RPAREN);
  auto BI = make_unique<BinaryOp>(op, *a, *b, workty);
  BinaryOp *T = BI.get();
  exprs.emplace_back(std::move(BI));
  return T;
}

ICmp *Parser::parse_icmp(token op_token) {
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
  case UGT:
    op = ICmp::ugt; break;
  case UGE:
    op = ICmp::uge; break;
  case SLT:
    op = ICmp::slt; break;
  case SLE:
    op = ICmp::sle; break;
  case SGT:
    op = ICmp::sgt; break;
  case SGE:
    op = ICmp::sge; break;
  default:
    UNREACHABLE();
  }
  auto a = parse_expr();
  auto b = parse_expr();

  unsigned width = parse_number();

  tokenizer.ensure(RPAREN);
  auto II = make_unique<ICmp>(op, *a, *b, width);
  ICmp *T = II.get();
  exprs.emplace_back(std::move(II));
  return T;
}

FCmp *Parser::parse_fcmp(token op_token) {
  FCmp::Cond op;
  switch (op_token) {
  case FCMP_TRUE:
    op = FCmp::t; break;
  case FCMP_OEQ:
    op = FCmp::oeq; break;
  case FCMP_OGT:
    op = FCmp::ogt; break;
  case FCMP_OGE:
    op = FCmp::oge; break;
  case FCMP_OLT:
    op = FCmp::olt; break;
  case FCMP_OLE:
    op = FCmp::ole; break;
  case FCMP_ONE:
    op = FCmp::one; break;
  case FCMP_ORD:
    op = FCmp::ord; break;
  case FCMP_UEQ:
    op = FCmp::ueq; break;
  case FCMP_UGT:
    op = FCmp::ugt; break;
  case FCMP_UGE:
    op = FCmp::uge; break;
  case FCMP_ULT:
    op = FCmp::ult; break;
  case FCMP_ULE:
    op = FCmp::ule; break;
  case FCMP_UNE:
    op = FCmp::une; break;
  case FCMP_UNO:
    op = FCmp::uno; break;
  case FCMP_FALSE:
    op = FCmp::f; break;
  default:
    UNREACHABLE();
  }
  auto a = parse_expr();
  auto b = parse_expr();

  unsigned width = parse_number();

  tokenizer.ensure(RPAREN);
  auto FI = make_unique<FCmp>(op, *a, *b, width);
  FCmp *T = FI.get();
  exprs.emplace_back(std::move(FI));
  return T;
}

FakeShuffleInst *Parser::parse_shuffle(token op_token) {
  auto workty = parse_vector_type();
  auto lhs = parse_expr();
  auto rhs = op_token == BLEND ? parse_expr() : nullptr;
  tokenizer.ensure(LPAREN);
  tokenizer.ensure(CONST);
  auto mask = parse_const();
  auto SI = make_unique<FakeShuffleInst>(*lhs, rhs, *mask, workty);
  FakeShuffleInst *T = SI.get();
  exprs.emplace_back(std::move(SI));
  return T;
}

IntConversion *Parser::parse_intconv(token op_token) {
  IntConversion::Op op;
  switch (op_token) {
  case CONV_ZEXT:
    op = IntConversion::zext; break;
  case CONV_SEXT:
    op = IntConversion::sext; break;
  case CONV_TRUNC:
    op = IntConversion::trunc; break;
  default:
    UNREACHABLE();
  }
  auto a = parse_expr();
  auto from = parse_type();
  auto to   = parse_type();

  tokenizer.ensure(RPAREN);
  auto CI = make_unique<IntConversion>(op, *a, from.getLane(), from.getBits(), to.getBits());
  IntConversion *T = CI.get();
  exprs.emplace_back(std::move(CI));
  return T;
}

FPConversion *Parser::parse_fpconv(token op_token) {
  FPConversion::Op op;
  switch (op_token) {
  case CONV_FPEXT:
    op = FPConversion::fpext; break;
  case CONV_FPTRUNC:
    op = FPConversion::fptrunc; break;
  case CONV_SITOFP:
    op = FPConversion::sitofp; break;
  case CONV_UITOFP:
    op = FPConversion::uitofp; break;
  case CONV_FPTOSI:
    op = FPConversion::fptosi; break;
  case CONV_FPTOUI:
    op = FPConversion::fptoui; break;
  default:
    UNREACHABLE();
  }
  auto a = parse_expr();
  auto ty = parse_type();

  tokenizer.ensure(RPAREN);
  auto CI = make_unique<FPConversion>(op, *a, ty);
  FPConversion *T = CI.get();
  exprs.emplace_back(std::move(CI));
  return T;
}

SIMDBinOpInst *Parser::parse_x86(string_view ops) {
  IR::X86IntrinBinOp::Op op;
  #define PROCESS(NAME,A,B,C,D,E,F) if (ops == #NAME) op = IR::X86IntrinBinOp::NAME;
  #include "ir/intrinsics_binop.h"
  #undef PROCESS

  auto a = parse_expr();
  auto b = parse_expr();

  tokenizer.ensure(RPAREN);
  auto CI = make_unique<SIMDBinOpInst>(op, *a, *b);
  SIMDBinOpInst *T = CI.get();
  exprs.emplace_back(std::move(CI));
  return T;
}

Select *Parser::parse_select() {
  auto cond = parse_expr();
  auto a = parse_expr();
  auto b = parse_expr();

  tokenizer.ensure(RPAREN);
  auto SI = make_unique<Select>(*cond, *a, *b);
  Select *T = SI.get();
  exprs.emplace_back(std::move(SI));
  return T;
}

InsertElement *Parser::parse_insertelement() {
  type elem_ty = parse_type();
  auto vec = parse_expr();
  auto elem = parse_expr();
  tokenizer.ensure(LPAREN);
  tokenizer.ensure(CONST);
  auto idx = parse_const();

  tokenizer.ensure(RPAREN);
  auto II = make_unique<InsertElement>(*vec, *elem, *idx, elem_ty);
  InsertElement *T = II.get();
  exprs.emplace_back(std::move(II));
  return T;
}

ExtractElement *Parser::parse_extractelement() {
  type elem_ty = parse_type();
  auto vec = parse_expr();
  tokenizer.ensure(LPAREN);
  tokenizer.ensure(CONST);
  auto idx = parse_const();

  tokenizer.ensure(RPAREN);
  auto EI = make_unique<ExtractElement>(*vec, *idx, elem_ty);
  ExtractElement *T = EI.get();
  exprs.emplace_back(std::move(EI));
  return T;
}

Value* Parser::parse_expr() {
  tokenizer.ensure(LPAREN);

  switch (auto t = *tokenizer) {
  case COPY:
    return parse_copy();
  case BITREVERSE:
  case BSWAP:
  case CTPOP:
  case CTLZ:
  case CTTZ:
  case FNEG:
  case FABS:
  case FCEIL:
  case FFLOOR:
  case FRINT:
  case FNEARBYINT:
  case FROUND:
  case FROUNDEVEN:
  case FTRUNC:
    return parse_unary(t);
  case BAND:
  case BOR:
  case BXOR:
  case LSHR:
  case ASHR:
  case SHL:
  case ADD:
  case SUB:
  case MUL:
  case SDIV:
  case UDIV:
  case UMAX:
  case UMIN:
  case SMAX:
  case SMIN:
  case FADD:
  case FSUB:
  case FMUL:
  case FDIV:
  case FMAXNUM:
  case FMINNUM:
  case FMAXIMUM:
  case FMINIMUM:
  case COPYSIGN:
    return parse_binary(t);
  case EQ:
  case NE:
  case ULT:
  case ULE:
  case UGT:
  case UGE:
  case SLT:
  case SLE:
  case SGT:
  case SGE:
    return parse_icmp(t);
  case FCMP_TRUE:
  case FCMP_OEQ:
  case FCMP_OGT:
  case FCMP_OGE:
  case FCMP_OLT:
  case FCMP_OLE:
  case FCMP_ONE:
  case FCMP_ORD:
  case FCMP_UEQ:
  case FCMP_UGT:
  case FCMP_UGE:
  case FCMP_ULT:
  case FCMP_ULE:
  case FCMP_UNE:
  case FCMP_UNO:
  case FCMP_FALSE:
    return parse_fcmp(t);
  case SHUFFLE:
  case BLEND:
    return parse_shuffle(t);
  case SELECT:
    return parse_select();
  case INSERTELEMENT:
    return parse_insertelement();
  case EXTRACTELEMENT:
    return parse_extractelement();
  case CONV_ZEXT:
  case CONV_SEXT:
  case CONV_TRUNC:
    return parse_intconv(t);
  case CONV_FPTRUNC:
  case CONV_FPEXT:
  case CONV_SITOFP:
  case CONV_UITOFP:
  case CONV_FPTOSI:
  case CONV_FPTOUI:
    return parse_fpconv(t);

  case X86BINARY:
    return parse_x86(yylval.str);
  case VAR:
    return parse_var();
  case CONST:
    return parse_const();

  default:
    UNREACHABLE();
  }
}

vector<Rewrite> Parser::parse(const llvm::Function &F, std::string_view buf) {
  debug() << "[parser] parsing: " << buf << '\n';

  parse::yylex_init(buf);
  if (parse::tokenizer.empty())
    debug()<<"[parser] cannot parse empty string\n";

  try {
    Inst *I = parse_expr();
    return { Rewrite(I, 0, 0) };
  } catch (ParseException &e) {
    debug()<<"[parser] " << e.str << '\n';
    exit(1);
    //return {};
  }
}

}