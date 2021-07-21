	.text
	.file	"merge-two-vectors.ll"
	.globl	merge                   # -- Begin function merge
	.p2align	4, 0x90
	.type	merge,@function
merge:                                  # @merge
# %bb.0:
	vpunpckhbw	%xmm1, %xmm0, %xmm2 # xmm2 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
	vpunpcklbw	%xmm1, %xmm0, %xmm3 # xmm3 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
	vinserti128	$1, %xmm2, %ymm3, %ymm2
	vextracti128	$1, %ymm1, %xmm1
	vextracti128	$1, %ymm0, %xmm0
	vpunpckhbw	%xmm1, %xmm0, %xmm3 # xmm3 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
	vpunpcklbw	%xmm1, %xmm0, %xmm0 # xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
	vinserti128	$1, %xmm3, %ymm0, %ymm0
	vinserti64x4	$1, %ymm0, %zmm2, %zmm0
	retq
.Lfunc_end0:
	.size	merge, .Lfunc_end0-merge
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
	.addrsig
