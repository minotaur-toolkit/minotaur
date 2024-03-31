; CHECK: changed
define <8 x i32> @sliced_b(<16 x i16> %0) {
entry:
  %1 = shufflevector <16 x i16> %0, <16 x i16> poison, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %2 = sext <8 x i16> %1 to <8 x i32>
  ret <8 x i32> %2
}
