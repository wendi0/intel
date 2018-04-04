	.file	"main.c"
	.text
.globl memcpy
	.type	memcpy, @function
memcpy:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	.L2
.L3:
	movl	12(%ebp), %eax
	movzbl	(%eax), %edx
	movl	8(%ebp), %eax
	movb	%dl, (%eax)
	incl	8(%ebp)
	incl	12(%ebp)
	incl	-4(%ebp)
.L2:
	movl	-4(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L3
	movl	8(%ebp), %eax
	leave
	ret
	.size	memcpy, .-memcpy
.globl memset
	.type	memset, @function
memset:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	12(%ebp), %eax
	movb	%al, -20(%ebp)
	movl	$0, -4(%ebp)
	jmp	.L7
.L8:
	movl	8(%ebp), %edx
	movzbl	-20(%ebp), %eax
	movb	%al, (%edx)
	incl	8(%ebp)
	incl	-4(%ebp)
.L7:
	movl	-4(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L8
	movl	8(%ebp), %eax
	leave
	ret
	.size	memset, .-memset
.globl memsetw
	.type	memsetw, @function
memsetw:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	12(%ebp), %eax
	movw	%ax, -20(%ebp)
	movl	$0, -4(%ebp)
	jmp	.L12
.L13:
	movl	8(%ebp), %edx
	movl	-20(%ebp), %eax
	movw	%ax, (%edx)
	addl	$2, 8(%ebp)
	incl	-4(%ebp)
.L12:
	movl	-4(%ebp), %eax
	cmpl	16(%ebp), %eax
	jl	.L13
	movl	8(%ebp), %eax
	leave
	ret
	.size	memsetw, .-memsetw
.globl strlen
	.type	strlen, @function
strlen:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	.L17
.L18:
	incl	-4(%ebp)
.L17:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	setne	%al
	incl	8(%ebp)
	testb	%al, %al
	jne	.L18
	movl	-4(%ebp), %eax
	leave
	ret
	.size	strlen, .-strlen
.globl inportb
	.type	inportb, @function
inportb:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	8(%ebp), %eax
	movw	%ax, -20(%ebp)
	movl	-20(%ebp), %edx
#APP
	inb %dx, %al
#NO_APP
	movb	%al, -1(%ebp)
	movzbl	-1(%ebp), %eax
	leave
	ret
	.size	inportb, .-inportb
.globl outportb
	.type	outportb, @function
outportb:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movw	%ax, -4(%ebp)
	movb	%dl, -8(%ebp)
	movl	-4(%ebp), %edx
	movzbl	-8(%ebp), %eax
#APP
	outb %al, %dx
#NO_APP
	leave
	ret
	.size	outportb, .-outportb
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
.L26:
	jmp	.L26
	.size	main, .-main
	.ident	"GCC: (GNU) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)"
	.section	.note.GNU-stack,"",@progbits
