// Copyright (c) 2020-present, author: Zhengyang Liu (liuz@cs.utah.edu).
// Distributed under the MIT license that can be found in the LICENSE file.

#include "gtest/gtest.h"
#include "parse.h"

#include <sstream>

using namespace std;
using namespace minotaur;

#if 0

TEST(ParseTest, RoundTrip) {
  std::string Tests[] = {
    "(add <1 x i32> (var b4 %0) (var b4 %0))",
    "(sub <1 x i8> (var b4 %0) (var b4 %0))",
    "(sub <1 x i8> (var b4 %0) (const i4 6))",
    "(sub <2 x i8> (var b16 %0) (var b16 %0))",
    "(sub <2 x i8> (var b16 %0) (var b16 %1))",
    "(sub <2 x i8> (var b16 %0) (const <2 x i4> {6,8}))",
    "(and <1 x i64> (var b64 %8) (const i64 18446744073709551612))",
    "(copy (const <4 x i32> {1,0,2,3}))",
    "(icmp_ult (var b32 %0) (const i32 3) b1)",
    "(shuffle <32 x i32> (var b64 %0) (const <32 x i8> {0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1}))",
    "(blend <32 x i32> (var b64 %0) (var b64 %0) (const <32 x i8> {0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1}))",
    "(conv_zext (var b8 %0) <1 x i8> <1 x i64>)",
    "(conv_sext (var b8 %0) <1 x i8> <1 x i64>)",
    "(conv_trunc (var b8 %0) <1 x i64> <1 x i8>)",
    "(x86_sse2_pmadd_wd (var b128 %0) (var b128 %0))"
  };

  for (const auto &T : Tests) {
    vector<unique_ptr<minotaur::Inst>> exprs;
    minotaur::Inst *I = nullptr;
    try {
      Parse p;
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
#endif