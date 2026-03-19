// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "gtest/gtest.h"
#include "interp.h"

#include "llvm/ADT/APInt.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/LLVMContext.h"

#include <unordered_map>

using namespace minotaur;

namespace {

llvm::APInt i1(bool V) {
  return llvm::APInt(1, V ? 1u : 0u);
}

llvm::APInt i8(unsigned V) {
  return llvm::APInt(8, V);
}

llvm::APInt i32(uint64_t V) {
  return llvm::APInt(32, V);
}

llvm::APInt si32(int64_t V) {
  return llvm::APInt(32, static_cast<uint64_t>(V), true);
}

TEST(InterpreterTest, EvaluatesIntegerExpressions) {
  Var X("x", type::Integer(32));
  Var Y("y", type::Integer(32));
  type I32 = type::Integer(32);
  UnaryOp Bswap(UnaryOp::bswap, X, I32);
  BinaryOp Expr(BinaryOp::add, Bswap, Y, I32);

  Interpreter Interp;
  Interp.bind(&X, i32(0x12345678));
  Interp.bind(&Y, i32(3));

  auto Result = Interp.eval(&Expr);
  ASSERT_TRUE(Result.has_value());
  EXPECT_EQ(*Result, i32(0x78563412u + 3u));
}

TEST(InterpreterTest, EvaluatesSelectAndIntConversions) {
  Var Cond("c", type::Integer(1));
  Var X("x", type::Integer(8));
  Var Y("y", type::Integer(8));
  IntConversion ZX(IntConversion::zext, X, 1, 8, 16);
  IntConversion SY(IntConversion::sext, Y, 1, 8, 16);
  Select Expr(Cond, ZX, SY);

  Interpreter Interp;
  Interp.bind(&Cond, i1(false));
  Interp.bind(&X, i8(7));
  Interp.bind(&Y, i8(0xFE));

  auto Result = Interp.eval(&Expr);
  ASSERT_TRUE(Result.has_value());
  EXPECT_EQ(*Result, llvm::APInt(16, static_cast<uint64_t>(-2), true));
}

TEST(InterpreterTest, EvaluatesSameSignCompareAndRejectsMixedSigns) {
  Var X("x", type::Integer(32));
  Var Y("y", type::Integer(32));
  ICmp SameSignUlt(ICmp::ult, X, Y, 1, true);

  Interpreter GoodInterp;
  GoodInterp.bind(&X, si32(3));
  GoodInterp.bind(&Y, si32(5));
  auto Good = GoodInterp.eval(&SameSignUlt);
  ASSERT_TRUE(Good.has_value());
  EXPECT_EQ(*Good, i1(true));

  Interpreter BadInterp;
  BadInterp.bind(&X, si32(-1));
  BadInterp.bind(&Y, si32(5));
  EXPECT_FALSE(BadInterp.eval(&SameSignUlt).has_value());
}

TEST(InterpreterTest, RejectsVectorSameSignCompare) {
  Var X("x", type::IntegerVectorizable(2, 16));
  Var Y("y", type::IntegerVectorizable(2, 16));
  ICmp SameSignUlt(ICmp::ult, X, Y, 2, true);

  Interpreter Interp;
  Interp.bind(&X, i32(0x00010002));
  Interp.bind(&Y, i32(0x00030004));
  EXPECT_FALSE(Interp.eval(&SameSignUlt).has_value());
}

TEST(InterpreterTest, ReturnsNulloptForUnsupportedFpConversions) {
  Var X("x", type::Integer(32));
  type FloatTy = type::Float();
  FPConversion Expr(FPConversion::sitofp, X, FloatTy);

  Interpreter Interp;
  Interp.bind(&X, i32(11));
  EXPECT_FALSE(Interp.eval(&Expr).has_value());
}

TEST(InterpreterTest, SolvesReservedConstantThroughAdd) {
  Var X("x", type::Integer(32));
  ReservedConst RC(type::Integer(32));
  Copy C(RC);
  type I32 = type::Integer(32);
  BinaryOp Expr(BinaryOp::add, X, C, I32);

  Interpreter Interp;
  Interp.bind(&X, i32(10));

  std::unordered_map<ReservedConst*, llvm::APInt> Solution;
  ASSERT_TRUE(Interp.solveForConstants(&Expr, i32(42), Solution));
  ASSERT_EQ(Solution.size(), 1u);
  EXPECT_EQ(Solution[&RC], i32(32));
}

TEST(InterpreterTest, SolvesReservedConstantThroughShift) {
  llvm::LLVMContext Ctx;
  ReservedConst RC(type::Integer(32));
  Copy C(RC);
  ReservedConst ShiftRC(type::Integer(32),
                        llvm::ConstantInt::get(
                            llvm::IntegerType::get(Ctx, 32),
                            2));
  Copy Shift(ShiftRC);
  type I32 = type::Integer(32);
  BinaryOp Expr(BinaryOp::shl, C, Shift, I32);

  Interpreter Interp;
  std::unordered_map<ReservedConst*, llvm::APInt> Solution;
  ASSERT_TRUE(Interp.solveForConstants(&Expr, i32(20), Solution));
  ASSERT_EQ(Solution.size(), 1u);
  EXPECT_EQ(Solution[&RC], i32(5));
}

TEST(InterpreterTest, RejectsUnsatisfiableMultiplicationSolve) {
  Var X("x", type::Integer(32));
  ReservedConst RC(type::Integer(32));
  Copy C(RC);
  type I32 = type::Integer(32);
  BinaryOp Expr(BinaryOp::mul, X, C, I32);

  Interpreter Interp;
  Interp.bind(&X, i32(6));

  std::unordered_map<ReservedConst*, llvm::APInt> Solution;
  EXPECT_FALSE(Interp.solveForConstants(&Expr, i32(20), Solution));
}

} // namespace
