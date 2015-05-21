.set noat
.set noreorder
.set nomacro

.org 0x0
.text
.aligen 4
.gloal _start

_start:
	//init gpio
	lui $1, 0x2000
	ori $1, $1, 0x0008
	lui $2, 0xffff
	ori $2, $2, 0xffff
	sw $2, 0x0($1)

	lui $1, 0x2000
	ori $1, $1, 0x000c
	lui $2, 0x0000
	ori $2, $2, 0x0000
	sw $2, 0x0($1)
	
	// init sdram
_wait_for_sdr:
	lui $1, 0x2000
	ori $1, $1, 0x0000
	lw $4, 0x0($1)
	srl $4, $4, 0x10
	andi $4, $4, 0x0001
	beq $4, $0, _wait_for_sdr
	nop


	//init uart




	//load os
	li $5, 0x4
	lui $1, 0x3000
	ori $1, $1, 0x0300
	lw $1, 0x0($1)
	nop


	lui $2, 0x0000
	lui $3, 0x3000
	ori $3, $3, 0x0304
l:
	lw $4, 0x0($3)
	nop
	sw $4, 0x0($3)
	addi $2, $2, 0x4
	addi $3, $3, 0x4
	nop
	bgez $1, 1b
	subu $1, $1, $5
