define <8 x i32> @src(<16 x i16> %wide.vec) {
entry:
  %strided.vec = shufflevector <16 x i16> %wide.vec, <16 x i16> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %strided.vec24 = shufflevector <16 x i16> %wide.vec, <16 x i16> poison, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %a = sext <8 x i16> %strided.vec to <8 x i32>
  %b = sext <8 x i16> %strided.vec24 to <8 x i32>
  %c = sub nsw <8 x i32> %a, %b
  ret <8 x i32> %c
}


define <8 x i32> @tgt(<16 x i16> %0) {
entry:
  %intr = call <8 x i32> @llvm.x86.avx2.pmadd.wd(<16 x i16> %0, <16 x i16> <i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1, i16 1, i16 -1>)
  ret <8 x i32> %intr

sink:                                             ; No predecessors!
  unreachable
}

declare <8 x i32> @llvm.x86.avx2.pmadd.wd(<16 x i16>, <16 x i16>)