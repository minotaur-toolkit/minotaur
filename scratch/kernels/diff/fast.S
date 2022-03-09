	.text
	.file	"diff.c"
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2                               # -- Begin function func
.LCPI0_0:
	.long	4294901761                      # 0xffff0001
	.text
	.globl	func
	.p2align	4, 0x90
	.type	func,@function
func:                                   # @func
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	testl	%edx, %edx
	jle	.LBB0_14
# %bb.1:                                # %for.body.preheader
	movl	%edx, %r11d
	leaq	-1(%r11), %r8
	cmpq	$62, %r8
	jae	.LBB0_3
# %bb.2:
	xorl	%ecx, %ecx
	jmp	.LBB0_12
.LBB0_3:                                # %vector.ph
	shrq	%r8
	incq	%r8
	movabsq	$9223372036854775776, %r9       # imm = 0x7FFFFFFFFFFFFFE0
	movq	%r8, %rcx
	andq	$-32, %rcx
	leaq	-32(%rcx), %rax
	movq	%rax, %r10
	shrq	$5, %r10
	incq	%r10
	testq	%rax, %rax
	je	.LBB0_4
# %bb.5:                                # %vector.ph.new
	movq	%r10, %rax
	andq	$-2, %rax
	movl	$32, %edx
	vpbroadcastd	.LCPI0_0(%rip), %ymm0   # ymm0 = [4294901761,4294901761,4294901761,4294901761,4294901761,4294901761,4294901761,4294901761]
	leaq	-32(%r9), %r14
	.p2align	4, 0x90
.LBB0_6:                                # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	vpmaddwd	-128(%rdi,%rdx,4), %ymm0, %ymm1
	vpmaddwd	-96(%rdi,%rdx,4), %ymm0, %ymm2
	vpmaddwd	-64(%rdi,%rdx,4), %ymm0, %ymm3
	vpmaddwd	-32(%rdi,%rdx,4), %ymm0, %ymm4
	leaq	-32(%rdx), %rbx
	andq	%r14, %rbx
	vmovdqu	%ymm1, (%rsi,%rbx,4)
	vmovdqu	%ymm2, 32(%rsi,%rbx,4)
	vmovdqu	%ymm3, 64(%rsi,%rbx,4)
	vmovdqu	%ymm4, 96(%rsi,%rbx,4)
	vpmaddwd	(%rdi,%rdx,4), %ymm0, %ymm1
	vpmaddwd	32(%rdi,%rdx,4), %ymm0, %ymm2
	vpmaddwd	64(%rdi,%rdx,4), %ymm0, %ymm3
	vpmaddwd	96(%rdi,%rdx,4), %ymm0, %ymm4
	movq	%rdx, %rbx
	andq	%r9, %rbx
	vmovdqu	%ymm1, (%rsi,%rbx,4)
	vmovdqu	%ymm2, 32(%rsi,%rbx,4)
	vmovdqu	%ymm3, 64(%rsi,%rbx,4)
	vmovdqu	%ymm4, 96(%rsi,%rbx,4)
	addq	$64, %rdx
	addq	$-2, %rax
	jne	.LBB0_6
# %bb.7:                                # %middle.block.unr-lcssa.loopexit
	addq	$-32, %rdx
	testb	$1, %r10b
	je	.LBB0_10
.LBB0_9:                                # %vector.body.epil
	leaq	(,%rdx,4), %rax
	movq	%rax, %r10
	orq	$32, %r10
	movq	%rax, %rbx
	orq	$64, %rbx
	vpbroadcastd	.LCPI0_0(%rip), %ymm0   # ymm0 = [4294901761,4294901761,4294901761,4294901761,4294901761,4294901761,4294901761,4294901761]
	vpmaddwd	(%rdi,%rdx,4), %ymm0, %ymm1
	vpmaddwd	(%rdi,%r10), %ymm0, %ymm2
	vpmaddwd	(%rdi,%rbx), %ymm0, %ymm3
	orq	$96, %rax
	vpmaddwd	(%rdi,%rax), %ymm0, %ymm0
	andq	%rdx, %r9
	vmovdqu	%ymm1, (%rsi,%r9,4)
	vmovdqu	%ymm2, 32(%rsi,%r9,4)
	vmovdqu	%ymm3, 64(%rsi,%r9,4)
	vmovdqu	%ymm0, 96(%rsi,%r9,4)
.LBB0_10:                               # %middle.block
	cmpq	%rcx, %r8
	je	.LBB0_14
# %bb.11:
	addq	%rcx, %rcx
.LBB0_12:                               # %for.body.preheader38
	movq	%rcx, %rax
	andq	$-2, %rax
	leaq	(%rsi,%rax,2), %rax
	.p2align	4, 0x90
.LBB0_13:                               # %for.body
                                        # =>This Inner Loop Header: Depth=1
	movswl	(%rdi,%rcx,2), %edx
	movswl	2(%rdi,%rcx,2), %esi
	subl	%esi, %edx
	movl	%edx, (%rax)
	addq	$2, %rcx
	addq	$4, %rax
	cmpq	%r11, %rcx
	jb	.LBB0_13
.LBB0_14:                               # %for.cond.cleanup
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.LBB0_4:
	.cfi_def_cfa_offset 24
	xorl	%edx, %edx
	testb	$1, %r10b
	jne	.LBB0_9
	jmp	.LBB0_10
.Lfunc_end0:
	.size	func, .Lfunc_end0-func
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 15.0.0 (git@github.com:zhengyang92/llvm d402f3ffed6370474b3b3e595a889096826f33e0)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
