// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "gtest/gtest.h"
#include "Parse.h"

#include <sstream>

TEST(ParseTest, RoundTrip) {
  std::string Tests[] = {
    "(add (var 'i4 %0'), (const 'i4 -3'))",
  };

  for (const auto &T : Tests) {
    minotaur::Inst *I = parse::parse(T);
    ASSERT_TRUE(I != nullptr);
    std::stringstream rs;
    I->print(rs);
    rs.flush();
    EXPECT_EQ(rs.str(), T);
  }
}