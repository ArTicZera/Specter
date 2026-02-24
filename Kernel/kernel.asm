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

        mov     ah, 0x0E
        mov     al, 'V'
        mov     bl, 0x0A
        int     0x10

        jmp     $