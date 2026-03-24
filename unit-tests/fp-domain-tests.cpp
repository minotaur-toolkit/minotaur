// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "gtest/gtest.h"

#include "fp-domain.h"

#include "llvm/IR/Instruction.h"
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

std::unique_ptr<llvm::Module> parseTestModule(
    llvm::LLVMContext &Ctx, std::string_view IR) {
  llvm::SMDiagnostic Err;
  auto M = llvm::parseIR(
      llvm::MemoryBufferRef(llvm::StringRef(IR.data(), IR.size()),
                            "fp-domain-tests"),
      Err, Ctx);
  if (M)
    return M;

  std::string Msg;
  llvm::raw_string_ostream OS(Msg);
  Err.print("fp-domain-tests", OS);
  ADD_FAILURE() << OS.str();
  return nullptr;
}

llvm::Instruction *findInstByName(llvm::Function &F, llvm::StringRef Name) {
  for (auto &BB : F)
    for (auto &I : BB)
      if (I.getName() == Name)
        return &I;
  return nullptr;
}

constexpr char MaxnumCastSandwichIR[] = R"(
declare float @llvm.maxnum.f32(float, float)

define half @test(half %x, half %y) {
entry:
  %x.ext = fpext half %x to float
  %y.ext = fpext half %y to float
  %maxnum = call float @llvm.maxnum.f32(float %x.ext, float %y.ext)
  %trunc = fptrunc float %maxnum to half
  ret half %trunc
}
)";

constexpr char FreshFPIR[] = R"(
define half @test(half %x, half %y) {
entry:
  %x.ext = fpext half %x to float
  %y.ext = fpext half %y to float
  %sum = fadd float %x.ext, %y.ext
  %trunc = fptrunc float %sum to half
  ret half %trunc
}
)";

TEST(FPDomainTest, IRMaxnumCastSandwichIsSelector) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, MaxnumCastSandwichIR);
  ASSERT_TRUE(M);
  auto *F = M->getFunction("test");
  ASSERT_NE(F, nullptr);
  auto *I = findInstByName(*F, "trunc");
  ASSERT_NE(I, nullptr);

  auto D = analyzeFPValueDomain(*I);
  EXPECT_TRUE(D.IsFP);
  EXPECT_EQ(D.Origin, FPOriginKind::Selector);
  EXPECT_EQ(D.DistinctLeaves, 2u);
}

TEST(FPDomainTest, IRArithmeticCastSandwichIsFresh) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, FreshFPIR);
  ASSERT_TRUE(M);
  auto *F = M->getFunction("test");
  ASSERT_NE(F, nullptr);
  auto *I = findInstByName(*F, "trunc");
  ASSERT_NE(I, nullptr);

  auto D = analyzeFPValueDomain(*I);
  EXPECT_TRUE(D.IsFP);
  EXPECT_EQ(D.Origin, FPOriginKind::Fresh);
  EXPECT_EQ(D.DistinctLeaves, 0u);
}

TEST(FPDomainTest, ASTFMaxnumIsSelector) {
  type HalfTy = type::Half();
  Var X("%x", HalfTy);
  Var Y("%y", HalfTy);
  BinaryOp Max(BinaryOp::fmaxnum, X, Y, HalfTy);

  auto D = analyzeFPValueDomain(Max);
  EXPECT_TRUE(D.IsFP);
  EXPECT_EQ(D.Origin, FPOriginKind::Selector);
  EXPECT_EQ(D.DistinctLeaves, 2u);
}

TEST(FPDomainTest, ASTFAddIsFresh) {
  type HalfTy = type::Half();
  Var X("%x", HalfTy);
  Var Y("%y", HalfTy);
  BinaryOp Add(BinaryOp::fadd, X, Y, HalfTy);

  auto D = analyzeFPValueDomain(Add);
  EXPECT_TRUE(D.IsFP);
  EXPECT_EQ(D.Origin, FPOriginKind::Fresh);
  EXPECT_EQ(D.DistinctLeaves, 0u);
}

TEST(FPDomainTest, ASTDoubleNegationReturnsSelector) {
  type HalfTy = type::Half();
  Var X("%x", HalfTy);
  UnaryOp Neg0(UnaryOp::fneg, X, HalfTy);
  UnaryOp Neg1(UnaryOp::fneg, Neg0, HalfTy);

  auto D = analyzeFPValueDomain(Neg1);
  EXPECT_TRUE(D.IsFP);
  EXPECT_EQ(D.Origin, FPOriginKind::Selector);
  EXPECT_EQ(D.DistinctLeaves, 1u);
}

