ifndef CROSS_COMPILE
	CROSS_COMPILE = mips-sde-elf-
endif

AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OBJECTS = inst_rom.o


all: inst_rom.data inst_rom.asm

%.o: %.S
	$(AS) -mips32 $< -o $@

inst_rom.om: ram.ld $(OBJECTS)
	$(LD) -T ram.ld $(OBJECTS) -o $@

inst_rom.bin: inst_rom.om
	$(OBJCOPY) -O binary $< $@

inst_rom.data: inst_rom.bin
	./Bin2Mem -f $< -o $@

inst_rom.asm: inst_rom.om
		$(OBJDUMP) -D $< > $@

clean:
	rm -f ./*.o ./*.om ./*.bin ./*.data
