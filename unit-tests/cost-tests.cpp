// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "cost.h"
#include "gtest/gtest.h"

#include "llvm/IR/Function.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>
#include <string>
#include <string_view>

using namespace minotaur;

namespace {

constexpr char IdentityIR[] = R"(
define i64 @test(i64 %x) {
entry:
  ret i64 %x
}
)";

constexpr char ArithmeticChainIR[] = R"(
define i64 @test(i64 %x, i64 %y) {
entry:
  %a = add i64 %x, %y
  %b = xor i64 %a, 42
  %c = shl i64 %b, 3
  ret i64 %c
}
)";

constexpr char AddXYIR[] = R"(
define i64 @test(i64 %x, i64 %y) {
entry:
  %r = add i64 %x, %y
  ret i64 %r
}
)";

constexpr char AddYXIR[] = R"(
define i64 @test(i64 %x, i64 %y) {
entry:
  %r = add i64 %y, %x
  ret i64 %r
}
)";

constexpr char LiveBswapIR[] = R"(
declare i64 @llvm.bswap.i64(i64)

define i64 @test(i64 %x) {
entry:
  %r = call i64 @llvm.bswap.i64(i64 %x)
  ret i64 %r
}
)";

constexpr char DeadBswapIR[] = R"(
declare i64 @llvm.bswap.i64(i64)

define i64 @test(i64 %x) {
entry:
  %dead = call i64 @llvm.bswap.i64(i64 %x)
  ret i64 %x
}
)";

constexpr char DivisionIR[] = R"(
define i64 @test(i64 %x, i64 %y) {
entry:
  %den = or i64 %y, 1
  %q = udiv i64 %x, %den
  ret i64 %q
}
)";

constexpr char ExternalCallIR[] = R"(
declare i64 @ext(i64)

define i64 @test(i64 %x) {
entry:
  %r = call i64 @ext(i64 %x)
  ret i64 %r
}
)";

std::unique_ptr<llvm::Module> parseTestModule(llvm::LLVMContext &Ctx,
                                              std::string_view IR) {
  llvm::SMDiagnostic Err;
  auto M = llvm::parseIR(llvm::MemoryBufferRef(
                             llvm::StringRef(IR.data(), IR.size()),
                             "cost-tests"),
                         Err, Ctx);
  if (M)
    return M;

  std::string Msg;
  llvm::raw_string_ostream OS(Msg);
  Err.print("cost-tests", OS);
  ADD_FAILURE() << OS.str();
  return nullptr;
}

llvm::Function *getTestFunction(llvm::Module &M) {
  auto *F = M.getFunction("test");
  if (!F)
    ADD_FAILURE() << "missing @test function";
  return F;
}

unsigned machineCostFor(std::string_view IR) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, IR);
  if (!M)
    return 0;

  auto *F = getTestFunction(*M);
  if (!F)
    return 0;

  return get_machine_cost(F);
}

unsigned approxCostFor(std::string_view IR) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, IR);
  if (!M)
    return 0;

  auto *F = getTestFunction(*M);
  if (!F)
    return 0;

  return get_approx_cost(F);
}

TEST(CostTest, LoweredAssemblyCostDoesNotFallBackForIdentity) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, IdentityIR);
  ASSERT_NE(M, nullptr);

  auto *F = getTestFunction(*M);
  ASSERT_NE(F, nullptr);

  EXPECT_EQ(get_approx_cost(F), 0u);
  EXPECT_GT(get_machine_cost(F), 0u);
}

TEST(CostTest, MoreLoweredOperationsCostMoreThanIdentity) {
  const unsigned IdentityCost = machineCostFor(IdentityIR);
  const unsigned ChainCost = machineCostFor(ArithmeticChainIR);

  EXPECT_GT(IdentityCost, 0u);
  EXPECT_GT(ChainCost, IdentityCost);
}

TEST(CostTest, CommutedAddHasSameMachineCost) {
  const unsigned AddXYCost = machineCostFor(AddXYIR);
  const unsigned AddYXCost = machineCostFor(AddYXIR);

  EXPECT_GT(AddXYCost, 0u);
  EXPECT_EQ(AddXYCost, AddYXCost);
}

TEST(CostTest, DeadPureIntrinsicDoesNotIncreaseMachineCost) {
  const unsigned IdentityCost = machineCostFor(IdentityIR);
  const unsigned DeadBswapCost = machineCostFor(DeadBswapIR);

  EXPECT_GT(IdentityCost, 0u);
  EXPECT_EQ(DeadBswapCost, IdentityCost);
}

TEST(CostTest, LivePureIntrinsicCostsMoreThanIdentity) {
  const unsigned IdentityCost = machineCostFor(IdentityIR);
  const unsigned LiveBswapCost = machineCostFor(LiveBswapIR);

  EXPECT_GT(IdentityCost, 0u);
  EXPECT_GT(LiveBswapCost, IdentityCost);
}

TEST(CostTest, DivisionCostsMoreThanSimpleArithmeticChain) {
  const unsigned ChainCost = machineCostFor(ArithmeticChainIR);
  const unsigned DivCost = machineCostFor(DivisionIR);

  EXPECT_GT(ChainCost, 0u);
  EXPECT_GT(DivCost, ChainCost);
}

TEST(CostTest, ExternalCallCostsMoreThanIdentity) {
  const unsigned IdentityCost = machineCostFor(IdentityIR);
  const unsigned CallCost = machineCostFor(ExternalCallIR);

  EXPECT_GT(IdentityCost, 0u);
  EXPECT_GT(CallCost, IdentityCost);
}

TEST(CostTest, DeadPureIntrinsicStillCountsInApproxCost) {
  EXPECT_EQ(approxCostFor(IdentityIR), 0u);
  EXPECT_GT(approxCostFor(DeadBswapIR), 0u);
}

} // namespace
