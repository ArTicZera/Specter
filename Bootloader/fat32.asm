[BITS    16]

ReadRootDir:
        mov     eax, 1056 ;LBA RootDir
        mov     bx, RootDirBuffer
        call    ReadSectorLBA

        ;Setup RootDirBuffer
        mov     si, RootDirBuffer

FindKernel:
        cmp     byte [si], 0x00
        je      KernelNotFound

        push    si

        mov     di, KernelBIN
        mov     cx, 11

        repe    cmpsb

        pop     si

        je      KernelFound

        add     si, 32
        jmp     FindKernel

KernelFound:
        ;Cluster inicial (FAT12/16)
        mov     ax, [si + 0x1A]
        mov     [KernelCluster], ax

        mov     ax, [KernelCluster]
        sub     ax, 0x02
        add     ax, 1056
        mov     eax, eax

        mov     bx, KERNELSEGMENT
        mov     es, bx

        mov     bx, KERNELOFFSET

        call    ReadSectorLBA

        jmp     KERNELSEGMENT:KERNELOFFSET

KernelNotFound:
        cli
        hlt

ReadSectorLBA:
        pusha

        mov     word [DAP + 2], 64 ;Sectors to read
        mov     word [DAP + 4], bx ;Offset
        mov     word [DAP + 6], es ;Segment
        mov     dword [DAP + 8], eax ;LBA

        mov     si, DAP
        mov     ah, 0x42
        mov     dl, [BootDiskNumber]
        int     0x13

        jc      DiskError

        popa

        ret

DiskError:
        cli
        hlt

BootDiskNumber: db 0x00

DAP:
    db 0x10
    db 0x00
    dw 0x01
    dw 0x00
    dw 0x00
    dq 0x00

RootDirBuffer equ 0x8000