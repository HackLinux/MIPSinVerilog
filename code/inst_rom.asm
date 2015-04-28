
inst_rom.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	3c010101 	lui	at,0x101
   4:	34210101 	ori	at,at,0x101
   8:	34221100 	ori	v0,at,0x1100
   c:	00220825 	or	at,at,v0
  10:	302300fe 	andi	v1,at,0xfe
  14:	00610824 	and	at,v1,at
  18:	3824ff00 	xori	a0,at,0xff00
  1c:	00810826 	xor	at,a0,at
  20:	00810827 	nor	at,a0,at
  24:	3c020404 	lui	v0,0x404
	...
  30:	34420404 	ori	v0,v0,0x404
  34:	34070007 	li	a3,0x7
  38:	34050005 	li	a1,0x5
  3c:	34080008 	li	t0,0x8
  40:	0000000f 	sync
  44:	00021200 	sll	v0,v0,0x8
  48:	00e21004 	sllv	v0,v0,a3
  4c:	00021202 	srl	v0,v0,0x8
  50:	00a21006 	srlv	v0,v0,a1
  54:	00000000 	nop
  58:	cc000000 	pref	0x0,0(zero)
  5c:	000214c0 	sll	v0,v0,0x13
  60:	00000040 	ssnop
  64:	00021403 	sra	v0,v0,0x10
  68:	01021007 	srav	v0,v0,t0
Disassembly of section .reginfo:

00000000 <.reginfo>:
   0:	000001be 	0x1be
	...
