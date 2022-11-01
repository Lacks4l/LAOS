.code16
.org 0

.text

.global _start
_start:
	cli

	xor %ax, %ax
	movw %ax, %es
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %ss

	movw $0x3000, %sp

	sti

	movw $hello, %si
	call print

print:
	xorb %bh, %bh
	movb $0x0E, %ah

	lodsb

	cmpb $0, %al
	je 1f

	int $0x10;
	jmp print

1:
	ret

hello:
	.asciz "Hello World!\n"

.org 510
.word 0xAA55
