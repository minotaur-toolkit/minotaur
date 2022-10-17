// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include <Type.h>
#include "llvm/ADT/APInt.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "ir/instr.h"

#include <vector>

namespace minotaur {

class Inst {
public:
  Inst() {}
  virtual void print(std::ostream &os) const = 0;
  friend std::ostream& operator<<(std::ostream &os, const Inst &val);
  virtual ~Inst() {}
};


class Value : public Inst {
protected:
  unsigned width;
public:
  unsigned getWidth() { return width; }
  virtual void print(std::ostream &os) const = 0;
  Value(unsigned width) : width (width) {}
};


class Var final : public Value {
  std::string name;
  llvm::Value *v;
public:
  Var(llvm::Value *v) : Value(v->getType()->getPrimitiveSizeInBits()), v(v) {
    llvm::raw_string_ostream ss(name);
    v->printAsOperand(ss, false);
    ss.flush();
  }
  Var(std::string &n, unsigned width) : Value(width), name(n), v(nullptr) {}
  auto& getName() const { return name; }
  void setValue(llvm::Value *vv) { v = vv; }
  void print(std::ostream &os) const override;
  llvm::Value *V () { return v; }
};


class ReservedConst final : public Value {
  llvm::Argument *A;
  std::vector<llvm::APInt> Values;
  type ty;
public:
  ReservedConst(type t) : Value(t.getWidth()), A(nullptr), ty(t) {}
  ReservedConst(type t, std::vector<llvm::APInt> Values)
    : Value(t.getWidth()), Values(Values), ty(t) {};
  ReservedConst(type t, llvm::Constant *C);
  bool isSymbolic() { return Values.empty(); }
  type getType() { return ty; }
  llvm::Argument *getA () const { return A; }
  std::vector<llvm::APInt> getValues () const { return Values; }
  llvm::Constant *getAsLLVMConstant(llvm::LLVMContext &) const;
  void setC(std::vector<llvm::APInt> values) { this->Values = values; }
  void setA (llvm::Argument *Arg) { A = Arg; }
  void print(std::ostream &os) const override;
};


class CopyInst final : public Value {
private:
  ReservedConst *rc;
public:
  CopyInst(ReservedConst &rc) : Value(rc.getWidth()), rc(&rc) {}
  void print(std::ostream &os) const override;
  ReservedConst *Op0() { return rc; }
};

class UnaryInst final : public Value {
public:
  enum Op { bitreverse, bswap, ctpop, ctlz, cttz };
private:
  Op op;
  Value *V;
  type workty;
public:
  UnaryInst(Op op, Value &V, type &workty)
  : Value(workty.getWidth()), op(op), V(&V), workty(workty) {}
  void print(std::ostream &os) const override;
  type getWorkTy() { return workty; }
  Op K() { return op; }
  Value *Op0() { return V; }
};


class BinaryInst final : public Value {
public:
  enum Op { band, bor, bxor, add, sub, mul, sdiv, udiv, lshr, ashr, shl };
private:
  Op op;
  Value *lhs;
  Value *rhs;
  type workty;
public:
  static bool isLaneIndependent(Op op) {
    return op == band || op == bor || op == bxor;
  }
  BinaryInst(Op op, Value &lhs, Value &rhs, type &workty)
  : Value(workty.getWidth()), op(op), lhs(&lhs), rhs(&rhs), workty(workty) {}
  void print(std::ostream &os) const override;
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  type getWorkTy() { return workty; }
  Op K() { return op; }
  static bool isCommutative (Op k) {
    return k == Op::band || k == Op::bor || k == Op::bxor ||
           k == Op::add || k == Op::mul;
  }
};


class ICmpInst final : public Value {
public:
  // syntactic pruning: less than/less equal only
  enum Cond { eq, ne, ult, ule, slt, sle};
private:
  Cond cond;
  Value *lhs;
  Value *rhs;
public:
  ICmpInst(Cond cond, Value &lhs, Value &rhs, unsigned width)
  : Value(width) , cond(cond), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  Cond K() { return cond; }
};


class SIMDBinOpInst final : public Value {
  IR::X86IntrinBinOp::Op op;
  Value *lhs;
  Value *rhs;
public:
  SIMDBinOpInst(IR::X86IntrinBinOp::Op op, Value &lhs, Value &rhs, unsigned width)
    : Value(width), op(op), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  IR::X86IntrinBinOp::Op K() { return op; }
  static bool is512 (IR::X86IntrinBinOp::Op K) {
    return K == IR::X86IntrinBinOp::x86_avx512_pavg_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pavg_b_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pshuf_b_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrl_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrl_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrl_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrli_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrli_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrli_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrlv_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrlv_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrlv_w_128 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrlv_w_256 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrlv_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psra_q_128 ||
           K == IR::X86IntrinBinOp::x86_avx512_psra_q_256 ||
           K == IR::X86IntrinBinOp::x86_avx512_psra_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psra_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psra_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrai_q_128 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrai_q_256 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrai_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrai_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrai_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrav_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrav_q_128 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrav_q_256 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrav_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrav_w_128 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrav_w_256 ||
           K == IR::X86IntrinBinOp::x86_avx512_psrav_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psll_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psll_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psll_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pslli_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pslli_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pslli_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psllv_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psllv_q_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psllv_w_128 ||
           K == IR::X86IntrinBinOp::x86_avx512_psllv_w_256 ||
           K == IR::X86IntrinBinOp::x86_avx512_psllv_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pmulh_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pmulhu_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pmaddw_d_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_pmaddubs_w_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_packsswb_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_packuswb_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_packssdw_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_packusdw_512 ||
           K == IR::X86IntrinBinOp::x86_avx512_psad_bw_512;
  }
};


class FakeShuffleInst final : public Value {
  Value *lhs;
  Value *rhs;
  ReservedConst *mask;
  type expectty;
public:
  FakeShuffleInst(Value &lhs, Value *rhs, ReservedConst &mask, type &ety)
    : Value(ety.getWidth()), lhs(&lhs), rhs(rhs), mask(&mask), expectty(ety) {}
  void print(std::ostream &os) const override;
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  ReservedConst *M() { return mask; }
  unsigned getElementBits() { return expectty.getBits(); }
  type getRetTy() { return expectty; }
  type getInputTy() {
    return type(lhs->getWidth() / getElementBits(), getElementBits(), false);
  }
};


class ConversionInst final : public Value {
public:
  enum Op { sext, zext, trunc };
private:
  Op k;
  Value *v;
  unsigned lane, prev_bits, new_bits;
public:
  ConversionInst(Op op, Value &v, unsigned l, unsigned pb, unsigned nb)
    : Value(l * nb), k(op), v(&v), lane(l), prev_bits(pb), new_bits(nb) {}
  void print(std::ostream &os) const override;
  Value *V() { return v; }
  Op K() { return k; }
  type getPrevTy () const { return type(lane, prev_bits, false); }
  type getNewTy () const { return type(lane, new_bits, false); }
};


class Pointer final : public Inst {
  llvm::Value *v;
  ReservedConst *offset;
  std::optional<type> ty;
  std::string name;
public:
  Pointer(llvm::Value *p) : v(p), ty(std::nullopt) {
    llvm::raw_string_ostream ss(name);
    v->printAsOperand(ss, false);
    ss.flush();
  }
  void print(std::ostream &os) const override;
};


class PointerVector final: public Inst {
  llvm::Value *addrs;
  std::string name;
public:
  PointerVector(llvm::Value *v) : addrs(v) {
    llvm::raw_string_ostream ss(name);
    v->printAsOperand(ss, false);
    ss.flush();
  }
  void print(std::ostream &os) const override;
};


class Load final : public Value {
  Pointer *p;
public:
  Load(Pointer &p, type &loadty) : Value(loadty.getWidth()), p(&p) {}
  void print(std::ostream &os) const override;
};


class Gather final : public Value {
  PointerVector *ps;
  type ty;
public:
  Gather(PointerVector &p, type &ty): Value(ty.getWidth()), ps(&p), ty(ty) {}
  void print(std::ostream &os) const override;
};

}
