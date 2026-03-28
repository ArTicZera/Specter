[BITS 16]
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
        
        call    GetRootFilenameBuffer
        mov     bx, ax ; save the string count

        call PrintFiles
        
        jmp     $

GetRootFilenameBuffer:
        xor     si, si
        mov     di, filenamebuf
        push    ds
        mov     ax, 0x0800
        mov     ds, ax
        call    GetRootDirNames
        pop     ds
        ret

PrintFiles:
        mov     si, header
        mov     al, 0x0F
        call    PrintString
        mov     si, filenamebuf
.PrintLoop:
        test    bx, bx
        jz      .Done
        push    si
        mov     si, newline
        call    PrintString
        pop     si
        call    PrintString
        add     si, 12 ; 11 chars + 0x00
        dec     bx
        jmp     .PrintLoop
.Done:
        ret


header: db "ROOT DIR FILES:", 0x00
filenamebuf: times 256 db 0x00
newline: db " ", 0x0F, "    - ", 0x00

%include "Kernel/font.asm"
%include "Kernel/graphics.asm"
%define FAT_NO_BOOTLOADER_ROUTINES
%include "Bootloader/fat32.asm"