; CHECK: <i64 31, i64 31>
define <2 x i64> @src(<16 x i16> %wide.vec) {
  %c = call <2 x i64> @llvm.x86.sse2.psad.bw(<16 x i8> <i8 1, i8 5, i8 3, i8 4, i8 8, i8 7, i8 2, i8 1, i8 7, i8 2, i8 3, i8 8, i8 1, i8 3, i8 8, i8 2>, <16 x i8> <i8 7, i8 2, i8 3, i8 8, i8 1, i8 3, i8 8, i8 2, i8 1, i8 5, i8 3, i8 4, i8 8, i8 7, i8 2, i8 1>)
  ret <2 x i64> %c
}


declare <2 x i64> @llvm.x86.sse2.psad.bw(<16 x i8>, <16 x i8>) nounwind readnone