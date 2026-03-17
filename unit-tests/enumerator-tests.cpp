// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "enumerator.h"
#include "gtest/gtest.h"

#include "llvm/ADT/StringRef.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

#include <algorithm>
#include <initializer_list>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

using namespace minotaur;

namespace {

constexpr char I64TestIR[] = R"(
define i64 @test(i64 %x, i64 %y, i64 %z) {
entry:
  %root = add i64 %x, %y
  ret i64 %root
}
)";

constexpr char I64SelectTestIR[] = R"(
define i64 @test(i1 %c, i64 %x, i64 %y, i64 %z) {
entry:
  %root = add i64 %x, %y
  ret i64 %root
}
)";

constexpr char I1CompareTestIR[] = R"(
define i1 @test(i1 %c, i64 %x, i64 %y, i64 %z) {
entry:
  %root = icmp eq i64 %x, %y
  ret i1 %root
}
)";

constexpr char I32TestIR[] = R"(
define i32 @test(i32 %x, i32 %y, i32 %z) {
entry:
  %root = add i32 %x, %y
  ret i32 %root
}
)";

constexpr char LiftedLeafIR[] = R"(
define i64 @test(i64 %x, i64 %y) {
entry:
  %tmp = xor i64 %x, 42
  %root = add i64 %tmp, %y
  ret i64 %root
}
)";

struct SketchCase {
  const char *name;
  std::initializer_list<std::string_view> expected;
};

std::unique_ptr<llvm::Module> parseTestModule(
    llvm::LLVMContext &Ctx, std::string_view IR) {
  llvm::SMDiagnostic Err;
  auto M = llvm::parseIR(llvm::MemoryBufferRef(
                             llvm::StringRef(IR.data(), IR.size()),
                             "enumerator-tests"),
                         Err, Ctx);
  if (M)
    return M;

  std::string Msg;
  llvm::raw_string_ostream OS(Msg);
  Err.print("enumerator-tests", OS);
  ADD_FAILURE() << OS.str();
  return nullptr;
}

llvm::Instruction *findInstruction(llvm::Function &F,
                                   llvm::StringRef Name) {
  for (auto &BB : F) {
    for (auto &I : BB) {
      if (I.getName() == Name)
        return &I;
    }
  }
  return nullptr;
}

std::vector<std::string> collectSketches(
    std::string_view IR, bool args_only,
    bool enable_depth2, bool enable_depth3) {
  llvm::LLVMContext Ctx;
  auto M = parseTestModule(Ctx, IR);
  if (!M)
    return {};

  auto *F = M->getFunction("test");
  if (!F) {
    ADD_FAILURE() << "missing @test function";
    return {};
  }

  auto *Root = findInstruction(*F, "root");
  if (!Root) {
    ADD_FAILURE() << "missing %root instruction";
    return {};
  }

  Enumerator E;
  return E.enumerateSketchStringsForTesting(
      *F, Root, args_only, enable_depth2, enable_depth3);
}

std::vector<std::string> collectDefaultSketches(
    bool enable_depth2, bool enable_depth3) {
  return collectSketches(I64TestIR, true,
                         enable_depth2, enable_depth3);
}

bool containsSketch(const std::vector<std::string> &Sketches,
                    std::string_view Expected) {
  for (const auto &Sketch : Sketches) {
    if (Sketch == Expected)
      return true;
  }
  return false;
}

bool containsSketch(
    const std::vector<std::string> &Sketches,
    std::initializer_list<std::string_view> Expected) {
  for (auto Needle : Expected) {
    if (containsSketch(Sketches, Needle))
      return true;
  }
  return false;
}

std::string dumpSketches(
    const std::vector<std::string> &Sketches) {
  constexpr size_t MaxDumped = 200;
  const size_t Count = std::min(Sketches.size(), MaxDumped);
  std::string Dump = "showing ";
  Dump += std::to_string(Count);
  Dump += " of ";
  Dump += std::to_string(Sketches.size());
  Dump += " sketches\n";
  for (size_t I = 0; I < Count; ++I) {
    const auto &Sketch = Sketches[I];
    Dump += Sketch;
    Dump += '\n';
  }
  return Dump;
}

