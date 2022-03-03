; CHECK: call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %v, <16 x i8> <i8 15, i8 14, i8 13, i8 12, i8 11, i8 10, i8 9, i8 8, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>)

; backend is able to turn the script into pshuf, anyway
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>) #17

declare <8 x i16> @llvm.bswap.v8i16(<8 x i16>) #17

declare <8 x i32> @llvm.fshl.v8i32(<8 x i32>, <8 x i32>, <8 x i32>) #17

; Function Attrs: norecurse nounwind readnone uwtable willreturn mustprogress
define <16 x i8> @_Z12reverse_sse2Dv2_x(<16 x i8> %v) {
entry:
  %0 = bitcast <16 x i8> %v to <4 x i32>
  %permil = shufflevector <4 x i32> %0, <4 x i32> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %or.i1415 = tail call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %permil, <4 x i32> %permil, <4 x i32> <i32 16, i32 16, i32 16, i32 16>)
  %1 = bitcast <4 x i32> %or.i1415 to <8 x i16>
  %or.i16 = tail call <8 x i16> @llvm.bswap.v8i16(<8 x i16> %1)
  %or.i = bitcast <8 x i16> %or.i16 to <16 x i8>
  ret <16 x i8> %or.i
}

