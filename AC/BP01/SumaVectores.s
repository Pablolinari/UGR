	.file	"SumaVectores.c"
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"Faltan n\303\202\302\272 componentes del vector"
	.align 8
.LC3:
	.string	"Tiempo:%11.9f\t / Tama\303\203\302\261o Vectores:%u\n"
	.align 8
.LC4:
	.string	"/ V1[%d]+V2[%d]=V3[%d](%8.6f+%8.6f=%8.6f) /\n"
	.align 8
.LC5:
	.string	"Tiempo:%11.9f\t / Tama\303\203\302\261o Vectores:%u\t/ V1[0]+V2[0]=V3[0](%8.6f+%8.6f=%8.6f) / / V1[%d]+V2[%d]=V3[%d](%8.6f+%8.6f=%8.6f) /\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB39:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	movq	%fs:40, %rax
	movq	%rax, 56(%rsp)
	xorl	%eax, %eax
	cmpl	$1, %edi
	jle	.L25
	movq	8(%rsi), %rdi
	movl	$10, %edx
	xorl	%esi, %esi
	call	strtol@PLT
	movl	%eax, %r13d
	cmpl	$33554432, %eax
	ja	.L3
	cmpl	$8, %eax
	ja	.L26
	testl	%eax, %eax
	je	.L6
	pxor	%xmm1, %xmm1
	movsd	.LC1(%rip), %xmm3
	leaq	v1(%rip), %r14
	leaq	v2(%rip), %rbp
	cvtsi2sdl	%eax, %xmm1
	xorl	%eax, %eax
	mulsd	%xmm3, %xmm1
	.p2align 4,,10
	.p2align 3
.L7:
	pxor	%xmm0, %xmm0
	movapd	%xmm1, %xmm2
	cvtsi2sdl	%eax, %xmm0
	mulsd	%xmm3, %xmm0
	addsd	%xmm0, %xmm2
	movsd	%xmm2, (%r14,%rax,8)
	movapd	%xmm1, %xmm2
	subsd	%xmm0, %xmm2
	movsd	%xmm2, 0(%rbp,%rax,8)
	addq	$1, %rax
	cmpl	%r13d, %eax
	jb	.L7
	movl	%r13d, %eax
	movq	%rax, 8(%rsp)
.L8:
	leaq	16(%rsp), %rsi
	xorl	%edi, %edi
	leaq	v3(%rip), %r15
	call	clock_gettime@PLT
	movq	8(%rsp), %rax
	leaq	0(,%rax,8), %rdx
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L11:
	movsd	(%r14,%rax), %xmm0
	addsd	0(%rbp,%rax), %xmm0
	movsd	%xmm0, (%r15,%rax)
	addq	$8, %rax
	cmpq	%rdx, %rax
	jne	.L11
	leaq	32(%rsp), %rsi
	xorl	%edi, %edi
	call	clock_gettime@PLT
	movq	40(%rsp), %rax
	pxor	%xmm0, %xmm0
	subq	24(%rsp), %rax
	cvtsi2sdq	%rax, %xmm0
	pxor	%xmm1, %xmm1
	movq	32(%rsp), %rax
	subq	16(%rsp), %rax
	cvtsi2sdq	%rax, %xmm1
	divsd	.LC2(%rip), %xmm0
	addsd	%xmm1, %xmm0
	cmpl	$9, %r13d
	ja	.L21
	movl	%r13d, %edx
	movl	$1, %edi
	movl	$1, %eax
	xorl	%ebx, %ebx
	leaq	.LC3(%rip), %rsi
	leaq	.LC4(%rip), %r13
	call	__printf_chk@PLT
	.p2align 4,,10
	.p2align 3
