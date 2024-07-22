; bootloader.asm
BITS 16
org 0x7C00

start:
  ; Set up the stack
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7C00

  ; Print 'Loading kernel...'
  mov ah, 0x0E
  mov al, 'L'
  int 0x10
  mov al, 'o'
  int 0x10
  mov al, 'a'
  int 0x10
  mov al, 'd'
  int 0x10
  mov al, 'i'
  int 0x10
  mov al, 'n'
  int 0x10
  mov al, 'g'
  int 0x10
  mov al, ' '
  int 0x10
  mov al, 'k'
  int 0x10
  mov al, 'e'
  int 0x10
  mov al, 'r'
  int 0x10
  mov al, 'n'
  int 0x10
  mov al, 'e'
  int 0x10
  mov al, 'l'
  int 0x10
  mov al, '.'
  int 0x10
  mov al, '.'
  int 0x10
  mov al, '.'
  int 0x10

  ; Load kernel (Assume it's located at sector 2)
  mov bx, 0x1000
  mov ah, 0x02
  mov al, 1
  mov ch, 0
  mov cl, 2
  mov dh, 0
  int 0x13

  ; Jump to kernel
  jmp 0x1000:0

times 510 - ($ - $$) db 0
dw 0xAA55


