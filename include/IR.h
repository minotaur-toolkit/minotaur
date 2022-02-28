// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.
#pragma once

#include <Type.h>
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/ErrorHandling.h"
#include "ir/instr.h"

#include <vector>

using namespace IR;

namespace minotaur {

class Inst {
protected:
  std::string name;
  auto& getName() const { return name; }
  unsigned width;
public:
  Inst(unsigned width) : width (width) {}
  unsigned getWidth() { return width; }
  virtual void print(std::ostream &os) const = 0;
  friend std::ostream& operator<<(std::ostream &os, const Inst &val);
  virtual ~Inst() {}
};

class Var final : public Inst {
  llvm::Value *v;
public:
  Var(llvm::Value *v) : Inst(v->getType()->getPrimitiveSizeInBits()), v(v) {}
  void print(std::ostream &os) const override;
  llvm::Value *V () { return v; }
};


class ReservedConst final : public Inst {
  llvm::Argument *A;
  type ty;
public:
  ReservedConst(type t) : Inst(t.getWidth()), ty(t) {}
  type getType() { return ty; }
  void print(std::ostream &os) const override;
  llvm::Argument *getA () { return A; }
  void setA (llvm::Argument *Arg) { A = Arg; }
};


class CopyInst final : public Inst {
private:
  ReservedConst *rc;
public:
  CopyInst(ReservedConst &rc)
  : Inst(rc.getWidth()), rc(&rc) {}
  void print(std::ostream &os) const override;
  ReservedConst *Op0() { return rc; }
};


class BinaryInst final : public Inst {
public:
  enum Op { band, bor, bxor, add, sub, mul, sdiv, udiv, lshr, ashr, shl };
private:
  Op op;
  Inst *lhs;
  Inst *rhs;
  type workty;
public:
  static bool isLaneIndependent(Op op) {
    return op == band || op == bor || op == bxor;
  }
  BinaryInst(Op op, Inst &lhs, Inst &rhs, type &workty)
  : Inst(workty.getWidth()), op(op), lhs(&lhs), rhs(&rhs), workty(workty) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  type getWorkTy() {return workty; }
  Op K() { return op; }
  static bool isCommutative (Op k) {
    return k == Op::band || k == Op::bor || k == Op::bxor ||
           k == Op::add || k == Op::mul;
  }
};


class ICmpInst final : public Inst {
public:
  // syntactic pruning: less than/less equal only
  enum Cond { eq, ne, ult, ule, slt, sle};
private:
  Cond cond;
  Inst *lhs;
  Inst *rhs;
public:
  ICmpInst(Cond cond, Inst &lhs, Inst &rhs)
  : Inst(/*fixme*/1) , cond(cond), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  Cond K() { return cond; }
};


class SIMDBinOpInst final : public Inst {
  X86IntrinBinOp::Op op;
  Inst *lhs;
  Inst *rhs;
public:
  SIMDBinOpInst(X86IntrinBinOp::Op op, Inst &lhs, Inst &rhs, unsigned width)
    : Inst(width), op(op), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  X86IntrinBinOp::Op K() { return op; }
};


class ShuffleVectorInst final : public Inst {
  Inst *lhs;
  Inst *rhs;
  ReservedConst *mask;
public:
  ShuffleVectorInst(Inst &lhs, Inst &rhs, ReservedConst &mask)
    : Inst(-1), lhs(&lhs), rhs(&rhs), mask(&mask) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  Inst *M() { return mask; }
};


union idx { Inst *ptr; unsigned idx; };
class Addr final : public Inst {
  llvm::Value *base;
  bool hasOffset = false;
public:
  Addr(llvm::Value *p) : Inst(-1) {}
  void print(std::ostream &os) const override;
};


class VectorAddr final : public Inst {
  Inst *base;
  bool hasOffset = false;
public:
  VectorAddr(llvm::Value *p) : Inst(-1) {}
  void print(std::ostream &os) const override;
};


class Load final : public Inst {
  Addr *p;
public:
  Load(Addr &p) : Inst(-1), p(&p) {}
  void print(std::ostream &os) const override;
};


class Gather final : public Inst {
  VectorAddr *p;
public:
  Gather(VectorAddr &p) : Inst(-1), p(&p) {}
  void print(std::ostream &os) const override;
};


class Store final : public Inst {
  Addr *p;
  Inst *v;
public:
  Store(Addr &p, Inst &v) : Inst(-1), p(&p), v(&v) {};
  void print(std::ostream &os) const override;
};


class Scatter final : public Inst {
  VectorAddr *p;
public:
  Scatter(VectorAddr &p) : Inst(-1), p(&p) {}
  void print(std::ostream &os) const override;
};


}