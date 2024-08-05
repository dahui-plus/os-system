[BITS 16]
[ORG 0x7C00]

start:
  mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL, so it's best to remember this for later

  mov bp, 0x9000
  mov sp, bp

  call load_kernel

  ; Switch to protected mode
  cli                 ; Disable interrupts
  lgdt [gdt_descriptor]
  mov eax, cr0
  or eax, 0x1
  mov cr0, eax

  jmp 0x08:protected_mode

load_kernel:
  ; Load the kernel (assuming it starts at sector 2)
  mov bx, 0x1000      ; Address to load the kernel
  mov dh, 2           ; Number of sectors to read
  mov dl, [BOOT_DRIVE]
  call disk_load
  ret

disk_load:
  pusha

  mov ah, 0x02        ; BIOS read sector function
  mov al, dh          ; Number of sectors to read
  mov ch, 0           ; Cylinder 0
  mov cl, 2           ; Start reading from second sector (i.e., after the boot sector)
  mov dh, 0           ; Head 0
  ; dl = drive number is set as input to disk_load
  int 0x13            ; BIOS interrupt
  jc disk_error       ; Jump if error (i.e. carry flag set)

  popa
  ret

disk_error:
  popa
  jmp hang

sectors_error:
  popa
  jmp hang

[BITS 32]
protected_mode:
  mov ax, 0x10        ; Data segment selector
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  mov esp, 0x9FFFF    ; Set up stack pointer

  call 0x1000         ; Jump to kernel entry point

hang:
  hlt
  jmp hang

BOOT_DRIVE db 0

gdt:
  dq 0x0000000000000000   ; Null descriptor
  dq 0x00CF9A000000FFFF   ; Code segment descriptor
  dq 0x00CF92000000FFFF   ; Data segment descriptor

gdt_descriptor:
  dw gdt_end - gdt - 1
  dd gdt
gdt_end:

times 510-($-$$) db 0
dw 0xAA55
