.org 0x0
.global _start
.set noat

_start:
	ori $1, $0, 0x100
	jr $1
	nop

	.org 0x20
	addi $2, $2, 0x01
	mfc0 $1, $11, 0x0
	addi $1, $1, 100
	mtc0 $1, $11, 0x0
	eret
	nop

	.org 0x100
	ori $2, $0, 0
	ori $1, $0, 100
	mtc0 $1, $11, 0

	lui $1, 0x1000
	ori $1, $1, 0x401
	mtc0 $1, $12, 0

_loop:
	j _loop
	nop
