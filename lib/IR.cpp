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

void Ptr::print(ostream &os) const {
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

static llvm::Type& llvmType() {

}

static string getOpName(X86IntrinBinOp::Op op) {
  switch (op) {
  case X86IntrinBinOp::sse2_psrl_w:        return "x86.sse2.psrl.w";
  case X86IntrinBinOp::sse2_psrl_d:        return "x86.sse2.psrl.d";
  case X86IntrinBinOp::sse2_psrl_q:        return "x86.sse2.psrl.q";
  case X86IntrinBinOp::avx2_psrl_w:        return "x86.avx2.psrl.w";
  case X86IntrinBinOp::avx2_psrl_d:        return "x86.avx2.psrl.d";
  case X86IntrinBinOp::avx2_psrl_q:        return "x86.avx2.psrl.q";
  case X86IntrinBinOp::sse2_pavg_w:        return "x86.sse2.pavg.w";
  case X86IntrinBinOp::avx2_pavg_b:        return "x86.avx2.pavg.b";
  case X86IntrinBinOp::avx2_pavg_w:        return "x86.avx2.pavg.w";
  case X86IntrinBinOp::avx2_pshuf_b:       return "x86.avx2.pshuf.b";
  case X86IntrinBinOp::ssse3_pshuf_b_128:  return "x86.ssse3.pshuf.b.128";
  case X86IntrinBinOp::mmx_padd_b:         return "x86.mmx.padd.b";
  case X86IntrinBinOp::mmx_padd_w:         return "x86.mmx.padd.w";
  case X86IntrinBinOp::mmx_padd_d:         return "x86.mmx.padd.d";
  case X86IntrinBinOp::mmx_punpckhbw:      return "x86.mmx.punpckhbw";
  case X86IntrinBinOp::mmx_punpckhwd:      return "x86.mmx.punpckhwd";
  case X86IntrinBinOp::mmx_punpckhdq:      return "x86.mmx.punpckhdq";
  case X86IntrinBinOp::mmx_punpcklbw:      return "x86.mmx.punpcklbw";
  case X86IntrinBinOp::mmx_punpcklwd:      return "x86.mmx.punpcklwd";
  case X86IntrinBinOp::mmx_punpckldq:      return "x86.mmx.punpckldq";
  case X86IntrinBinOp::sse2_psrai_w:       return "x86.sse2.psrai.w";
  case X86IntrinBinOp::sse2_psrai_d:       return "x86.sse2.psrai.d";
  case X86IntrinBinOp::avx2_psrai_w:       return "x86.avx2.psrai.w";
  case X86IntrinBinOp::avx2_psrai_d:       return "x86.avx2.psrai.d";
  case X86IntrinBinOp::avx512_psrai_w_512: return "x86.avx512.psrai.w.512";
  case X86IntrinBinOp::avx512_psrai_d_512: return "x86.avx512.psrai.d.512";
  case X86IntrinBinOp::avx512_psrai_q_128: return "x86.avx512.psrai.q.128";
  case X86IntrinBinOp::avx512_psrai_q_256: return "x86.avx512.psrai.q.256";
  case X86IntrinBinOp::avx512_psrai_q_512: return "x86.avx512.psrai.q.512";
  case X86IntrinBinOp::sse2_psrli_w:       return "x86.sse2.psrli.w";
  case X86IntrinBinOp::sse2_psrli_d:       return "x86.sse2.psrli.d";
  case X86IntrinBinOp::sse2_psrli_q:       return "x86.sse2.psrli.q";
  case X86IntrinBinOp::avx2_psrli_w:       return "x86.avx2.psrli.w";
  case X86IntrinBinOp::avx2_psrli_d:       return "x86.avx2.psrli.d";
  case X86IntrinBinOp::avx2_psrli_q:       return "x86.avx2.psrli.q";
  case X86IntrinBinOp::avx512_psrli_w_512: return "x86.avx512.psrli.w.512";
  case X86IntrinBinOp::avx512_psrli_d_512: return "x86.avx512.psrli.d.512";
  case X86IntrinBinOp::avx512_psrli_q_512: return "x86.avx512.psrli.q.512";
  case X86IntrinBinOp::sse2_pslli_w:       return "x86.sse2.pslli.w";
  case X86IntrinBinOp::sse2_pslli_d:       return "x86.sse2.pslli.d";
  case X86IntrinBinOp::sse2_pslli_q:       return "x86.sse2.pslli.q";
  case X86IntrinBinOp::avx2_pslli_w:       return "x86.avx2.pslli.w";
  case X86IntrinBinOp::avx2_pslli_d:       return "x86.avx2.pslli.d";
  case X86IntrinBinOp::avx2_pslli_q:       return "x86.avx2.pslli.q";
  case X86IntrinBinOp::avx512_pslli_w_512: return "x86.avx512.pslli.w.512";
  case X86IntrinBinOp::avx512_pslli_d_512: return "x86.avx512.pslli.d.512";
  case X86IntrinBinOp::avx512_pslli_q_512: return "x86.avx512.pslli.q.512";
  }
  UNREACHABLE();
}

void SIMDBinOpInst::print(ostream &os) const {
  os << "(" << getOpName(op) << " ";
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

void Load::print(ostream &os) const {
  os << "(load)";
}

};
