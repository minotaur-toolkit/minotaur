// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "IR.h"

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

void Ptr::print(ostream &os) const {
  os << "%" << string(v->getName());
}

void ReservedConst::print(ostream &os) const {
  const char *str = "reservedconst";
  os << str;
}

void UnaryOp::print(ostream &os) const {
  const char *str = nullptr;
  switch (op) {
  case copy:       str = "copy"; break;
  }
  os << "(" << str << " ";
  op0->print(os);
  os << ")";
}

void BinOp::print(ostream &os) const {
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

static string getOpName(X86IntrinBinOp::Op op) {
  switch (op) {
  case X86IntrinBinOp::sse2_psrl_w: return "x86.sse2.psrl.w";
  case X86IntrinBinOp::sse2_psrl_d: return "x86.sse2.psrl.d";
  case X86IntrinBinOp::sse2_psrl_q: return "x86.sse2.psrl.q";
  case X86IntrinBinOp::avx2_psrl_w: return "x86.avx2.psrl.w";
  case X86IntrinBinOp::avx2_psrl_d: return "x86.avx2.psrl.d";
  case X86IntrinBinOp::avx2_psrl_q: return "x86.avx2.psrl.q";
  case X86IntrinBinOp::sse2_pavg_w: return "x86.sse2.pavg.w";
  case X86IntrinBinOp::avx2_pavg_b: return "x86.avx2.pavg.b";
  case X86IntrinBinOp::avx2_pavg_w: return "x86.avx2.pavg.w";
  case X86IntrinBinOp::avx2_pshuf_b: return "x86.avx2.pshuf.b";
  case X86IntrinBinOp::ssse3_pshuf_b_128: return "x86.ssse3.pshuf.b.128";
  }
  UNREACHABLE();
}

void SIMDBinOpIntr::print(ostream &os) const {
  os << "(" << getOpName(op) << " ";
  lhs->print(os);
  os << ", ";
  rhs->print(os);
  os << ")";
}

/*
BitCastOp(Inst &i, unsigned lf, unsigned wf, unsigned lt, unsigned wt);
  : i(&i), lanes_from(lf), lanes_to(lt), width_from(width_from), width_to(wt) {
    assert(lf * wf == lt * wt);
}*/

void Load::print(ostream &os) const {
  os << "(load)";
}

};