TEST(EnumeratorTest, Depth1IncludesRepresentativeSketches) {
  auto Depth1 = collectDefaultSketches(false, false);

  ASSERT_FALSE(Depth1.empty());

  EXPECT_TRUE(containsSketch(
      Depth1, "(bswap i64 (var i64 %x))"))
      << dumpSketches(Depth1);
  EXPECT_TRUE(containsSketch(
      Depth1, "(bswap <2 x i32> (var i64 %x))"))
      << dumpSketches(Depth1);
  EXPECT_TRUE(containsSketch(
      Depth1, "(and i64 (var i64 %x) (var i64 %y))"))
      << dumpSketches(Depth1);
  EXPECT_TRUE(containsSketch(
      Depth1,
      "(add i64 (var i64 %x) (reservedconst i64 null))"))
      << dumpSketches(Depth1);
}

TEST(EnumeratorTest, Depth2AddsRepresentativeCompositions) {
  auto Depth1 = collectDefaultSketches(false, false);
  auto Depth2 = collectDefaultSketches(true, false);

  ASSERT_FALSE(Depth1.empty());
  ASSERT_FALSE(Depth2.empty());

  const SketchCase Cases[] = {
    {
      "or(bswap(x), y)",
      { "(or i64 (bswap i64 (var i64 %x)) (var i64 %y))" },
    },
    {
      "ctlz(bswap(x))",
      { "(ctlz i64 (bswap i64 (var i64 %x)))" },
    },
    {
      "and(bswap(x), reservedconst)",
      {
        "(and i64 (bswap i64 (var i64 %x)) "
        "(reservedconst i64 null))",
      },
    },
  };

  for (const auto &C : Cases) {
    SCOPED_TRACE(C.name);
    EXPECT_FALSE(containsSketch(Depth1, C.expected))
        << dumpSketches(Depth1);
    EXPECT_TRUE(containsSketch(Depth2, C.expected))
        << dumpSketches(Depth2);
  }
}

TEST(EnumeratorTest, Depth2AddsSelectAndMinMaxCompositions) {
  auto Depth1 = collectSketches(
      I64SelectTestIR, true, false, false);
  auto Depth2 = collectSketches(
      I64SelectTestIR, true, true, false);

  ASSERT_FALSE(Depth1.empty());
  ASSERT_FALSE(Depth2.empty());

  const SketchCase Cases[] = {
    {
      "smax(bswap(x), y)",
      {
        "(smax i64 (bswap i64 (var i64 %x)) (var i64 %y))",
      },
    },
    {
      "select(c, bswap(x), y)",
      {
        "(select (var i1 %c) (bswap i64 (var i64 %x)) "
        "(var i64 %y))",
      },
    },
    {
      "and(select(c, x, y), z)",
      {
        "(and i64 (select (var i1 %c) (var i64 %x) "
        "(var i64 %y)) (var i64 %z))",
      },
    },
    {
      "select(c, smax(x, y), z)",
      {
        "(select (var i1 %c) (smax i64 (var i64 %x) "
        "(var i64 %y)) (var i64 %z))",
        "(select (var i1 %c) (smax i64 (var i64 %y) "
        "(var i64 %x)) (var i64 %z))",
      },
    },
  };

  for (const auto &C : Cases) {
    SCOPED_TRACE(C.name);
    EXPECT_FALSE(containsSketch(Depth1, C.expected))
        << dumpSketches(Depth1);
    EXPECT_TRUE(containsSketch(Depth2, C.expected))
        << dumpSketches(Depth2);
  }
}

