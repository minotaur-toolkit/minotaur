// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "type.h"

#include "llvm/IR/Argument.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Value.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "ir/instr.h"

#include <string>
#include <vector>

namespace minotaur {

class Inst {
public:
  Inst() {}
  virtual void print(llvm::raw_ostream &os) const = 0;
  friend llvm::raw_ostream &operator<<(llvm::raw_ostream &os,
                                        const Inst &val);
  virtual ~Inst() {}
};

// SSA Definitions
class Value : public Inst {
protected:
  type ty;
public:
  type getType() const { return ty; }
  virtual void print(llvm::raw_ostream &os) const = 0;
  Value(type ty) : ty(ty) {}
};

// SSA values from LHS
class Var final : public Value {
  std::string name;
  llvm::Value *val;
public:
  Var(llvm::Value *v) : Value(type(v->getType())), val(v) {
    llvm::raw_string_ostream ss(name);
    v->printAsOperand(ss, false);
    ss.flush();
  }
  Var(std::string name, type ty)
    : Value(ty), name(name), val(nullptr) {}
  auto& getName() const { return name; }
  void setValue(llvm::Value *v) { val = v; }
  void print(llvm::raw_ostream &os) const override;
  llvm::Value *getValue() { return val; }
};

// literal constants to be synthesized
class ReservedConst final : public Value {
  llvm::Argument *arg;
  llvm::Constant *constant;
public:
  ReservedConst(type t)
    : Value(t), arg(nullptr), constant(nullptr) {}
  ReservedConst(type t, llvm::Constant *C)
    : Value(t), arg(nullptr), constant(C) {};
  llvm::Argument *getArg() const { return arg; }
  void setArg(llvm::Argument *A) { arg = A; }
  void print(llvm::raw_ostream &os) const override;
  void setConst(llvm::Constant *C) { constant = C; }
  llvm::Constant *getConst() const { return constant; }
};

// No-op
class Copy final : public Value {
private:
  ReservedConst *rc;
public:
  Copy(ReservedConst &rc) : Value(rc.getType()), rc(&rc) {}
  void print(llvm::raw_ostream &os) const override;
  ReservedConst *getReservedConst() { return rc; }
};


class UnaryOp final : public Value {
public:
  enum Op { bitreverse, bswap, ctpop, ctlz, cttz,
            fneg, fabs, fceil, ffloor, frint,
            fnearbyint, fround, froundeven, ftrunc };
private:
  Op op;
  Value *operand;
  type workty;
public:
  UnaryOp(Op op, Value &V, type &workty)
    : Value(V.getType()), op(op), operand(&V),
      workty(workty) {}
  void print(llvm::raw_ostream &os) const override;
  Op getOpcode() { return op; }
  Value *getOperand() { return operand; }
  type getWorkTy() { return workty; }

  static bool isFloatingPoint(Op op) {
    return op == fneg || op == fabs ||
           op == fceil || op == ffloor ||
           op == frint || op == fnearbyint ||
           op == fround || op == froundeven ||
           op == ftrunc;
  }
};


class BinaryOp final : public Value {
public:
  enum Op { band, bor, bxor, lshr, ashr, shl,
            add, sub, mul, sdiv, udiv,
            umax, umin, smax, smin,
            fadd, fsub, fmul, fdiv,
            fmaxnum, fminnum, fmaximum,
            fminimum, copysign };
private:
  Op op;
  Value *lhs;
  Value *rhs;
  type workty;
public:
  BinaryOp(Op op, Value &lhs, Value &rhs, type &workty)
    : Value(lhs.getType()), op(op), lhs(&lhs),
      rhs(&rhs), workty(workty) {}
  void print(llvm::raw_ostream &os) const;
  Value *getLHS() { return lhs; }
  Value *getRHS() { return rhs; }
  Op getOpcode() { return op; }
  type getWorkTy() { return workty; }

  static bool isFloatingPoint(Op op) {
    return op == fadd || op == fsub ||
           op == fmul || op == fdiv ||
           op == fmaxnum || op == fminnum ||
           op == fmaximum || op == fminimum ||
           op == copysign;
  }

  static bool isCommutative(Op op) {
    return op == band || op == bor || op == bxor ||
           op == add || op == mul ||
           op == fadd || op == fmul ||
           op == umax || op == umin ||
           op == smax || op == smin ||
           op == fmaxnum || op == fminnum ||
           op == fmaximum || op == fminimum;
  }

