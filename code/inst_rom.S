.org 0x0
.global _start
.set noat

_start:
	ORI $1, $0, 0xFFFF
	SLL $1, $1, 16
	ORI $1, $1, 0xFFFB
	ORI $2, $0, 6


	MULT $1, $2
	MADD $1, $2
	MADDU $1, $2
	MSUB $1, $2
	MSUBU $1, $2
