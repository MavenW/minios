# Makefile para el bootloader
AS = nasm
ASFLAGS = -f bin

.PHONY: all clean

all: boot.bin

boot.bin: boot.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f *.bin