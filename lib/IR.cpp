// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "IR.h"
#include "ir/instr.h"

#include <string>

using namespace std;

namespace minotaur {

ostream& operator<<(ostream &os, const Inst &val) {
  val.print(os);
  return os;
}

void Var::print(ostream &os) const {
  os << "%" << string(v->getName());
}

void ReservedConst::print(ostream &os) const {
  const char *str = "reservedconst";
  os << str;
}

void UnaryInst::print(ostream &os) const {
  const char *str = nullptr;
  switch (op) {
  case copy:       str = "copy"; break;
  }
  os << "(" << str << " ";
  op0->print(os);
  os << ")";
}

void BinaryInst::print(ostream &os) const {
  const char *str = nullptr;
  switch (op) {
  case band:       str = "and"; break;
  case bor:        str = "or";  break;
  case bxor:       str = "xor"; break;
  case add:        str = "add"; break;
  case sub:        str = "sub"; break;
  case mul:        str = "mul"; break;
  case sdiv:       str = "sdiv";break;
  case udiv:       str = "udiv";break;
  case lshr:       str = "lshr";break;
  case ashr:       str = "ashr";break;
  case shl:        str = "shl" ;break;
  }
  os << "(" << str << " ";
  lhs->print(os);
  os << ", ";
  rhs->print(os);
  os << ")";
}

void SIMDBinOpInst::print(ostream &os) const {
  os << "(" << X86IntrinBinOp::getOpName(op) << " ";
  lhs->print(os);
  os << ", ";
  rhs->print(os);
  os << ")";
}

void ShuffleVectorInst::print(ostream &os) const {
  os << "(shufflevector ";
  lhs->print(os);
  os << ", ";
  rhs->print(os);
  os << ", ";
  mask->print(os);
  os << ")";
}

/*
BitCastOp(Inst &i, unsigned lf, unsigned wf, unsigned lt, unsigned wt);
  : i(&i), lanes_from(lf), lanes_to(lt), width_from(width_from), width_to(wt) {
    assert(lf * wf == lt * wt);
}*/


void Addr::print(ostream &os) const {
  os << "%" << string(base->getName());
}

void Load::print(ostream &os) const {
  os << "(load " << *p << ")";
}

void Store::print(ostream &os) const {
  os << "(store " << *v << " to " << *p << ")";
}

};
