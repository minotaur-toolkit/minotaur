	.text
	.file	"convolve8_16_avx2.c"
	.globl	interleaved_merge2              # -- Begin function interleaved_merge2
	.p2align	4, 0x90
	.type	interleaved_merge2,@function
interleaved_merge2:                     # @interleaved_merge2
# %bb.0:                                # %entry
	vextracti128	$1, %ymm1, %xmm2
	vextracti128	$1, %ymm0, %xmm3
	vpunpckhbw	%xmm2, %xmm3, %xmm4     # xmm4 = xmm3[8],xmm2[8],xmm3[9],xmm2[9],xmm3[10],xmm2[10],xmm3[11],xmm2[11],xmm3[12],xmm2[12],xmm3[13],xmm2[13],xmm3[14],xmm2[14],xmm3[15],xmm2[15]
	vpunpcklbw	%xmm2, %xmm3, %xmm2     # xmm2 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3],xmm3[4],xmm2[4],xmm3[5],xmm2[5],xmm3[6],xmm2[6],xmm3[7],xmm2[7]
	vinserti128	$1, %xmm4, %ymm2, %ymm2
	vpunpckhbw	%xmm1, %xmm0, %xmm3     # xmm3 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
	vpunpcklbw	%xmm1, %xmm0, %xmm0     # xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
	vinserti128	$1, %xmm3, %ymm0, %ymm0
	vinserti64x4	$1, %ymm2, %zmm0, %zmm0
	retq
.Lfunc_end0:
	.size	interleaved_merge2, .Lfunc_end0-interleaved_merge2
                                        # -- End function
	.ident	"clang version 13.0.0 (git@github.com:llvm/llvm-project 48688257c52dfc2c666b64730f0467c2cc38210c)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