TEST(EnumeratorTest, Depth2AddsCompareOverDeepValueExpressions) {
  auto Depth1 = collectSketches(
      I1CompareTestIR, true, false, false);
  auto Depth2 = collectSketches(
      I1CompareTestIR, true, true, false);

  ASSERT_FALSE(Depth1.empty());
  ASSERT_FALSE(Depth2.empty());

  const SketchCase Cases[] = {
    {
      "icmp(add(x, y), z)",
      {
        "(icmp_slt (add i64 (var i64 %x) (var i64 %y)) "
        "(var i64 %z) b1)",
        "(icmp_slt (add i64 (var i64 %y) (var i64 %x)) "
        "(var i64 %z) b1)",
      },
    },
    {
      "icmp(select(c, x, y), z)",
      {
        "(icmp_eq (select (var i1 %c) (var i64 %x) "
        "(var i64 %y)) (var i64 %z) b1)",
      },
    },
    {
      "icmp(sext(c), z)",
      {
        "(icmp_sgt (conv_sext (var i1 %c) i1 i64) "
        "(var i64 %z) b1)",
      },
    },
  };

  for (const auto &C : Cases) {
    SCOPED_TRACE(C.name);
    EXPECT_FALSE(containsSketch(Depth1, C.expected))
        << dumpSketches(Depth1);
    EXPECT_TRUE(containsSketch(Depth2, C.expected))
        << dumpSketches(Depth2);
  }
}

TEST(EnumeratorTest, Depth2SkipsDoubleConstantOuterSketches) {
  auto Depth1 = collectDefaultSketches(false, false);
  auto Depth2 = collectDefaultSketches(true, false);

  ASSERT_FALSE(Depth1.empty());
  ASSERT_FALSE(Depth2.empty());

  const char *Allowed =
      "(or i64 (shl i64 (var i64 %x) (reservedconst i64 null)) "
      "(var i64 %y))";
  const char *Skipped =
      "(or i64 (shl i64 (var i64 %x) (reservedconst i64 null)) "
      "(reservedconst i64 null))";

  EXPECT_FALSE(containsSketch(Depth1, Allowed))
      << dumpSketches(Depth1);
  EXPECT_TRUE(containsSketch(Depth2, Allowed))
      << dumpSketches(Depth2);
  EXPECT_FALSE(containsSketch(Depth2, Skipped))
      << dumpSketches(Depth2);
}

TEST(EnumeratorTest, Depth3WorksWithoutDepth2Flag) {
  auto Depth1 = collectDefaultSketches(false, false);
  auto Depth3Only = collectDefaultSketches(false, true);

  ASSERT_FALSE(Depth1.empty());
  ASSERT_FALSE(Depth3Only.empty());

  const char *Expected =
      "(or i64 (or i64 (var i64 %y) "
      "(bswap i64 (var i64 %x))) (var i64 %z))";

  EXPECT_FALSE(containsSketch(Depth1, Expected))
      << dumpSketches(Depth1);
  EXPECT_TRUE(containsSketch(Depth3Only, Expected))
      << dumpSketches(Depth3Only);
}

TEST(EnumeratorTest, Depth3OnlyVariants) {
  auto Depth2Only = collectDefaultSketches(true, false);
  auto Depth3Enabled = collectDefaultSketches(true, true);

  ASSERT_FALSE(Depth2Only.empty());
  ASSERT_FALSE(Depth3Enabled.empty());

  const SketchCase Cases[] = {
    {
      "or(or(y, bswap(x)), z)",
      {
        "(or i64 (or i64 (var i64 %y) "
        "(bswap i64 (var i64 %x))) (var i64 %z))",
        "(or i64 (or i64 (bswap i64 (var i64 %x)) "
        "(var i64 %y)) (var i64 %z))",
      },
    },
    {
      "xor(or(y, bitreverse(x)), z)",
      {
        "(xor i64 (or i64 (var i64 %y) "
        "(bitreverse i64 (var i64 %x))) (var i64 %z))",
        "(xor i64 (or i64 (bitreverse i64 (var i64 %x)) "
        "(var i64 %y)) (var i64 %z))",
      },
    },
    {
      "shl(shl(bswap(x), y), z)",
      {
        "(shl i64 (shl i64 (bswap i64 (var i64 %x)) "
        "(var i64 %y)) (var i64 %z))",
      },
    },
  };

  for (const auto &C : Cases) {
    SCOPED_TRACE(C.name);
    EXPECT_FALSE(containsSketch(Depth2Only, C.expected))
        << dumpSketches(Depth2Only);
    EXPECT_TRUE(containsSketch(Depth3Enabled, C.expected))
        << dumpSketches(Depth3Enabled);
  }
}