.L15:
	movsd	(%r14,%rbx,8), %xmm0
	movsd	(%r15,%rbx,8), %xmm2
	movl	%ebx, %edx
	movl	%ebx, %ecx
	movl	%ebx, %r8d
	movq	%r13, %rsi
	movl	$1, %edi
	movl	$3, %eax
	movsd	0(%rbp,%rbx,8), %xmm1
	addq	$1, %rbx
	call	__printf_chk@PLT
	cmpq	%rbx, 8(%rsp)
	jne	.L15
.L14:
	movq	56(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L27
	addq	$72, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L26:
	.cfi_restore_state
	xorl	%edi, %edi
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
.L5:
	movl	%r13d, %eax
	leaq	v1(%rip), %r14
	leaq	v2(%rip), %rbp
	movq	%rax, 8(%rsp)
	movq	%r14, %rbx
	movq	%rbp, %r12
	leaq	(%r14,%rax,8), %r15
	.p2align 4,,10
	.p2align 3
.L9:
	call	rand@PLT
	pxor	%xmm0, %xmm0
	addq	$8, %rbx
	addq	$8, %r12
	cvtsi2sdl	%eax, %xmm0
	movsd	%xmm0, (%rsp)
	call	rand@PLT
	pxor	%xmm1, %xmm1
	movsd	(%rsp), %xmm0
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbx)
	call	rand@PLT
	pxor	%xmm0, %xmm0
	cvtsi2sdl	%eax, %xmm0
	movsd	%xmm0, (%rsp)
	call	rand@PLT
	pxor	%xmm1, %xmm1
	movsd	(%rsp), %xmm0
	cvtsi2sdl	%eax, %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%r12)
	cmpq	%r15, %rbx
	jne	.L9
	jmp	.L8
.L21:
	leal	-1(%r13), %eax
	movl	%r13d, %edx
	movl	$1, %edi
	movsd	v3(%rip), %xmm3
	movsd	(%r15,%rax,8), %xmm6
	movsd	0(%rbp,%rax,8), %xmm5
	movq	%rax, %rcx
	movl	%eax, %r9d
	movsd	(%r14,%rax,8), %xmm4
	movsd	v2(%rip), %xmm2
	movl	%eax, %r8d
	leaq	.LC5(%rip), %rsi
	movsd	v1(%rip), %xmm1
	movl	$7, %eax
	call	__printf_chk@PLT
	jmp	.L14
.L3:
	xorl	%edi, %edi
	movl	$33554432, %r13d
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	jmp	.L5
.L6:
	leaq	16(%rsp), %rsi
	xorl	%edi, %edi
	call	clock_gettime@PLT
	leaq	32(%rsp), %rsi
	xorl	%edi, %edi
	call	clock_gettime@PLT
	movq	40(%rsp), %rax
	pxor	%xmm0, %xmm0
	xorl	%edx, %edx
	subq	24(%rsp), %rax
	pxor	%xmm1, %xmm1
	movl	$1, %edi
	cvtsi2sdq	%rax, %xmm0
	movq	32(%rsp), %rax
	subq	16(%rsp), %rax
	divsd	.LC2(%rip), %xmm0
	cvtsi2sdq	%rax, %xmm1
	leaq	.LC3(%rip), %rsi
	movl	$1, %eax
	addsd	%xmm1, %xmm0
	call	__printf_chk@PLT
	jmp	.L14
.L25:
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	orl	$-1, %edi
	call	exit@PLT
.L27:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE39:
	.size	main, .-main
	.globl	v3
	.bss
	.align 32
	.type	v3, @object
	.size	v3, 268435456
v3:
	.zero	268435456
	.globl	v2
	.align 32
	.type	v2, @object
	.size	v2, 268435456
v2:
	.zero	268435456
	.globl	v1
	.align 32
	.type	v1, @object
	.size	v1, 268435456
v1:
	.zero	268435456
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	-1717986918
	.long	1069128089
	.align 8
.LC2:
	.long	0
	.long	1104006501
	.ident	"GCC: (Ubuntu 13.2.0-4ubuntu3) 13.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
