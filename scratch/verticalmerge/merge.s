	.text
	.file	"merge.c"
	.globl	interleaved_merge2              # -- Begin function interleaved_merge2
	.p2align	4, 0x90
	.type	interleaved_merge2,@function
interleaved_merge2:                     # @interleaved_merge2
	.cfi_startproc
# %bb.0:                                # %entry
	vpunpckhbw	%ymm1, %ymm0, %ymm2     # ymm2 = ymm0[8],ymm1[8],ymm0[9],ymm1[9],ymm0[10],ymm1[10],ymm0[11],ymm1[11],ymm0[12],ymm1[12],ymm0[13],ymm1[13],ymm0[14],ymm1[14],ymm0[15],ymm1[15],ymm0[24],ymm1[24],ymm0[25],ymm1[25],ymm0[26],ymm1[26],ymm0[27],ymm1[27],ymm0[28],ymm1[28],ymm0[29],ymm1[29],ymm0[30],ymm1[30],ymm0[31],ymm1[31]
	vpunpcklbw	%ymm1, %ymm0, %ymm0     # ymm0 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[4],ymm1[4],ymm0[5],ymm1[5],ymm0[6],ymm1[6],ymm0[7],ymm1[7],ymm0[16],ymm1[16],ymm0[17],ymm1[17],ymm0[18],ymm1[18],ymm0[19],ymm1[19],ymm0[20],ymm1[20],ymm0[21],ymm1[21],ymm0[22],ymm1[22],ymm0[23],ymm1[23]
	vinserti64x4	$1, %ymm0, %zmm2, %zmm0
	retq
.Lfunc_end0:
	.size	interleaved_merge2, .Lfunc_end0-interleaved_merge2
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 13.0.0 (git@github.com:llvm/llvm-project 48688257c52dfc2c666b64730f0467c2cc38210c)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
