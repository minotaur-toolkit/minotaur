; CHECK: xor i64 %1, -9223372036854775808
define <2 x float> @src(<2 x float> %0) {
entry:
  %1 = fneg <2 x float> %0
  %2 = shufflevector <2 x float> %0, <2 x float> %1, <2 x i32> <i32 0, i32 3>
  ret <2 x float> %2

sink:                                             ; No predecessors!
  unreachable
}
