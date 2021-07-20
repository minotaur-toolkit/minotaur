define dso_local <4 x i64> @test_mm_hsub_epi32(<4 x i64> %a, <4 x i64> %b, <4 x i64> %c) local_unnamed_addr #0 {
entry:
  %0 = bitcast <4 x i64> %a to <16 x i16>
  %1 = bitcast <4 x i64> %c to <16 x i16>
  %2 = bitcast <4 x i64> %b to <16 x i16>
  %add.i = add <16 x i16> %1, %0
  %add.i4 = add <16 x i16> %1, %2
  %3 = tail call <16 x i16> @llvm.x86.avx2.pavg.w(<16 x i16> %add.i, <16 x i16> %add.i4) #2
  %4 = tail call <16 x i16> @llvm.x86.avx2.pavg.w(<16 x i16> %0, <16 x i16> %2) #2
  %sub = sub <16 x i16> %3, %4
  %5 = bitcast <16 x i16> %sub to <4 x i64>
  ret <4 x i64> %5
}

declare <16 x i16> @llvm.x86.avx2.pavg.w(<16 x i16>, <16 x i16>) nounwind readnone
