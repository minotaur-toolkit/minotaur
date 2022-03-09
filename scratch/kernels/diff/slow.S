	.text
	.file	"diff.c"
	.globl	func                            # -- Begin function func
	.p2align	4, 0x90
	.type	func,@function
func:                                   # @func
	.cfi_startproc
# %bb.0:                                # %entry
	testl	%edx, %edx
	jle	.LBB0_8
# %bb.1:                                # %for.body.preheader
	movl	%edx, %r9d
	leaq	-1(%r9), %r8
	cmpq	$62, %r8
	jae	.LBB0_3
# %bb.2:
	xorl	%ecx, %ecx
	jmp	.LBB0_6
.LBB0_3:                                # %vector.ph
	shrq	%r8
	incq	%r8
	movq	%r8, %r11
	andq	$-32, %r11
	leaq	(%r11,%r11), %rcx
	xorl	%eax, %eax
	movabsq	$4611686018427387872, %r10      # imm = 0x3FFFFFFFFFFFFFE0
	.p2align	4, 0x90
.LBB0_4:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	vmovdqu	(%rdi,%rax,4), %ymm0
	vmovdqu	32(%rdi,%rax,4), %ymm1
	vmovdqu	64(%rdi,%rax,4), %ymm2
	vmovdqu	96(%rdi,%rax,4), %ymm3
	vpmovdw	%ymm0, %xmm8
	vpmovdw	%ymm1, %xmm1
	vpmovdw	%ymm2, %xmm2
	vpmovdw	%ymm3, %xmm3
	vpsrld	$16, 16(%rdi,%rax,4), %xmm4
	vpsrld	$16, (%rdi,%rax,4), %xmm5
	vpackusdw	%xmm4, %xmm5, %xmm4
	vpsrld	$16, 48(%rdi,%rax,4), %xmm5
	vpsrld	$16, 32(%rdi,%rax,4), %xmm6
	vpsrld	$16, 80(%rdi,%rax,4), %xmm7
	vpsrld	$16, 64(%rdi,%rax,4), %xmm0
	vpackusdw	%xmm5, %xmm6, %xmm5
	vpackusdw	%xmm7, %xmm0, %xmm0
	vpsrld	$16, 112(%rdi,%rax,4), %xmm6
	vpsrld	$16, 96(%rdi,%rax,4), %xmm7
	vpackusdw	%xmm6, %xmm7, %xmm6
	vpmovsxwd	%xmm8, %ymm7
	vpmovsxwd	%xmm1, %ymm1
	vpmovsxwd	%xmm2, %ymm2
	vpmovsxwd	%xmm3, %ymm3
	vpmovsxwd	%xmm4, %ymm4
	vpsubd	%ymm4, %ymm7, %ymm4
	vpmovsxwd	%xmm5, %ymm5
	vpsubd	%ymm5, %ymm1, %ymm1
	vpmovsxwd	%xmm0, %ymm0
	vpsubd	%ymm0, %ymm2, %ymm0
	vpmovsxwd	%xmm6, %ymm2
	vpsubd	%ymm2, %ymm3, %ymm2
	movq	%rax, %rdx
	andq	%r10, %rdx
	vmovdqu	%ymm4, (%rsi,%rdx,4)
	vmovdqu	%ymm1, 32(%rsi,%rdx,4)
	vmovdqu	%ymm0, 64(%rsi,%rdx,4)
	vmovdqu	%ymm2, 96(%rsi,%rdx,4)
	addq	$32, %rax
	cmpq	%rax, %r11
	jne	.LBB0_4
# %bb.5:                                # %middle.block
	cmpq	%r11, %r8
	je	.LBB0_8
.LBB0_6:                                # %for.body.preheader28
	movq	%rcx, %rax
	andq	$-2, %rax
	leaq	(%rsi,%rax,2), %rax
	.p2align	4, 0x90
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	movswl	(%rdi,%rcx,2), %edx
	movswl	2(%rdi,%rcx,2), %esi
	subl	%esi, %edx
	movl	%edx, (%rax)
	addq	$2, %rcx
	addq	$4, %rax
	cmpq	%r9, %rcx
	jb	.LBB0_7
.LBB0_8:                                # %for.cond.cleanup
	vzeroupper
	retq
.Lfunc_end0:
	.size	func, .Lfunc_end0-func
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 15.0.0 (git@github.com:zhengyang92/llvm d402f3ffed6370474b3b3e595a889096826f33e0)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
