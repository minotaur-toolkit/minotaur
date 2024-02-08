; CHECK: call <16 x i16> @llvm.x86.avx2.psign.w(<16 x i16> %a, <16 x i16> %b)
define <16 x i16> @syn_nop_psign_1(<16 x i16> %a, <16 x i16> %b) {
  %x1 =  call <16 x i16> @llvm.x86.avx2.psign.w(<16 x i16> %a, <16 x i16> %b) #2
  %y1 =  call <16 x i16> @llvm.x86.avx2.psign.w(<16 x i16> %x1, <16 x i16> %b) #2
  %z1 =  call <16 x i16> @llvm.x86.avx2.psign.w(<16 x i16> %y1, <16 x i16> %b) #2
  ret <16 x i16> %z1
}

declare <16 x i16> @llvm.x86.avx2.psign.w(<16 x i16>, <16 x i16>) nounwind readnone
