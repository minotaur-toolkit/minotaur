	.text
	.file	"convolve8_16_avx2.c"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5                               # -- Begin function convolve8_16_avx2
.LCPI0_0:
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.text
	.globl	convolve8_16_avx2
	.p2align	4, 0x90
	.type	convolve8_16_avx2,@function
convolve8_16_avx2:                      # @convolve8_16_avx2
	.cfi_startproc
# %bb.0:                                # %entry
	vmovdqa	(%rdi), %ymm0
	vmovdqa	32(%rdi), %ymm1
	vmovdqa	64(%rdi), %ymm2
	vmovdqa	96(%rdi), %ymm3
	vpmaddubsw	(%rsi), %ymm0, %ymm0
	vpmaddubsw	32(%rsi), %ymm1, %ymm1
	vpmaddubsw	64(%rsi), %ymm2, %ymm2
	vpmaddubsw	96(%rsi), %ymm3, %ymm3
	vpaddw	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm1, %ymm3, %ymm1
	vpaddw	.LCPI0_0(%rip), %ymm0, %ymm0
	vpaddsw	%ymm1, %ymm0, %ymm0
	vpsraw	$7, %ymm0, %ymm0
	retq
.Lfunc_end0:
	.size	convolve8_16_avx2, .Lfunc_end0-convolve8_16_avx2
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5                               # -- Begin function convolve8_16_avx2_opt
.LCPI1_0:
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.short	64                              # 0x40
	.text
	.globl	convolve8_16_avx2_opt
	.p2align	4, 0x90
	.type	convolve8_16_avx2_opt,@function
convolve8_16_avx2_opt:                  # @convolve8_16_avx2_opt
	.cfi_startproc
# %bb.0:                                # %entry
	vmovdqa64	(%rdi), %zmm0
	vmovdqa64	64(%rdi), %zmm1
	vpmaddubsw	(%rsi), %zmm0, %zmm0
	vpmaddubsw	64(%rsi), %zmm1, %zmm1
	vextracti64x4	$1, %zmm0, %ymm2
	vextracti64x4	$1, %zmm1, %ymm3
	vpaddw	%ymm2, %ymm3, %ymm2
	vpaddw	%ymm1, %ymm0, %ymm0
	vpaddw	.LCPI1_0(%rip), %ymm0, %ymm0
	vpaddsw	%ymm2, %ymm0, %ymm0
	vpsraw	$7, %ymm0, %ymm0
	retq
.Lfunc_end1:
	.size	convolve8_16_avx2_opt, .Lfunc_end1-convolve8_16_avx2_opt
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 13.0.0 (git@github.com:llvm/llvm-project 48688257c52dfc2c666b64730f0467c2cc38210c)"
	.section	".note.GNU-stack","",@progbits
