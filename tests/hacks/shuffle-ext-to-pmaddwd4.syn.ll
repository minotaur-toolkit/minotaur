; CHECK: <i16 1, i16 0, i16 0, i16 1, i16 1, i16 0, i16 0, i16 1, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0, i16 1, i16 0>
define <8 x i32> @sliced_b(<16 x i16> %0) {
entry:
  %1 = shufflevector <16 x i16> %0, <16 x i16> poison, <8 x i32> <i32 0, i32 3, i32 4, i32 7, i32 8, i32 10, i32 12, i32 14>
  %2 = sext <8 x i16> %1 to <8 x i32>
  ret <8 x i32> %2
}
