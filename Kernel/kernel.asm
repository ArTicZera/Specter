[BITS    16]
[ORG 0x0000]

KernelMain:
        cli

        mov     ax, cs
        mov     ds, ax
        mov     es, ax
        mov     ss, ax
        mov     sp, 0xFFFE

        sti

        ;Setup Mode 13h
        mov     ax, 0x13
        int     0x10

        mov     si, str1
        mov     al, 0x0F
        call    PrintString

        jmp     $

str1: db "HELLO, WORLD!", 0x00

%include "Kernel/font.asm"
%include "Kernel/graphics.asm"
