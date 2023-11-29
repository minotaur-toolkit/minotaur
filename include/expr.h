// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "type.h"

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

// SSA Definations
class Value : public Inst {
protected:
  type ty;
public:
  type getType() { return ty; }
  virtual void print(std::ostream &os) const = 0;
  Value(type ty) : ty (ty) {}
};

// SSA values from LHS
class Var final : public Value {
  std::string name;
  llvm::Value *v;
public:
  Var(llvm::Value *v) : Value(type(v->getType())), v(v) {
    llvm::raw_string_ostream ss(name);
    v->printAsOperand(ss, false);
    ss.flush();
  }
  auto& getName() const { return name; }
  void setValue(llvm::Value *vv) { v = vv; }
  void print(std::ostream &os) const override;
  llvm::Value *V () { return v; }
};

// literal constants to be synthesized
class ReservedConst final : public Value {
  llvm::Argument *A;
public:
  ReservedConst(type t) : Value(t), A(nullptr) {}
  ReservedConst(type t, llvm::Constant *C);
  type getType() { return ty; }
  llvm::Argument *getA () const { return A; }
  void setA (llvm::Argument *Arg) { A = Arg; }
  void print(std::ostream &os) const override;
};

// No-op
class CopyOp final : public Value {
private:
  ReservedConst *rc;
public:
  CopyOp(ReservedConst &rc) : Value(rc.getType()), rc(&rc) {}
  void print(std::ostream &os) const override;
  ReservedConst *Op0() { return rc; }
};


class UnaryOp final : public Value {
public:
  enum Op { bitreverse, bswap, ctpop, ctlz, cttz };
private:
  Op op;
  Value *V;
  type workty;
public:
  UnaryOp(Op op, Value &V, type &workty)
  : Value(V.getType()), op(op), V(&V), workty(workty) {}
  void print(std::ostream &os) const override;
  type getWorkTy() { return workty; }
  Op K() { return op; }
  Value *Op0() { return V; }
};


class BinaryOp final : public Value {
public:
  enum Op { band, bor, bxor, lshr, ashr, shl,
            add, sub, mul, sdiv, udiv,
            fadd, fsub, fmul, fdiv, frem };
private:
  Value *lhs;
  Value *rhs;
  Op op;
  type workty;
public:
  BinaryOp(Value &lhs, Value &rhs, type &workty)
  : Value(lhs.getType()), lhs(&lhs), rhs(&rhs), workty(workty) {}
  void print(std::ostream &os) const = 0;
  static bool isCommutative(Op op) { return
    op == band || op == bor || op == bxor ||
    op == add || op == mul || op == fadd || op == fmul;
  }
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  Op K() { return op; }
};


class ICmp final : public Value {
public:
  // syntactic pruning: less than/less equal only
  enum Cond { eq, ne, ult, ule, slt, sle};
private:
  Cond cond;
  Value *lhs;
  Value *rhs;
public:
  ICmp(Cond cond, Value &lhs, Value &rhs, unsigned width)
  : Value(type(width, 1, false)) , cond(cond), lhs(&lhs), rhs(&rhs) {}
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
  SIMDBinOpInst(IR::X86IntrinBinOp::Op op, Value &lhs, Value &rhs)
  : Value(type(getIntrinsicRetTy(op))), op(op), lhs(&lhs), rhs(&rhs) {}
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
    : Value(ety), lhs(&lhs), rhs(rhs), mask(&mask), expectty(ety) {}
  void print(std::ostream &os) const override;
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  ReservedConst *M() { return mask; }
  unsigned getElementBits() { return expectty.getBits(); }
  type getRetTy() { return expectty; }
  type getInputTy() { return lhs->getType(); }
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
  : Value(type(l, nb, false)), k(op), v(&v), lane(l),
    prev_bits(pb), new_bits(nb) {}
  void print(std::ostream &os) const override;
  Value *V() { return v; }
  Op K() { return k; }
  type getPrevTy () const { return type(lane, prev_bits, false); }
  type getNewTy () const { return type(lane, new_bits, false); }
};

using ConstMap = std::map<ReservedConst*, llvm::Constant*>;

struct Rewrite {
  llvm::Function &F;
  Inst *I;
  ConstMap Consts;
  unsigned CostBefore;
  unsigned CostAfter;
};

}
