// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "alive-interface.h"
#include "gtest/gtest.h"

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/Host.h"
#include "llvm/TargetParser/Triple.h"

#include <memory>
#include <string>
#include <string_view>

using namespace minotaur;

namespace {

struct CompareResult {
  std::unique_ptr<llvm::LLVMContext> Ctx;
  std::unique_ptr<llvm::Module> M;
  bool Good = false;
};

std::unique_ptr<llvm::Module> parseTestModule(
    llvm::LLVMContext &Ctx, std::string_view IR) {
  llvm::SMDiagnostic Err;
  auto M = llvm::parseIR(llvm::MemoryBufferRef(
                             llvm::StringRef(IR.data(), IR.size()),
                             "alive-compare-tests"),
                         Err, Ctx);
  if (!M) {
    std::string Msg;
    llvm::raw_string_ostream OS(Msg);
    Err.print("alive-compare-tests", OS);
    ADD_FAILURE() << OS.str();
    return nullptr;
  }

  if (M->getTargetTriple().empty())
    M->setTargetTriple(
        llvm::Triple(llvm::sys::getDefaultTargetTriple()));
  return M;
}

CompareResult compareFunctions(std::string_view IR, bool debug_tv = false) {
  CompareResult Result;
  Result.Ctx = std::make_unique<llvm::LLVMContext>();
  Result.M = parseTestModule(*Result.Ctx, IR);
  if (!Result.M)
    return Result;

  auto *Src = Result.M->getFunction("src");
  auto *Tgt = Result.M->getFunction("tgt");
  if (!Src || !Tgt) {
    ADD_FAILURE() << "missing @src or @tgt";
    return Result;
  }

  llvm::TargetLibraryInfoWrapperPass TLI(
      llvm::Triple(Result.M->getTargetTriple()));
  bool OldDebug = minotaur::config::debug_tv;
  minotaur::config::debug_tv = debug_tv;
  AliveEngine AE(TLI);
  Result.Good = AE.compareFunctions(*Src, *Tgt);
  minotaur::config::debug_tv = OldDebug;
  return Result;
}

TEST(AliveCompareFunctionsTest, RejectsSelectRewriteThatDropsUndefSensitiveArm) {
  constexpr char IR[] = R"(
define i1 @src(i1 %a, i1 %b, i8 %x, i1 %sel) {
entry:
  %c0 = select i1 %sel, i32 1, i32 3
  %p = and i1 %a, %b
  %v0 = select i1 %p, i32 %c0, i32 2
  %v1 = or disjoint i32 %v0, 8
  %neg = icmp slt i8 %x, 0
  %v2 = select i1 %neg, i32 %v1, i32 %v0
  %v3 = and i32 %v2, 3
  %r = icmp eq i32 %v3, 1
  ret i1 %r
}

define i1 @tgt(i1 %a, i1 %b, i8 %x, i1 %sel) {
entry:
  %p = and i1 %a, %b
  %r = select i1 %p, i1 %sel, i1 %p
  ret i1 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_FALSE(Result.Good);
}

TEST(AliveCompareFunctionsTest, AcceptsValidXorBooleanRewrite) {
  constexpr char IR[] = R"(
define i1 @src(i1 %p, i32 %x) {
entry:
  %c0 = icmp ne i32 %x, 22
  %c1 = icmp ne i32 %x, 20
  %u = or i1 %c1, %p
  %v = and i1 %c0, %u
  %r = xor i1 %v, true
  ret i1 %r
}

define i1 @tgt(i1 %p, i32 %x) {
entry:
  %c0 = icmp ne i32 %x, 22
  %c1 = icmp ne i32 %x, 20
  %u = or i1 %c1, %p
  %r = xor i1 %c0, %u
  ret i1 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_TRUE(Result.Good);
}

TEST(AliveCompareFunctionsTest, AcceptsValidSelectRewriteWithFalseArm) {
  constexpr char IR[] = R"(
define i1 @src(i1 %a, i1 %b, i8 %x, i1 %sel) {
entry:
  %c0 = select i1 %sel, i32 1, i32 3
  %p = and i1 %a, %b
  %v0 = select i1 %p, i32 %c0, i32 2
  %v1 = or disjoint i32 %v0, 8
  %neg = icmp slt i8 %x, 0
  %v2 = select i1 %neg, i32 %v1, i32 %v0
  %v3 = and i32 %v2, 3
  %r = icmp eq i32 %v3, 1
  ret i1 %r
}

define i1 @tgt(i1 %a, i1 %b, i8 %x, i1 %sel) {
entry:
  %p = and i1 %a, %b
  %r = select i1 %p, i1 %sel, i1 false
  ret i1 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_TRUE(Result.Good);
}

TEST(AliveCompareFunctionsTest, AcceptsUmaxOverflowFoldForSmallConstant) {
  constexpr char IR[] = R"(
declare i64 @llvm.umax.i64(i64, i64)

define i1 @src(i64 %x) {
entry:
  %m = call i64 @llvm.umax.i64(i64 %x, i64 1)
  %n = xor i64 %x, -1
  %r = icmp ugt i64 %m, %n
  ret i1 %r
}

define i1 @tgt(i64 %x) {
entry:
  %r = icmp slt i64 %x, 0
  ret i1 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_TRUE(Result.Good);
}

TEST(AliveCompareFunctionsTest, AcceptsExactSdivThresholdFold) {
  constexpr char IR[] = R"(
define i1 @src(i64 %x) {
entry:
  %q = sdiv exact i64 %x, 24
  %r = icmp ugt i64 %q, 4611686018427387903
  ret i1 %r
}

define i1 @tgt(i64 %x) {
entry:
  %r = icmp slt i64 %x, -7
  ret i1 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_TRUE(Result.Good);
}

TEST(AliveCompareFunctionsTest, AcceptsSamesignCompareFromTruncNuwBoolean) {
  constexpr char IR[] = R"(
define i1 @src(i8 %x) {
entry:
  %b = trunc nuw i8 %x to i1
  %r = xor i1 %b, true
  ret i1 %r
}

define i1 @tgt(i8 %x) {
entry:
  %r = icmp samesign ult i8 %x, 1
  ret i1 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_TRUE(Result.Good);
}

TEST(AliveCompareFunctionsTest, AcceptsArithmeticNegationOfSubtraction) {
  constexpr char IR[] = R"(
define i32 @src(i32 %a, i32 %b) {
entry:
  %d = sub nsw i32 %a, %b
  %r = sub nsw i32 0, %d
  ret i32 %r
}

define i32 @tgt(i32 %a, i32 %b) {
entry:
  %r = sub i32 %b, %a
  ret i32 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_TRUE(Result.Good);
}

TEST(AliveCompareFunctionsTest, AcceptsFloatingPointThresholdCollapse) {
  constexpr char IR[] = R"(
define i1 @src(double %x) {
entry:
  %c0 = fcmp oge double %x, 0.000000e+00
  %c1 = fcmp oge double %x, 1.481000e+00
  %r = or i1 %c0, %c1
  ret i1 %r
}

define i1 @tgt(double %x) {
entry:
  %r = fcmp ogt double %x, 0x8000000000000001
  ret i1 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_TRUE(Result.Good);
}

TEST(AliveCompareFunctionsTest, AcceptsExactAshrThresholdFold) {
  constexpr char IR[] = R"(
define i1 @src(i64 %x) {
entry:
  %q = ashr exact i64 %x, 3
  %r = icmp sgt i64 %q, 7
  ret i1 %r
}

define i1 @tgt(i64 %x) {
entry:
  %r = icmp sgt i64 %x, 56
  ret i1 %r
}
)";

  auto Result = compareFunctions(IR);
  EXPECT_TRUE(Result.Good);
}

} // namespace
