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
class Copy final : public Value {
private:
  ReservedConst *rc;
public:
  Copy(ReservedConst &rc) : Value(rc.getType()), rc(&rc) {}
  void print(std::ostream &os) const override;
  ReservedConst *V() { return rc; }
};


class UnaryOp final : public Value {
public:
  enum Op { bitreverse, bswap, ctpop, ctlz, cttz };
private:
  Op op;
  Value *v;
  type workty;
public:
  UnaryOp(Op op, Value &V, type &workty)
  : Value(V.getType()), op(op), v(&V), workty(workty) {}
  void print(std::ostream &os) const override;
  Op K() { return op; }
  Value *V() { return v; }
  type getWorkTy() { return workty; }
};


class BinaryOp final : public Value {
public:
  enum Op { band, bor, bxor, lshr, ashr, shl,
            add, sub, mul, sdiv, udiv,
            fadd, fsub, fmul, fdiv, frem };
private:
  Op op;
  Value *lhs;
  Value *rhs;
  type workty;
public:
  BinaryOp(Op op, Value &lhs, Value &rhs, type &workty)
  : Value(lhs.getType()), op(op), lhs(&lhs), rhs(&rhs), workty(workty) {}
  void print(std::ostream &os) const;
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  Op K() { return op; }
  type getWorkTy() { return workty; }

  static bool isFloatingPoint(Op op) {
    return op == fadd || op == fsub || op == fmul || op == fdiv || op == frem;
  }

  static bool isCommutative(Op op) {
    return op == band || op == bor || op == bxor ||
           op == add || op == mul ||
           op == fadd || op == fmul;
  }

  static bool isLaneIndependent(Op op) {
    return op == band || op == bor || op == bxor;
  }
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
  ICmp(Cond cond, Value &lhs, Value &rhs, unsigned lanes)
  : Value(type(lanes, 1, false)) , cond(cond), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  Cond K() { return cond; }
  unsigned getLanes() { return getType().getLane(); }
  unsigned getBits() { return lhs->getType().getWidth() / getType().getLane(); }
};


class FCmp final : public Value {
public:
  enum Cond { f, oeq, ogt, oge, olt, ole, one, ord, ueq, ugt, uge, ult, ule, une, uno, t};
private:
  Cond cond;
  Value *lhs;
  Value *rhs;
public:
  FCmp(Cond cond, Value &lhs, Value &rhs, unsigned lanes)
  : Value(type(lanes, 1, false)) , cond(cond), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Value *L() { return lhs; }
  Value *R() { return rhs; }
  Cond K() { return cond; }
  unsigned getLanes() { return getType().getLane(); }
  unsigned getBits() { return lhs->getType().getWidth() / getType().getLane(); }
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
  type getRetTy();
  type getInputTy();
};


class ConversionOp final : public Value {
public:
  enum Op { sext, zext, trunc };
private:
  Op k;
  Value *v;
  unsigned lane, prev_bits, new_bits;
public:
  ConversionOp(Op op, Value &v, unsigned l, unsigned pb, unsigned nb)
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
  Inst *I;
  ConstMap Consts;
  unsigned CostBefore;
  unsigned CostAfter;
};

std::vector<type> getBinaryOpWorkTypes(type expected, BinaryOp::Op op);
std::vector<type> getUnaryOpWorkTypes(type expected, UnaryOp::Op op);
std::vector<type> getShuffleWorkTypes(type expected);
std::vector<type> getConversionOpWorkTypes(type to, type from);

}