TEST(FPDomainTest, ContradictionOnlyForSelectorVersusFresh) {
  type HalfTy = type::Half();
  Var X("%x", HalfTy);
  Var Y("%y", HalfTy);
  BinaryOp Max(BinaryOp::fmaxnum, X, Y, HalfTy);
  BinaryOp Add(BinaryOp::fadd, X, Y, HalfTy);
  ReservedConst RC(HalfTy);
  Copy Const(RC);

  auto Src = analyzeFPValueDomain(Max);
  auto Fresh = analyzeFPValueDomain(Add);
  auto Unknown = analyzeFPValueDomain(Const);

  EXPECT_TRUE(fpDomainsContradict(Src, Fresh));
  EXPECT_FALSE(fpDomainsContradict(Src, Unknown));
}

TEST(FPDomainTest, ProvesMaxnumTransportEquivalence) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, MaxnumCastSandwichIR);
  ASSERT_TRUE(M);
  auto *F = M->getFunction("test");
  ASSERT_NE(F, nullptr);
  auto *I = findInstByName(*F, "trunc");
  ASSERT_NE(I, nullptr);

  type HalfTy = type::Half();
  Var X("%x", HalfTy);
  Var Y("%y", HalfTy);
  BinaryOp Max(BinaryOp::fmaxnum, X, Y, HalfTy);

  EXPECT_TRUE(proveFPTransportEquivalent(*I, Max));
}

TEST(FPDomainTest, ProvesMinnumTransportEquivalence) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, R"(
declare float @llvm.minnum.f32(float, float)

define half @test(half %x, half %y) {
entry:
  %x.ext = fpext half %x to float
  %y.ext = fpext half %y to float
  %minnum = call float @llvm.minnum.f32(float %x.ext, float %y.ext)
  %trunc = fptrunc float %minnum to half
  ret half %trunc
}
)");
  ASSERT_TRUE(M);
  auto *F = M->getFunction("test");
  ASSERT_NE(F, nullptr);
  auto *I = findInstByName(*F, "trunc");
  ASSERT_NE(I, nullptr);

  type HalfTy = type::Half();
  Var X("%x", HalfTy);
  Var Y("%y", HalfTy);
  BinaryOp Min(BinaryOp::fminnum, X, Y, HalfTy);

  EXPECT_TRUE(proveFPTransportEquivalent(*I, Min));
}

TEST(FPDomainTest, RejectsMaximumAsTransportMismatch) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, MaxnumCastSandwichIR);
  ASSERT_TRUE(M);
  auto *F = M->getFunction("test");
  ASSERT_NE(F, nullptr);
  auto *I = findInstByName(*F, "trunc");
  ASSERT_NE(I, nullptr);

  type HalfTy = type::Half();
  Var X("%x", HalfTy);
  Var Y("%y", HalfTy);
  BinaryOp Max(BinaryOp::fmaximum, X, Y, HalfTy);

  EXPECT_EQ(classifyFPTransportRelation(*I, Max),
            FPTransportRelation::Inequivalent);
}

TEST(FPDomainTest, RejectsLeafAsTransportMismatch) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, MaxnumCastSandwichIR);
  ASSERT_TRUE(M);
  auto *F = M->getFunction("test");
  ASSERT_NE(F, nullptr);
  auto *I = findInstByName(*F, "trunc");
  ASSERT_NE(I, nullptr);

  type HalfTy = type::Half();
  Var X("%x", HalfTy);

  EXPECT_EQ(classifyFPTransportRelation(*I, X),
            FPTransportRelation::Inequivalent);
}

TEST(FPDomainTest, RejectsSingleSourceLeafSupportMismatch) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, MaxnumCastSandwichIR);
  ASSERT_TRUE(M);
  auto *F = M->getFunction("test");
  ASSERT_NE(F, nullptr);
  auto *I = findInstByName(*F, "trunc");
  auto *XExt = findInstByName(*F, "x.ext");
  ASSERT_NE(I, nullptr);
  ASSERT_NE(XExt, nullptr);

  Var XExtVar(XExt);
  type HalfTy = type::Half();
  FPConversion Trunc(FPConversion::fptrunc, XExtVar, HalfTy);

  EXPECT_EQ(classifyFPTransportRelation(*I, Trunc),
            FPTransportRelation::Inequivalent);
}

} // namespace
