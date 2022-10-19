// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#include "Expr.h"
#include "ir/instr.h"
#include "util/compiler.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/LLVMContext.h"

#include <string>
#include <iostream>

using namespace std;
using namespace llvm;

namespace minotaur {

ostream& operator<<(ostream &os, const Inst &val) {
  val.print(os);
  return os;
}

void Var::print(ostream &os) const {
  os << "(var b" << width << " " << name <<")";
}

ReservedConst::ReservedConst(type t, llvm::Constant *C)
    : Value(t.getWidth()), A(nullptr), ty(t) {
  if (ConstantInt *CI = dyn_cast<ConstantInt>(C)){
    Values.push_back(CI->getValue());
  } else if (ConstantVector *CV = dyn_cast<ConstantVector>(C)) {
    for (auto V : CV->operand_values()) {
      ConstantInt *CI = cast<llvm::ConstantInt>(V);
      Values.push_back(CI->getValue());
    }
  }
}

llvm::Constant *ReservedConst::getAsLLVMConstant(llvm::LLVMContext &C) const {
  auto llvm_ty = ty.toLLVM(C);
  if (ty.isScalar()) {
    return ConstantInt::get(llvm_ty, Values.back());
  } else if (ty.isVector()) {
    llvm::FixedVectorType *vty = llvm::cast<llvm::FixedVectorType>(llvm_ty);
    llvm::IntegerType *elemty =
      llvm::cast<llvm::IntegerType>(vty->getElementType());
    vector<Constant*> consts;
    for (auto V : Values) {
      consts.push_back(ConstantInt::get(elemty, V));
    }
    return ConstantVector::get(consts);
  }
  UNREACHABLE();
}

void ReservedConst::print(ostream &os) const {
  if (!Values.empty()) {
    string str;
    if (ty.isScalar()) {
      llvm::raw_string_ostream ss(str);
      auto V = Values[0];
      ss<<"i"<<V.getBitWidth()<<" ";
      V.print(ss, false);
      ss.flush();
    } else if (ty.isVector()) {
      llvm::raw_string_ostream ss(str);
      ss<<"<"<<ty.getLane()<<" x i"<<ty.getBits()<<"> ";

      ss<<"{";
      for (unsigned i = 0 ; i < ty.getLane(); i ++) {
        Values[i].print(ss, false);
        if (i != ty.getLane() - 1)
          ss<<",";
      }
      ss<<"}";
      ss.flush();
    }
    os << "(const " << str << ")";
  } else {
    os << "reservedconst";
  }
}

void CopyInst::print(ostream &os) const {
  os << "(copy ";
  rc->print(os);
  os << ")";
}

void UnaryInst::print(ostream &os) const {
  const char *str = nullptr;
  switch (op) {
  case bitreverse: str = "bitreverse"; break;
  case bswap:      str = "bswap";      break;
  case ctpop:      str = "ctpop";      break;
  case ctlz:       str = "ctlz";       break;
  case cttz:       str = "cttz";       break;
  }
  os << "(" << str << " " << workty << " ";
  V->print(os);
  os << ")";
}

void BinaryInst::print(ostream &os) const {
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
  }
  os << "(" << str << " " << workty << " ";
  lhs->print(os);
  os << " ";
  rhs->print(os);
  os << ")";
}

void ICmpInst::print(ostream &os) const {
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
  os << " b" << width;
  //rhs->print(os);
  os << ")";
}

void SIMDBinOpInst::print(ostream &os) const {
  os << "(" << IR::X86IntrinBinOp::getOpName(op) << " ";
  lhs->print(os);
  os << " ";
  rhs->print(os);
  os << ")";
}

void FakeShuffleInst::print(ostream &os) const {
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


void ConversionInst::print(ostream &os) const {
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

/*
BitCastOp(Inst &i, unsigned lf, unsigned wf, unsigned lt, unsigned wt);
  : i(&i), lanes_from(lf), lanes_to(lt), width_from(width_from), width_to(wt) {
    assert(lf * wf == lt * wt);
}*/


void Pointer::print(ostream &os) const {
  os << "(ptr " << name <<")";
}

void PointerVector::print(ostream &os) const {
  os << "(ptrs " << name <<")";
}

void Load::print(ostream &os) const {
  os << "(load " << *p << ")";
}

};
