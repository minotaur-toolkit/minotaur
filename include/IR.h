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
  type ty;
public:
  Inst(type t) : ty (t) {}
  type getType() { return ty; }
  virtual void print(std::ostream &os) const = 0;
  friend std::ostream& operator<<(std::ostream &os, const Inst &val);
  virtual ~Inst() {}
};

class Var final : public Inst {
  llvm::Value *v;
public:
  Var(llvm::Value *v) : Inst(v->getType()), v(v) {}
  void print(std::ostream &os) const override;
  llvm::Value *V () { return v; }
};

class ReservedConst final : public Inst {
  llvm::Argument *A;
public:
  ReservedConst(type t) : Inst(t) {}
  void print(std::ostream &os) const override;
  type T() { return ty; }
  llvm::Argument *getA () { return A; }
  void setA (llvm::Argument *Arg) { A = Arg; }
};

class UnaryInst final : public Inst {
public:
  enum Op { copy };
private:
  Op op;
  Inst *op0;
public:
  UnaryInst(Op op, Inst &op0)
  : Inst(/*fixme*/op0.getType()), op(op), op0(&op0) {}
  void print(std::ostream &os) const override;
  Inst *Op0() { return op0; }

  Op K() { return op; }
};

class BinaryInst final : public Inst {
public:
  enum Op { band, bor, bxor, add, sub, mul, sdiv, udiv, lshr, ashr, shl };
private:
  Op op;
  Inst *lhs;
  Inst *rhs;
public:
  BinaryInst(Op op, Inst &lhs, Inst &rhs)
  : Inst(lhs.getType()), op(op), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
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
  : /* fixme */Inst(lhs.getType()) , cond(cond), lhs(&lhs), rhs(&rhs) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  Cond K() { return cond; }
};

class BitCastInst final : public Inst {
  Inst *i;
  unsigned lanes_from, lanes_to;
  unsigned width_from, width_to;
public:
  BitCastInst(Inst &i, unsigned lf, unsigned wf, unsigned lt, unsigned wt)
  : /* fixme */Inst(i.getType()) {}

  void print(std::ostream &os) const override;
  Inst *I() { return i; }
};

class SIMDBinOpInst final : public Inst {
  X86IntrinBinOp::Op op;
  Inst *lhs;
  Inst *rhs;
public:
  SIMDBinOpInst(X86IntrinBinOp::Op op, Inst &lhs, Inst &rhs)
    : Inst(type(X86IntrinBinOp::shape_ret[op].first,
                X86IntrinBinOp::shape_ret[op].second,
                false)),
      op(op), lhs(&lhs), rhs(&rhs) {}
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
    : Inst(/*fixme*/lhs.getType()), lhs(&lhs), rhs(&rhs), mask(&mask) {}
  void print(std::ostream &os) const override;
  Inst *L() { return lhs; }
  Inst *R() { return rhs; }
  Inst *M() { return mask; }
};


/*
class Hole : Inst {
};

*/

union idx { Inst *ptr; unsigned idx; };
class Ptr final : public Inst {
  Inst *base;
  bool hasOffset = false;
public:
  Ptr(llvm::Value *p) : Inst(p->getType()) {}
  void print(std::ostream &os) const override;
};

class Load final : public Inst {
  Ptr *p;
public:
  Load(Ptr &p) : Inst(p.getType().getStrippedType()), p(&p) {}
  void print(std::ostream &os) const override;
};

class Store final : public Inst {
  Ptr *p;
  Inst *v;
public:
  Store(Ptr &p, Inst &v) : Inst(type(-1, -1, false)), p(&p), v(&v) {};
  void print(std::ostream &os) const override;
};

}