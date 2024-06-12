RISCV_PREFIX ?= riscv64-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc

RISCV_GCC_OPTS ?= -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns
RISCV_LINK_OPTS ?= -static -nostdlib -nostartfiles -lm -lgcc -T link.ld

sources = src/entry.S src/main.c src/crc16.c src/gpio.c src/uart.c src/util.c src/xmodem.c
target = BootROM

#default target
default: $(target).elf
	$(RISCV_PREFIX)objdump -D $< > $(target).lss
	elf2coe $< $(target).coe

$(target).elf: Makefile $(sources)
	$(RISCV_GCC) -I. -Isrc $(RISCV_GCC_OPTS) -o $@ $(sources) $(RISCV_LINK_OPTS)

.PHONY: clean

clean:
	rm -rfv *.elf *.lss *.o *.coe *.mem

