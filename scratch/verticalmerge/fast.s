	.text
	.file	"merge.c"
	.globl	interleaved_merge2              # -- Begin function interleaved_merge2
	.p2align	4, 0x90
	.type	interleaved_merge2,@function
interleaved_merge2:                     # @interleaved_merge2
	.cfi_startproc
# %bb.0:                                # %entry
	vpmovzxbw	%ymm0, %zmm0            # zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero,ymm0[16],zero,ymm0[17],zero,ymm0[18],zero,ymm0[19],zero,ymm0[20],zero,ymm0[21],zero,ymm0[22],zero,ymm0[23],zero,ymm0[24],zero,ymm0[25],zero,ymm0[26],zero,ymm0[27],zero,ymm0[28],zero,ymm0[29],zero,ymm0[30],zero,ymm0[31],zero
	vpmovzxbw	%ymm1, %zmm1            # zmm1 = ymm1[0],zero,ymm1[1],zero,ymm1[2],zero,ymm1[3],zero,ymm1[4],zero,ymm1[5],zero,ymm1[6],zero,ymm1[7],zero,ymm1[8],zero,ymm1[9],zero,ymm1[10],zero,ymm1[11],zero,ymm1[12],zero,ymm1[13],zero,ymm1[14],zero,ymm1[15],zero,ymm1[16],zero,ymm1[17],zero,ymm1[18],zero,ymm1[19],zero,ymm1[20],zero,ymm1[21],zero,ymm1[22],zero,ymm1[23],zero,ymm1[24],zero,ymm1[25],zero,ymm1[26],zero,ymm1[27],zero,ymm1[28],zero,ymm1[29],zero,ymm1[30],zero,ymm1[31],zero
	vpsllw	$8, %zmm1, %zmm1
	vporq	%zmm0, %zmm1, %zmm0
	retq
.Lfunc_end0:
	.size	interleaved_merge2, .Lfunc_end0-interleaved_merge2
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 13.0.0 (git@github.com:llvm/llvm-project 48688257c52dfc2c666b64730f0467c2cc38210c)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
