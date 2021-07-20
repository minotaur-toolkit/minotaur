; CHECK: call <16 x i16> @llvm.x86.avx2.pavg.w
declare <8 x i16> @llvm.x86.sse2.pavg.w(<8 x i16>, <8 x i16>) nounwind readnone

define <16 x i16> @__avg_up_uint16(<16 x i16>, <16 x i16>) nounwind readnone {
  
  %a0 = shufflevector <16 x i16> %0, <16 x i16> undef,
    <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %b0 = shufflevector <16 x i16> %0, <16 x i16> undef,
    <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  
  %a1 = shufflevector <16 x i16> %1, <16 x i16> undef,
    <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %b1 = shufflevector <16 x i16> %1, <16 x i16> undef,
    <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  %r0 = call <8 x i16> @llvm.x86.sse2.pavg.w(<8 x i16> %a0, <8 x i16> %a1)
  %r1 = call <8 x i16> @llvm.x86.sse2.pavg.w(<8 x i16> %b0, <8 x i16> %b1)
  
  %r = shufflevector <8 x i16> %r0, <8 x i16> %r1,
    <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>

  ret <16 x i16> %r
}

