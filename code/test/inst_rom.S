.org 0x0
.global _start
.set noat
.set noreorder
.set nomacro


_start:
	lui $1, 0x2000
	ori $1, 0x0008
	lui $2, 0xffff
	ori $2, $2, 0xffff
	sw $2, 0x0


	lui $1, 0x2000
	ori $1, $1, 0x000c
	lui $2, 0x0000
	ori $2, $2, 0x0000
	sw $2, 0x0


	lui $1, 0x2000
	ori $1, $1, 0x0004
	lui $2, 0x5555
	ori $2, $2, 0x5555
	sw $2, 0x00
