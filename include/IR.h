// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include "llvm/IR/IRBuilder.h"
#include "ir/instr.h"

#include <vector>

using namespace IR;

namespace minotaur {

class Inst {
  std::string name;
  auto& getName() const { return name; }
public:
  virtual void print(std::ostream &os) const = 0;
  friend std::ostream& operator<<(std::ostream &os, const Inst &val);
  virtual ~Inst() {}
};

class Var final : public Inst {
  llvm::Value *v;
public:
  Var(llvm::Value *v) : v(v) {}
  void print(std::ostream &os) const override;
  llvm::Value *V () { return v; }
};

class Ptr final : public Inst {
  llvm::Value *v;
public:
  Ptr(llvm::Value *v) : v(v) {}
  void print(std::ostream &os) const override;
  llvm::Value *V () { return v; }
};

class ReservedConst final : public Inst {
  // type?
  llvm::Type *type;
  llvm::Argument *A;
public:
  ReservedConst(llvm::Type *t) : type(t) {}
  void print(std::ostream &os) const override;
  llvm::Type *T () { return type; }
  llvm::Argument *getA () { return A; }
  void setA (llvm::Argument *Arg) { A = Arg; }
};

class UnaryOp final : public Inst {
public:
  enum Op { copy };
private:
  Op op;
  Inst *op0;
public:
  UnaryOp(Op op, Inst &op0) : op(op), op0(&op0) {}
  void print(std::ostream &os) const override;
  Inst *Op0() { return op0; }

  Op K() { return op; }
};

class BinOp final : public Inst {
public:
  enum Op { band, bor, bxor, add, sub, mul, sdiv, udiv, lshr, ashr, shl};
private:
  Op op;
  Inst *lhs;
  Inst *rhs;
public:
  BinOp(Op op, Inst &lhs, Inst &rhs) : op(op), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  Op K() { return op; }
  static bool isCommutative (Op k) {
    return k == Op::band || k == Op::bor || k == Op::bxor || k == Op::add|| k == Op::mul;
  }
};

class ICmpOp final : public Inst {
public:
  // syntactic pruning: less than/less equal only
  enum Cond { eq, ne, ult, ule, slt, sle};
private:
  Cond cond;
  Inst *lhs;
  Inst *rhs;
public:
  ICmpOp(Cond cond, Inst &lhs, Inst &rhs) : cond(cond), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  Cond K() { return cond; }
};

class BitCastOp final : public Inst {
  Inst *i;
  unsigned lanes_from, lanes_to;
  unsigned width_from, width_to;
public:
  BitCastOp(Inst &i, unsigned lf, unsigned wf, unsigned lt, unsigned wt);

  void print(std::ostream &os) const override;
  Inst *I() { return i; }
};

class SIMDBinOpIntr final : public Inst {
  X86IntrinBinOp::Op op;
  Inst *lhs;
  Inst *rhs;
public:
  SIMDBinOpIntr(X86IntrinBinOp::Op op, Inst &lhs, Inst &rhs)
    : op(op), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  X86IntrinBinOp::Op K() { return op; }
};

class Hole : Inst {
};

class Load final : public Inst {
  Ptr *ptr;
  llvm::Type *ety;
public:
  Load(Ptr &ptr, llvm::Type *ety) : ptr(&ptr), ety(ety) {}
  void print(std::ostream &os) const override;
  Ptr *addr() { return ptr; }
  llvm::Type *elemTy() { return ety; }
};

/*
class Store final : public Inst {
  Inst *ptr;
  Inst *value;
public:
  Inst *Ptr() { return ptr; }
};

class GEP final : public Value {

};
*/
};