  static bool isLogical(Op op) {
    return op == band || op == bor || op == bxor;
  }
};


class ICmp final : public Value {
public:
  enum Cond { eq, ne, ult, ule, slt, sle,
              ugt, uge, sgt, sge };
private:
  Cond cond;
  bool same_sign;
  Value *lhs;
  Value *rhs;
public:
  ICmp(Cond cond, Value &lhs, Value &rhs, unsigned lanes,
       bool same_sign = false)
    : Value(type::IntegerVectorizable(lanes, 1)),
      cond(cond), same_sign(same_sign),
      lhs(&lhs), rhs(&rhs) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getLHS() { return lhs; }
  Value *getRHS() { return rhs; }
  Cond getCond() { return cond; }
  bool hasSameSign() const { return same_sign; }
  unsigned getLanes() {
    return getType().getLane();
  }
  unsigned getBits() {
    return lhs->getType().getWidth() /
           getType().getLane();
  }
};


class FCmp final : public Value {
public:
  enum Cond { f, oeq, ogt, oge, olt, ole, one, ord,
              ueq, ugt, uge, ult, ule, une, uno, t };
private:
  Cond cond;
  Value *lhs;
  Value *rhs;
public:
  FCmp(Cond cond, Value &lhs, Value &rhs, unsigned lanes)
    : Value(type::IntegerVectorizable(lanes, 1)),
      cond(cond), lhs(&lhs), rhs(&rhs) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getLHS() { return lhs; }
  Value *getRHS() { return rhs; }
  Cond getCond() { return cond; }
  unsigned getLanes() {
    return getType().getLane();
  }
  unsigned getBits() {
    return lhs->getType().getWidth() /
           getType().getLane();
  }
};


enum class IntrinsicBinOp {
#define PROCESS(NAME, A, B, C, D, E, F) NAME,
#include "ir/x86_intrinsics_binop.inc"
#undef PROCESS
  numOfX86BinOpIntrinsics,
};

enum class IntrinsicTerOp {
#define PROCESS(NAME, A, B, C, D, E, F, G, H) NAME,
#include "ir/x86_intrinsics_terop.inc"
#undef PROCESS
  numOfX86TerOpIntrinsics,
};

static constexpr unsigned numOfX86BinOpIntrinsics =
    static_cast<unsigned>(
        IntrinsicBinOp::numOfX86BinOpIntrinsics);

static constexpr unsigned numOfX86TerOpIntrinsics =
    static_cast<unsigned>(
        IntrinsicTerOp::numOfX86TerOpIntrinsics);

inline const char *
getOpName(IR::X86IntrinBinOp::Op op) {
  switch (op) {
#define PROCESS(NAME, A, B, C, D, E, F)              \
  case IR::X86IntrinBinOp::Op::NAME:                 \
    return #NAME;
#include "ir/x86_intrinsics_binop.inc"
#undef PROCESS
  }
  llvm_unreachable("Unknown X86IntrinBinOp::Op");
}

class SIMDBinOpInst final : public Value {
  IR::X86IntrinBinOp::Op op;
  Value *lhs;
  Value *rhs;
public:
  SIMDBinOpInst(IR::X86IntrinBinOp::Op op,
                Value &lhs, Value &rhs)
    : Value(type(getIntrinsicRetTy(op))), op(op),
      lhs(&lhs), rhs(&rhs) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getLHS() { return lhs; }
  Value *getRHS() { return rhs; }
  IR::X86IntrinBinOp::Op getOpcode() { return op; }
  static bool is512Bit(IR::X86IntrinBinOp::Op op) {
    using K = IR::X86IntrinBinOp;
    return op == K::x86_avx512_pavg_w_512 ||
      op == K::x86_avx512_pavg_b_512 ||
      op == K::x86_avx512_pshuf_b_512 ||
      op == K::x86_avx512_psrl_w_512 ||
      op == K::x86_avx512_psrl_d_512 ||
      op == K::x86_avx512_psrl_q_512 ||
      op == K::x86_avx512_psrli_w_512 ||
      op == K::x86_avx512_psrli_d_512 ||
      op == K::x86_avx512_psrli_q_512 ||
      op == K::x86_avx512_psrlv_d_512 ||
      op == K::x86_avx512_psrlv_q_512 ||
      op == K::x86_avx512_psrlv_w_128 ||
      op == K::x86_avx512_psrlv_w_256 ||
      op == K::x86_avx512_psrlv_w_512 ||
      op == K::x86_avx512_psra_q_128 ||
      op == K::x86_avx512_psra_q_256 ||
      op == K::x86_avx512_psra_w_512 ||
      op == K::x86_avx512_psra_d_512 ||
      op == K::x86_avx512_psra_q_512 ||
      op == K::x86_avx512_psrai_q_128 ||
      op == K::x86_avx512_psrai_q_256 ||
      op == K::x86_avx512_psrai_w_512 ||
      op == K::x86_avx512_psrai_d_512 ||
      op == K::x86_avx512_psrai_q_512 ||
      op == K::x86_avx512_psrav_d_512 ||
      op == K::x86_avx512_psrav_q_128 ||
      op == K::x86_avx512_psrav_q_256 ||
      op == K::x86_avx512_psrav_q_512 ||
      op == K::x86_avx512_psrav_w_128 ||
      op == K::x86_avx512_psrav_w_256 ||
      op == K::x86_avx512_psrav_w_512 ||
      op == K::x86_avx512_psll_w_512 ||
      op == K::x86_avx512_psll_d_512 ||
      op == K::x86_avx512_psll_q_512 ||
      op == K::x86_avx512_pslli_w_512 ||
      op == K::x86_avx512_pslli_d_512 ||
      op == K::x86_avx512_pslli_q_512 ||
      op == K::x86_avx512_psllv_d_512 ||
      op == K::x86_avx512_psllv_q_512 ||
      op == K::x86_avx512_psllv_w_128 ||
      op == K::x86_avx512_psllv_w_256 ||
      op == K::x86_avx512_psllv_w_512 ||
      op == K::x86_avx512_pmulh_w_512 ||
      op == K::x86_avx512_pmulhu_w_512 ||
      op == K::x86_avx512_pmaddw_d_512 ||
      op == K::x86_avx512_pmaddubs_w_512 ||
      op == K::x86_avx512_packsswb_512 ||
      op == K::x86_avx512_packuswb_512 ||
      op == K::x86_avx512_packssdw_512 ||
      op == K::x86_avx512_packusdw_512 ||
      op == K::x86_avx512_psad_bw_512;
  }
};


class FakeShuffleInst final : public Value {
  Value *lhs;
  Value *rhs;
  ReservedConst *mask;
  type expectty;
public:
  FakeShuffleInst(Value &lhs, Value *rhs,
                  ReservedConst &mask, type &ety)
    : Value(ety), lhs(&lhs), rhs(rhs),
      mask(&mask), expectty(ety) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getLHS() { return lhs; }
  Value *getRHS() { return rhs; }
  ReservedConst *getMask() { return mask; }
  unsigned getElementBits() {
    return expectty.getBits();
  }
  type getRetTy();
  type getInputTy();
};


class ExtractElement final : public Value {
  Value *vec;
  ReservedConst *idx;
public:
  ExtractElement(Value &v, ReservedConst &idx,
                 type &ety)
    : Value(type(ety)), vec(&v), idx(&idx) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getVector() { return vec; }
  ReservedConst *getIndex() { return idx; }
  type getInputTy();
};


class InsertElement final : public Value {
  Value *vec;
  Value *elt;
  ReservedConst *idx;
public:
  InsertElement(Value &v, Value &elt,
                ReservedConst &idx, type &ety)
    : Value(type(ety)), vec(&v), elt(&elt),
      idx(&idx) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getVector() { return vec; }
  Value *getElement() { return elt; }
  ReservedConst *getIndex() { return idx; }
  type getInputTy() const;
};


class VectorReduce final : public Value {
public:
  enum Op { add, mul, band, bor, bxor };
private:
  Op op;
  Value *vec;
  type input_ty;
public:
  VectorReduce(Op op, Value &v, type input_ty)
    : Value(type::Scalar(input_ty.getBits(), input_ty.isFP())),
      op(op), vec(&v), input_ty(input_ty) {}
  void print(llvm::raw_ostream &os) const override;
  Op getOpcode() const { return op; }
  Value *getVector() { return vec; }
  type getInputTy() const { return input_ty; }
};


class IntConversion final : public Value {
public:
  enum Op { sext, zext, trunc };
private:
  Op op;
  Value *operand;
  unsigned lane, prev_bits, new_bits;
public:
  IntConversion(Op op, Value &v, unsigned l,
                unsigned pb, unsigned nb)
    : Value(type::IntegerVectorizable(l, nb)),
      op(op), operand(&v), lane(l),
      prev_bits(pb), new_bits(nb) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getOperand() { return operand; }
  Op getOpcode() { return op; }
  type getPrevTy() const {
    return type::IntegerVectorizable(lane, prev_bits);
  }
  type getNewTy() const {
    return type::IntegerVectorizable(lane, new_bits);
  }
};


class FPConversion final : public Value {
public:
  enum Op { fptrunc, fpext, fptoui, fptosi,
            uitofp, sitofp };
private:
  Op op;
  Value *operand;
public:
  FPConversion(Op op, Value &v, type &ty)
    : Value(ty), op(op), operand(&v) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getOperand() { return operand; }
  Op getOpcode() { return op; }
  type getPrevTy() const;
  type getNewTy() const;
};


class Select final : public Value {
  Value *cond;
  Value *lhs;
  Value *rhs;
public:
  Select(Value &cond, Value &lhs, Value &rhs)
    : Value(lhs.getType()), cond(&cond),
      lhs(&lhs), rhs(&rhs) {}
  void print(llvm::raw_ostream &os) const override;
  Value *getCond() { return cond; }
  Value *getLHS() { return lhs; }
  Value *getRHS() { return rhs; }
};


struct Rewrite {
  Inst *I;
  unsigned CostAfter;
  unsigned CostBefore;
};

std::vector<type> getBinaryOpWorkTypes(
    type expected, BinaryOp::Op op);
std::vector<type> getUnaryOpWorkTypes(
    type expected, UnaryOp::Op op);
std::vector<type> getShuffleWorkTypes(type expected);
std::vector<type> getConversionOpWorkTypes(
    type to, type from);
std::vector<type> getInsertElementWorkTypes(
    type expected);

} // namespace minotaur
