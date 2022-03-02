define <4 x i32> @sliced_(i32* %0, i64 %1, i8 %2) {
entry:
  %3 = shl i64 %1, 1
  %4 = getelementptr inbounds i32, i32* %0, i64 %3
  %5 = bitcast i32* %4 to <8 x i32>*
  %6 = load <8 x i32>, <8 x i32>* %5, align 4
  %7 = shufflevector <8 x i32> %6, <8 x i32> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %8 = shufflevector <8 x i32> %6, <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %9 = sub nsw <4 x i32> %8, %7
  ret <4 x i32> %9

sink:                                             ; No predecessors!
  unreachable
}
