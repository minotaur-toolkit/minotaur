; CHECK: xor <4 x i1>
define i4 @slice(<4 x i32> %0) {
if.then32:
  %1 = icmp eq <4 x i32> %0, <i32 8, i32 0, i32 16777226, i32 0>
  %2 = icmp ne <4 x i32> %0, <i32 8, i32 0, i32 16777226, i32 0>
  %3 = shufflevector <4 x i1> %1, <4 x i1> %2, <4 x i32> <i32 0, i32 5, i32 2, i32 7>
  %4 = bitcast <4 x i1> %3 to i4
  ret i4 %4
}


