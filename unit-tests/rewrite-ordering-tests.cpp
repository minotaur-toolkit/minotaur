// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "gtest/gtest.h"
#include "parse.h"
#include "rewrite-ordering.h"

#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>
#include <string>
#include <string_view>
#include <vector>

using namespace minotaur;

namespace {

constexpr char I64OrderingIR[] = R"(
define i64 @test(i64 %x, i64 %y, i64 %z) {
entry:
  %root = add i64 %x, %y
  ret i64 %root
}
)";

constexpr char I1OrderingIR[] = R"(
define i1 @test(i64 %x, i64 %y, i64 %z) {
entry:
  %root = icmp eq i64 %x, %y
  ret i1 %root
}
)";

std::unique_ptr<llvm::Module> parseTestModule(
    llvm::LLVMContext &Ctx, std::string_view IR) {
  llvm::SMDiagnostic Err;
  auto M = llvm::parseIR(
      llvm::MemoryBufferRef(llvm::StringRef(IR.data(), IR.size()),
                            "rewrite-ordering-tests"),
      Err, Ctx);
  if (M)
    return M;

  std::string Msg;
  llvm::raw_string_ostream OS(Msg);
  Err.print("rewrite-ordering-tests", OS);
  ADD_FAILURE() << OS.str();
  return nullptr;
}

struct ParsedRewrite {
  std::unique_ptr<llvm::LLVMContext> Ctx;
  std::unique_ptr<llvm::Module> M;
  std::unique_ptr<parse::Parser> P;
  std::vector<Rewrite> Rewrites;

  const Inst &inst() const {
    return *Rewrites[0].I;
  }
};

ParsedRewrite parseRewrite(std::string_view IR, std::string_view Text) {
  ParsedRewrite Result;
  Result.Ctx = std::make_unique<llvm::LLVMContext>();
  Result.M = parseTestModule(*Result.Ctx, IR);
  if (!Result.M)
    return Result;

  auto *F = Result.M->getFunction("test");
  if (!F) {
    ADD_FAILURE() << "missing @test function";
    return Result;
  }

  Result.P = std::make_unique<parse::Parser>(*F);
  Result.Rewrites = Result.P->parse(*F, Text);
  if (Result.Rewrites.size() != 1u)
    ADD_FAILURE() << "expected exactly one parsed rewrite for " << Text;
  if (Result.Rewrites.empty() || Result.Rewrites[0].I == nullptr)
    ADD_FAILURE() << "missing parsed instruction for " << Text;
  return Result;
}

TEST(RewriteOrderingTest, PrefersFewerSynthesizedConstants) {
  auto VarsOnly = parseRewrite(
      I64OrderingIR,
      "(add i64 (var i64 %x) (var i64 %y))");
  auto WithConst = parseRewrite(
      I64OrderingIR,
      "(add i64 (var i64 %x) (reservedconst i64 |i64 0|))");

  ASSERT_EQ(VarsOnly.Rewrites.size(), 1u);
  ASSERT_EQ(WithConst.Rewrites.size(), 1u);

  auto VarsOnlyKey = analyzeInstOrdering(VarsOnly.inst());
  auto WithConstKey = analyzeInstOrdering(WithConst.inst());
  EXPECT_EQ(VarsOnlyKey.ReservedConsts, 0u);
  EXPECT_EQ(WithConstKey.ReservedConsts, 1u);
  EXPECT_TRUE(preferInstForSameCost(VarsOnly.inst(), WithConst.inst()));
  EXPECT_FALSE(preferInstForSameCost(WithConst.inst(), VarsOnly.inst()));
}

TEST(RewriteOrderingTest, PrefersSameSignIcmpWhenCostsTie) {
  auto Plain = parseRewrite(
      I1OrderingIR,
      "(icmp_ult (var i64 %x) (var i64 %y) b1)");
  auto SameSign = parseRewrite(
      I1OrderingIR,
      "(icmp_samesign_ult (var i64 %x) (var i64 %y) b1)");

  ASSERT_EQ(Plain.Rewrites.size(), 1u);
  ASSERT_EQ(SameSign.Rewrites.size(), 1u);

  auto PlainKey = analyzeInstOrdering(Plain.inst());
  auto SameSignKey = analyzeInstOrdering(SameSign.inst());
  EXPECT_EQ(PlainKey.ReservedConsts, SameSignKey.ReservedConsts);
  EXPECT_EQ(PlainKey.NodeCount, SameSignKey.NodeCount);
  EXPECT_EQ(PlainKey.SameSignICmps, 0u);
  EXPECT_EQ(SameSignKey.SameSignICmps, 1u);
  EXPECT_TRUE(preferInstForSameCost(SameSign.inst(), Plain.inst()));
  EXPECT_FALSE(preferInstForSameCost(Plain.inst(), SameSign.inst()));
}

TEST(RewriteOrderingTest, PrefersSmallerRhsWhenOtherSignalsTie) {
  auto Smaller = parseRewrite(
      I64OrderingIR,
      "(xor i64 (var i64 %x) (var i64 %y))");
  auto Larger = parseRewrite(
      I64OrderingIR,
      "(xor i64 (xor i64 (var i64 %x) (var i64 %y)) (var i64 %z))");

  ASSERT_EQ(Smaller.Rewrites.size(), 1u);
  ASSERT_EQ(Larger.Rewrites.size(), 1u);

  auto SmallerKey = analyzeInstOrdering(Smaller.inst());
  auto LargerKey = analyzeInstOrdering(Larger.inst());
  EXPECT_EQ(SmallerKey.ReservedConsts, LargerKey.ReservedConsts);
  EXPECT_EQ(SmallerKey.SameSignICmps, LargerKey.SameSignICmps);
  EXPECT_LT(SmallerKey.NodeCount, LargerKey.NodeCount);
  EXPECT_TRUE(preferInstForSameCost(Smaller.inst(), Larger.inst()));
  EXPECT_FALSE(preferInstForSameCost(Larger.inst(), Smaller.inst()));
}

TEST(RewriteOrderingTest, EquivalentKeysStayNeutral) {
  auto Left = parseRewrite(
      I64OrderingIR,
      "(add i64 (var i64 %x) (var i64 %y))");
  auto Right = parseRewrite(
      I64OrderingIR,
      "(add i64 (var i64 %x) (var i64 %y))");

  ASSERT_EQ(Left.Rewrites.size(), 1u);
  ASSERT_EQ(Right.Rewrites.size(), 1u);
  EXPECT_FALSE(preferInstForSameCost(Left.inst(), Right.inst()));
  EXPECT_FALSE(preferInstForSameCost(Right.inst(), Left.inst()));
}

} // namespace
