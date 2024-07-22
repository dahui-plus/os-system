BOOT_DIR = boot
KERNEL_DIR = kernel
BUILD_DIR = build

# Tools
AS = nasm
CC = gcc
LD = ld

# Files
BOOTLOADER = $(BOOT_DIR)/bootloader.asm
KERNEL = $(KERNEL_DIR)/kernel.c
BOOTLOADER_BIN = $(BUILD_DIR)/bootloader.bin
KERNEL_BIN = $(BUILD_DIR)/kernel.bin
OS_IMAGE = $(BUILD_DIR)/os.bin
LINKER_SCRIPT = linker.ld

# Flags
ASFLAGS = -f bin
CFLAGS = -ffreestanding -m32 -c
LDFLAGS = -m elf_i386 -T $(LINKER_SCRIPT)

# Targets
all: $(OS_IMAGE)

qemu: $(OS_IMAGE)
	qemu-system-x86_64 -drive format=raw,file=$<


$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BOOTLOADER_BIN): $(BOOTLOADER) | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $< -o $@

$(KERNEL_BIN): $(KERNEL) $(LINKER_SCRIPT) | $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $(BUILD_DIR)/kernel.o
	$(LD) $(LDFLAGS) $(BUILD_DIR)/kernel.o -o $@

$(OS_IMAGE): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cat $^ > $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