TEST(EnumeratorTest, Depth3AddsSelectCompositions) {
  auto Depth2Only = collectSketches(
      I64SelectTestIR, true, true, false);
  auto Depth3Enabled = collectSketches(
      I64SelectTestIR, true, true, true);

  ASSERT_FALSE(Depth2Only.empty());
  ASSERT_FALSE(Depth3Enabled.empty());

  const SketchCase Cases[] = {
    {
      "and(select(c, bswap(x), y), z)",
      {
        "(and i64 (select (var i1 %c) (bswap i64 (var i64 %x)) "
        "(var i64 %y)) (var i64 %z))",
      },
    },
  };

  for (const auto &C : Cases) {
    SCOPED_TRACE(C.name);
    EXPECT_FALSE(containsSketch(Depth2Only, C.expected))
        << dumpSketches(Depth2Only);
    EXPECT_TRUE(containsSketch(Depth3Enabled, C.expected))
        << dumpSketches(Depth3Enabled);
  }
}

TEST(EnumeratorTest, Depth3AddsCompareOverDeeperValueExpressions) {
  auto Depth2Only = collectSketches(
      I1CompareTestIR, true, true, false);
  auto Depth3Enabled = collectSketches(
      I1CompareTestIR, true, true, true);

  ASSERT_FALSE(Depth2Only.empty());
  ASSERT_FALSE(Depth3Enabled.empty());

  const SketchCase Cases[] = {
    {
      "icmp(add(bswap(x), const), z)",
      {
        "(icmp_slt (add i64 (bswap i64 (var i64 %x)) "
        "(reservedconst i64 null)) (var i64 %z) b1)",
      },
    },
  };

  for (const auto &C : Cases) {
    SCOPED_TRACE(C.name);
    EXPECT_FALSE(containsSketch(Depth2Only, C.expected))
        << dumpSketches(Depth2Only);
    EXPECT_TRUE(containsSketch(Depth3Enabled, C.expected))
        << dumpSketches(Depth3Enabled);
  }
}

TEST(EnumeratorTest, Depth3OnlyConstantSynthesis) {
  auto Depth2Only = collectDefaultSketches(true, false);
  auto Depth3Enabled = collectDefaultSketches(true, true);

  ASSERT_FALSE(Depth2Only.empty());
  ASSERT_FALSE(Depth3Enabled.empty());

  const std::initializer_list<std::string_view> Expected = {
    "(and i64 (shl i64 (bswap i64 (var i64 %x)) "
    "(var i64 %y)) (reservedconst i64 null))",
  };

  EXPECT_FALSE(containsSketch(Depth2Only, Expected))
      << dumpSketches(Depth2Only);
  EXPECT_TRUE(containsSketch(Depth3Enabled, Expected))
      << dumpSketches(Depth3Enabled);
}

TEST(EnumeratorTest, Depth3IsDisabledForI32) {
  auto Depth2Only = collectSketches(
      I32TestIR, true, true, false);
  auto Depth3Requested = collectSketches(
      I32TestIR, true, true, true);

  ASSERT_FALSE(Depth2Only.empty());
  ASSERT_FALSE(Depth3Requested.empty());
  EXPECT_EQ(Depth2Only.size(), Depth3Requested.size());

  const char *Depth3OnlyShape =
      "(or i32 (or i32 (var i32 %y) "
      "(bswap i32 (var i32 %x))) (var i32 %z))";
  EXPECT_FALSE(containsSketch(Depth2Only, Depth3OnlyShape))
      << dumpSketches(Depth2Only);
  EXPECT_FALSE(containsSketch(Depth3Requested, Depth3OnlyShape))
      << dumpSketches(Depth3Requested);
}

TEST(EnumeratorTest, FindInputsAddsDominatedInstructions) {
  auto ArgsOnly = collectSketches(
      LiftedLeafIR, true, false, false);
  auto WithFindInputs = collectSketches(
      LiftedLeafIR, false, false, false);

  ASSERT_FALSE(ArgsOnly.empty());
  ASSERT_FALSE(WithFindInputs.empty());

  const char *Expected = "(bswap i64 (var i64 %tmp))";
  EXPECT_FALSE(containsSketch(ArgsOnly, Expected))
      << dumpSketches(ArgsOnly);
  EXPECT_TRUE(containsSketch(WithFindInputs, Expected))
      << dumpSketches(WithFindInputs);
}

} // namespace
