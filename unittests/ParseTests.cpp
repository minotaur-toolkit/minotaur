// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "gtest/gtest.h"
#include "IR.h"

TEST(ParseTest, RoundTrip) {
  std::string Tests[] = {
    "(add (var 'i4 %0'), (const 'i4 -3'))",
  };

  for (const auto &T : Tests) {
    std::string ErrStr;

/*
    auto R = ParseReplacement(IC, "<input>", T, ErrStr);
    ASSERT_EQ("", ErrStr);
    EXPECT_EQ(R.getString(true), T);

    ReplacementContext Context1, Context2, Context3;
    auto LHS = R.getLHSString(Context1);
    auto R2 = ParseReplacementLHS(IC, "<input>", LHS, Context2, ErrStr);
    ASSERT_EQ("", ErrStr);
    auto LHS2 = R2.getLHSString(Context3);
    EXPECT_EQ(LHS, LHS2);

    auto RHS = R.getRHSString(Context1);
    auto R3 = ParseReplacementRHS(IC, "<input>", RHS, Context2, ErrStr);
    ASSERT_EQ("", ErrStr);
    auto RHS2 = R3.getRHSString(Context3);
    EXPECT_EQ(RHS, RHS2);

    auto Split = LHS + RHS;
    auto R4 = ParseReplacement(IC, "<input>", Split, ErrStr);
    ASSERT_EQ("", ErrStr);
    EXPECT_EQ(R4.getString(true), T);*/
  }
}