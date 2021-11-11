; DAG
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>) #17

declare <8 x i16> @llvm.bswap.v8i16(<8 x i16>) #17

declare <8 x i32> @llvm.fshl.v8i32(<8 x i32>, <8 x i32>, <8 x i32>) #17

; Function Attrs: norecurse nounwind readnone uwtable willreturn mustprogress
define <16 x i8> @_Z12reverse_sse2Dv2_x(<16 x i8> %v, <4 x i32> %w) {
entry:
  %0 = bitcast <16 x i8> %v to <4 x i32>
  %permil = shufflevector <4 x i32> %0, <4 x i32> %w, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %or.i1415 = tail call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %permil, <4 x i32> %permil, <4 x i32> <i32 16, i32 16, i32 16, i32 16>)
  %1 = bitcast <4 x i32> %or.i1415 to <8 x i16>
  br label %jump
jump:
  br label %finally
finally:
  %or.i16 = tail call <8 x i16> @llvm.bswap.v8i16(<8 x i16> %1)
  %or.i = bitcast <8 x i16> %or.i16 to <16 x i8>
  ret <16 x i8> %or.i
}

