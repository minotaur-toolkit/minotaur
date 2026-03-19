// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "alive-interface.h"
#include "gtest/gtest.h"

#include "llvm/IR/Argument.h"
#include "llvm/IR/Constants.h"
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
#include <unordered_map>

using namespace minotaur;

namespace {

struct SynthesisResult {
  std::unique_ptr<llvm::LLVMContext> Ctx;
  std::unique_ptr<llvm::Module> M;
  std::unordered_map<std::string, llvm::Constant*> Consts;
  bool Good = false;
};

std::unique_ptr<llvm::Module> parseTestModule(
    llvm::LLVMContext &Ctx, std::string_view IR) {
  llvm::SMDiagnostic Err;
  auto M = llvm::parseIR(llvm::MemoryBufferRef(
                             llvm::StringRef(IR.data(), IR.size()),
                             "alive-tests"),
                         Err, Ctx);
  if (!M) {
    std::string Msg;
    llvm::raw_string_ostream OS(Msg);
    Err.print("alive-tests", OS);
    ADD_FAILURE() << OS.str();
    return nullptr;
  }

  if (M->getTargetTriple().empty())
    M->setTargetTriple(
        llvm::Triple(llvm::sys::getDefaultTargetTriple()));
  return M;
}

SynthesisResult synthesizeConstants(std::string_view IR, bool debug_tv = false) {
  SynthesisResult Result;
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
  std::unordered_map<llvm::Argument*, llvm::Constant*> ConstMap;
  Result.Good = AE.constantSynthesis(*Src, *Tgt, ConstMap);
  minotaur::config::debug_tv = OldDebug;

  for (auto &[Arg, C] : ConstMap)
    Result.Consts.emplace(Arg->getName().str(), C);
  return Result;
}

llvm::Constant *getSynthesizedConst(const SynthesisResult &Result,
                                    std::string_view Name = "_reservedc") {
  auto It = Result.Consts.find(std::string(Name));
  if (It == Result.Consts.end()) {
    ADD_FAILURE() << "missing synthesized constant for " << Name;
    return nullptr;
  }
  return It->second;
}

TEST(AliveConstantSynthesisTest, SynthesizesSimpleFloatConstant) {
  constexpr char IR[] = R"(
define float @src(float %x, float %_reservedc) {
entry:
  ret float 2.000000e+00
}

define float @tgt(float %x, float %_reservedc) {
entry:
  ret float %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  ASSERT_TRUE(Result.Good);

  ASSERT_EQ(Result.Consts.size(), 1u);
  auto *C = getSynthesizedConst(Result);
  ASSERT_FALSE(llvm::isa<llvm::PoisonValue>(C));
  auto *CF = llvm::dyn_cast<llvm::ConstantFP>(C);
  ASSERT_NE(CF, nullptr);
  EXPECT_TRUE(CF->getValueAPF().bitwiseIsEqual(llvm::APFloat(2.0f)));
}

TEST(AliveConstantSynthesisTest, SynthesizesSimpleIntegerConstant) {
  constexpr char IR[] = R"(
define i32 @src(i32 %x, i32 %_reservedc) {
entry:
  ret i32 42
}

define i32 @tgt(i32 %x, i32 %_reservedc) {
entry:
  ret i32 %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  ASSERT_TRUE(Result.Good);

  auto *C = getSynthesizedConst(Result);
  auto *CI = llvm::dyn_cast<llvm::ConstantInt>(C);
  ASSERT_NE(CI, nullptr);
  EXPECT_EQ(CI->getSExtValue(), 42);
}

TEST(AliveConstantSynthesisTest, SynthesizesBranchPhiIntegerConstant) {
  constexpr char IR[] = R"(
define i64 @src(i1 %cond, i64 %_reservedc) {
entry:
  br i1 %cond, label %left, label %right

left:
  br label %merge

right:
  br label %merge

merge:
  %v = phi i64 [ 17, %left ], [ 17, %right ]
  ret i64 %v
}

define i64 @tgt(i1 %cond, i64 %_reservedc) {
entry:
  ret i64 %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  ASSERT_TRUE(Result.Good);

  auto *C = getSynthesizedConst(Result);
  auto *CI = llvm::dyn_cast<llvm::ConstantInt>(C);
  ASSERT_NE(CI, nullptr);
  EXPECT_EQ(CI->getSExtValue(), 17);
}

TEST(AliveConstantSynthesisTest, SynthesizesBranchPhiFloatConstant) {
  constexpr char IR[] = R"(
define float @src(i1 %cond, float %_reservedc) {
entry:
  br i1 %cond, label %left, label %right

left:
  br label %merge

right:
  br label %merge

merge:
  %v = phi float [ -1.250000e+00, %left ], [ -1.250000e+00, %right ]
  ret float %v
}

define float @tgt(i1 %cond, float %_reservedc) {
entry:
  ret float %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  ASSERT_TRUE(Result.Good);

  auto *C = getSynthesizedConst(Result);
  auto *CF = llvm::dyn_cast<llvm::ConstantFP>(C);
  ASSERT_NE(CF, nullptr);
  EXPECT_TRUE(CF->getValueAPF().bitwiseIsEqual(llvm::APFloat(-1.25f)));
}

TEST(AliveConstantSynthesisTest, SynthesizesVectorIntegerConstant) {
  constexpr char IR[] = R"(
define <2 x i32> @src(<2 x i32> %_reservedc) {
entry:
  ret <2 x i32> <i32 3, i32 -7>
}

define <2 x i32> @tgt(<2 x i32> %_reservedc) {
entry:
  ret <2 x i32> %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  ASSERT_TRUE(Result.Good);

  auto *C = getSynthesizedConst(Result);
  ASSERT_TRUE(C->getType()->isVectorTy());
  auto *E0 = llvm::dyn_cast_or_null<llvm::ConstantInt>(C->getAggregateElement(0u));
  auto *E1 = llvm::dyn_cast_or_null<llvm::ConstantInt>(C->getAggregateElement(1u));
  ASSERT_NE(E0, nullptr);
  ASSERT_NE(E1, nullptr);
  EXPECT_EQ(E0->getSExtValue(), 3);
  EXPECT_EQ(E1->getSExtValue(), -7);
}

TEST(AliveConstantSynthesisTest, SynthesizesVectorFloatConstant) {
  constexpr char IR[] = R"(
define <2 x float> @src(<2 x float> %_reservedc) {
entry:
  ret <2 x float> <float 1.000000e+00, float -2.500000e+00>
}

define <2 x float> @tgt(<2 x float> %_reservedc) {
entry:
  ret <2 x float> %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  ASSERT_TRUE(Result.Good);

  auto *C = getSynthesizedConst(Result);
  ASSERT_TRUE(C->getType()->isVectorTy());
  auto *E0 = llvm::dyn_cast_or_null<llvm::ConstantFP>(C->getAggregateElement(0u));
  auto *E1 = llvm::dyn_cast_or_null<llvm::ConstantFP>(C->getAggregateElement(1u));
  ASSERT_NE(E0, nullptr);
  ASSERT_NE(E1, nullptr);
  EXPECT_TRUE(E0->getValueAPF().bitwiseIsEqual(llvm::APFloat(1.0f)));
  EXPECT_TRUE(E1->getValueAPF().bitwiseIsEqual(llvm::APFloat(-2.5f)));
}

TEST(AliveConstantSynthesisTest, RejectsBranchDependentIntegerValue) {
  constexpr char IR[] = R"(
define i32 @src(i1 %cond, i32 %_reservedc) {
entry:
  br i1 %cond, label %left, label %right

left:
  ret i32 0

right:
  ret i32 1
}

define i32 @tgt(i1 %cond, i32 %_reservedc) {
entry:
  ret i32 %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  EXPECT_FALSE(Result.Good);
}

TEST(AliveConstantSynthesisTest, RejectsInputDependentIntegerValue) {
  constexpr char IR[] = R"(
define i32 @src(i32 %x, i32 %_reservedc) {
entry:
  ret i32 %x
}

define i32 @tgt(i32 %x, i32 %_reservedc) {
entry:
  ret i32 %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  EXPECT_FALSE(Result.Good);
}

TEST(AliveConstantSynthesisTest, RejectsFloatSelectDependentValue) {
  constexpr char IR[] = R"(
define float @src(float %x, float %_reservedc) {
entry:
  %cmp = fcmp ogt float %x, 0.000000e+00
  %v = select i1 %cmp, float 1.000000e+00, float 2.000000e+00
  ret float %v
}

define float @tgt(float %x, float %_reservedc) {
entry:
  ret float %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  EXPECT_FALSE(Result.Good);
}

TEST(AliveConstantSynthesisTest, RejectsBranchyScalarFloatPoisonMiscompile) {
  constexpr char IR[] = R"(
define float @src(double %a, float %b, i1 %c0, i1 %c1, i1 %c2,
                  float %_reservedc) {
entry:
  %x = fptrunc fast double %a to float
  br i1 %c1, label %join, label %left

left:
  br label %mid

mid:
  br i1 %c2, label %join2, label %sink

join2:
  br label %join

join:
  br i1 %c0, label %sink, label %retprep

retprep:
  %r = fmul fast float %b, %x
  ret float %r

sink:
  unreachable
}

define float @tgt(double %a, float %b, i1 %c0, i1 %c1, i1 %c2,
                  float %_reservedc) {
entry:
  ret float %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  EXPECT_FALSE(Result.Good);
}

TEST(AliveConstantSynthesisTest, RejectsFptosiPoisonMiscompile) {
  constexpr char IR[] = R"(
define i32 @src(i16 %x, i32 %_reservedc) {
entry:
  %0 = sitofp i16 %x to double
  %1 = fmul fast double %0, 7.500000e-01
  %2 = fptosi double %1 to i32
  ret i32 %2
}

define i32 @tgt(i16 %x, i32 %_reservedc) {
entry:
  ret i32 %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  EXPECT_FALSE(Result.Good);
}

TEST(AliveConstantSynthesisTest, RejectsBranchyVectorConstantMiscompile) {
  constexpr char IR[] = R"(
declare double @llvm.powi.f64.i32(double, i32)

define <2 x double> @src(double %a, double %b, i1 %c,
                          <2 x double> %_reservedc) {
entry:
  br i1 %c, label %1, label %2

1:
  br label %2

2:
  %x = phi double [ 0.000000e+00, %1 ], [ %b, %entry ]
  %y = phi double [ 1.000000e+00, %1 ], [ %a, %entry ]
  %sqx = fmul fast double %x, %x
  %sqy = fmul fast double %y, %y
  %sum = fadd fast double %sqy, %sqx
  %pow = call fast double @llvm.powi.f64.i32(double %sum, i32 3)
  %vec = insertelement <2 x double> poison, double %pow, i64 0
  ret <2 x double> %vec
}

define <2 x double> @tgt(double %a, double %b, i1 %c,
                          <2 x double> %_reservedc) {
entry:
  ret <2 x double> %_reservedc
}
)";

  auto Result = synthesizeConstants(IR);
  EXPECT_FALSE(Result.Good);
}

} // namespace
