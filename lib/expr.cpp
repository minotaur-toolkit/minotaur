// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "expr.h"
#include "ir/instr.h"
#include "type.h"
#include "util/compiler.h"

#include "llvm/IR/Constants.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"

#include <algorithm>
#include <string>
#include <iostream>

using namespace std;
using namespace llvm;

namespace minotaur {

raw_ostream& operator<<(raw_ostream &os, const Inst &val) {
  val.print(os);
  return os;
}

void Var::print(raw_ostream &os) const {
  os << "(var " << ty << " " << name <<")";
}

void ReservedConst::print(raw_ostream &os) const {
// TODO : print literals
  //  if (!Values.empty()) {
  //   string str;
  //   if (ty.isScalar()) {
  //     llvm::raw_string_ostream ss(str);
  //     auto V = Values[0];
  //     ss<<"i"<<V.getBitWidth()<<" ";
  //     V.print(ss, false);
  //     ss.flush();
  //   } else if (ty.isVector()) {
  //     llvm::raw_string_ostream ss(str);
  //     ss<<"<"<<ty.getLane()<<" x i"<<ty.getBits()<<"> ";

  //     ss<<"{";
  //     for (unsigned i = 0 ; i < ty.getLane(); i ++) {
  //       Values[i].print(ss, false);
  //       if (i != ty.getLane() - 1)
  //         ss<<",";
  //     }
  //     ss<<"}";
  //     ss.flush();
  //   }
  //   os << "(const " << str << ")";
  // } else {
     os << "reservedconst";
  // }
}

void Copy::print(raw_ostream &os) const {
  os << "(copy ";
  rc->print(os);
  os << ")";
}

void UnaryOp::print(raw_ostream &os) const {
  const char *str = nullptr;
  switch (op) {
  case bitreverse: str = "bitreverse"; break;
  case bswap:      str = "bswap";      break;
  case ctpop:      str = "ctpop";      break;
  case ctlz:       str = "ctlz";       break;
  case cttz:       str = "cttz";       break;
  }
  os << "(" << str << " " << workty << " ";
  v->print(os);
  os << ")";
}

void BinaryOp::print(raw_ostream &os) const {
  const char *str = nullptr;
  switch (op) {
  case band:       str = "and";  break;
  case bor:        str = "or";   break;
  case bxor:       str = "xor";  break;
  case add:        str = "add";  break;
  case sub:        str = "sub";  break;
  case mul:        str = "mul";  break;
  case sdiv:       str = "sdiv"; break;
  case udiv:       str = "udiv"; break;
  case lshr:       str = "lshr"; break;
  case ashr:       str = "ashr"; break;
  case shl:        str = "shl" ; break;
  case fadd:       str = "fadd"; break;
  case fmul:       str = "fmul"; break;
  case fsub:       str = "fsub"; break;
  case fdiv:       str = "fdiv"; break;
  case frem:       str = "frem"; break;
  }
  os << "(" << str << " " << workty << " ";
  lhs->print(os);
  os << " ";
  rhs->print(os);
  os << ")";
}

void ICmp::print(raw_ostream &os) const {
  const char *str = nullptr;
  switch (cond) {
  case eq:       str = "eq";  break;
  case ne:       str = "ne";  break;
  case ult:      str = "ult"; break;
  case ule:      str = "ule"; break;
  case slt:      str = "slt"; break;
  case sle:      str = "sle"; break;
  }
  os << "(icmp_" << str << " ";
  lhs->print(os);
  os << " ";
  rhs->print(os);
  os << " b" << ty.getWidth();
  //rhs->print(os);
  os << ")";
}

void FCmp::print(raw_ostream &os) const {
  const char *str = nullptr;
  switch (cond) {
  case f:   str = "false"; break;
  case oeq:      str = "oeq"; break;
  case ogt:      str = "ogt"; break;
  case oge:      str = "oge"; break;
  case olt:      str = "olt"; break;
  case ole:      str = "ole"; break;
  case one:      str = "one"; break;
  case ord:      str = "ord"; break;
  case ueq:      str = "ueq"; break;
  case ugt:      str = "ugt"; break;
  case uge:      str = "uge"; break;
  case ult:      str = "ult"; break;
  case ule:      str = "ule"; break;
  case une:      str = "une"; break;
  case uno:      str = "uno"; break;
  case t:        str = "true"; break;
  }
  os << "(fcmp_" << str << " ";
  lhs->print(os);
  os << " ";
  rhs->print(os);
  os << " b" << ty.getWidth();
  //rhs->print(os);
  os << ")";
}

void SIMDBinOpInst::print(raw_ostream &os) const {
  os << "(" << IR::X86IntrinBinOp::getOpName(op) << " ";
  lhs->print(os);
  os << " ";
  rhs->print(os);
  os << ")";
}

void FakeShuffleInst::print(raw_ostream &os) const {
  if (rhs)
    os << "(blend ";
  else
    os << "(shuffle ";

  os << expectty << " ";
  lhs->print(os);
  os << " ";
  if (rhs) {
    rhs->print(os);
    os << " ";
  }
  mask->print(os);
  os << ")";
}

type FakeShuffleInst::getRetTy() {
  return expectty;
}

type FakeShuffleInst::getInputTy() {
  type lhs_ty = lhs->getType();
  unsigned lane = lhs_ty.getWidth()/getElementBits();
  return type(lane, getElementBits(), lhs_ty.isFP());
}


void ConversionOp::print(raw_ostream &os) const {
  const char *str = nullptr;
  switch (k) {
  case sext:  str = "sext"; break;
  case zext:  str = "zext"; break;
  case trunc: str = "trunc"; break;
  }

  os << "(conv_"<< str << " ";
  v->print(os);
  os << " " << getPrevTy();
  os << " " << getNewTy();
  os << ")";
}

vector<type> getUnaryOpWorkTypes(type ty, UnaryOp::Op op) {
  if (ty.isFP()) {
    return {};
  } else {
    return getIntegerVectorTypes(ty.getWidth());
  }
}

vector<type> getBinaryOpWorkTypes(type ty, BinaryOp::Op op) {
  if (ty.isFP()) {
    return {};
  }

  if (BinaryOp::isFloatingPoint(op)) {
    return {};
  }

  if (BinaryOp::isLaneIndependent(op)) {
    return {ty};
  } else {
    return getIntegerVectorTypes(ty.getWidth());
  }
}

vector<type> getShuffleWorkTypes(type ty) {
  if (ty.isFP()) {
    return {ty};
  } else {
    return getIntegerVectorTypes(ty.getWidth());
  }
}

vector<type> getConversionOpWorkTypes(type to, type from) {
  vector<type> tys = getIntegerVectorTypes(to.getWidth());
  return tys;
}

}
