AS				 = nasm
CC				 = gcc
LD				 = ld

SRCS			 = $(wildcard kernel/*.c)
ASMS		 	 = $(wildcard kernel/*.asm)
OBJS 			 = $(SRCS:%.c=%.o) $(ASMS:%.asm=%.o)
OS_IMAGE	 = os-img

ASFLAGS		 = -f elf
CFLAGS		 = -m32 -ffreestanding -c
LDFLAGS		 = -m elf_i386 -T linker.ld


.PHONY: all qemu clean echo


all: $(OS_IMAGE)

qemu: $(OS_IMAGE)
	qemu-system-i386 -fda $<

debug: $(OS_IMAGE)
	qemu-system-i386 -fda $< -s -S -m 64

$(OS_IMAGE): boot/bootloader.bin kernel/kernel.bin
	cat $^ > $@

boot/bootloader.bin: boot/bootloader.asm
	$(AS) -f bin -o $@ $<

boot/kentry.o: boot/kentry.asm
	$(AS) $(ASFLAGS) -o $@ $^

kernel/kernel.bin: boot/kentry.o $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
	objcopy -O binary $@ $@

%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf **/*.o **/*.bin $(OS_IMAGE)

echo:
	@echo $(SRCS)
	@echo $(OBJS)
	@echo $(ASMS)
