// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "gtest/gtest.h"
#include "Parse.h"

#include <sstream>

using namespace std;
using namespace parse;

TEST(ParseTest, RoundTrip) {
  std::string Tests[] = {
    "(add <1 x i32> (var 4 %0) (var 4 %0))",
    "(sub <1 x i8> (var 4 %0) (var 4 %0))",
    "(sub <1 x i8> (var 4 %0) (var 4 16))",
  };

  for (const auto &T : Tests) {
    vector<unique_ptr<minotaur::Inst>> exprs;
    minotaur::Inst *I = nullptr;
    try {
      I = parse::parse(T, exprs);
    } catch (parse::ParseException E) {
      cerr<<E.str<<" at "<<E.lineno<<", in test case "<<T<<endl;
    }
    ASSERT_TRUE(I != nullptr);
    std::stringstream rs;
    I->print(rs);
    rs.flush();
    EXPECT_EQ(rs.str(), T);
  }
}