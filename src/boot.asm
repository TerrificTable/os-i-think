; From: http://3zanders.co.uk/2017/10/18/writing-a-bootloader/



section .boot
bits 16         ; tell NASM this is 16 bit code
global boot


boot:
    mov ax, 0x2401
    int 0x15            ; enable A20 bit

    mov ax, 0x3
    int 0x10            ; set vga text mode 3

    mov [disk], dl

    mov ah, 0x2         ; read sectors
    mov al, 6           ; sectors to read
    mov ch, 0           ; cylinders idx
    mov dh, 0           ; head idx
    mov cl, 2           ; sectors idx
    mov dl, [disk]      ; disk idx
    mov bx, copy_target ; target pointer
    int 0x13            ; read sectors from drive to target location

    cli
    
    lgdt [gdt_pointer]  ; load gdt table
    mov eax, cr0
    or  eax, 0x1        ; set the protected mode bit on special CPU reg cr0
    mov cr0, eax
    
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax


    jmp CODE_SEG:boot2  ; long jump to the code segment



gdt_start:
    dq 0x0
gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start

disk:
    db 0x0

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start



times 510 - ($-$$) db 0     ; pad remaining 510 bytes with zeroes
dw 0xaa55                   ; magic bootloader magic - marks this 512 byte sector bootable!


; ========================
; beyond 512 bytes
; ========================


copy_target:
bits 32


hello: db "Hello world! (beyond 512 bytes)",0



boot2:
    mov esi, hello
    mov ebx, 0xb8000

.loop:
    lodsb
    or  al,al   ; is al == 0 ?
    jz  halt    ; if (al == 0) jmp halt
    or  eax, 0x0f00
    mov word [ebx], ax
    add ebx, 2
    jmp .loop

halt:
    mov esp, kernel_stack_top
    extern kmain
    call kmain
    cli     ; clear interrupt flag
    hlt     ; halt execution


section .bss
align 4
kernel_stack_bottom: equ $
    resb 16384  ; 16 KB
kernel_stack_top:
