; CHECK: pslli
define <2 x i64> @sliced_(i32 %0) {                                                                                                                                                                                                                                                                                                                                         entry:
  %1 = and i32 %0, 7
  %2 = icmp eq i32 %1, 7
  %3 = select i1 %2, i32 6, i32 %1
  %4 = icmp eq i32 %1, 0
  %5 = select i1 %4, i32 1, i32 %3
  %6 = add nsw i32 %5, -1
  %7 = insertelement <2 x i32> poison, i32 %5, i32 0
  %8 = insertelement <2 x i32> %7, i32 %6, i32 1
  %9 = zext <2 x i32> %8 to <2 x i64>
  %10 = shl <2 x i64> <i64 72340172838076673, i64 72340172838076673>, %9
  ret <2 x i64> %10
}
