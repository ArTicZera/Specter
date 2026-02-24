;Tutorial 3 - Como criar um sistema operacional
;   --> Criando um sistema de arquivos

[BITS    16]
[ORG 0x7C00]

%define KERNELSEGMENT 0x1000
%define KERNELOFFSET  0x0000

jmp short BootMain
nop

OEMIdentifier               db "MSDOS5.0"

BytesPerSector              dw 512
SectorsPerCluster           db 1
ReservedSectors             dw 32
FatCount                    db 2
RootDirectoryEntriesCount   dw 0
TotalSectors16              dw 0
MediaDescriptor             db 0F8h
SectorsPerFat16             dw 0

; 0x18
SectorsPerTrack             dw 63
NumberOfHeads               dw 255
HiddenSectors               dd 0
TotalSectors32              dd 65536

; ===============================
; FAT32 Extended BPB
; ===============================

; 0x24
SectorsPerFat32             dd 512
MirroringFlags              dw 0
FatVersion                  dw 0
RootDirectoryCluster        dd 2
FileSystemInfoSector        dw 1
BackupBootSector            dw 6
times 12                    db 0

; ===============================
; Extended Boot Record
; ===============================

BootDrive                   db 80h
NtFlags                     db 0
ExtendedBootSignature       db 29h
VolumeSerialNumber          dd 12345678h
VolumeLabel                 db "SPECTER    "
FileSystemType              db "FAT32   "

BootMain:
        cli

        ;Limpa os dados
        xor     ax, ax
        mov     ds, ax
        mov     es, ax

        ;Configura a stack
        mov     sp, 0x7C00
        mov     ss, ax

        sti

        mov     [BootDiskNumber], dl

        jmp     ReadRootDir

KernelBIN: db "KERNEL  BIN"
KernelCluster: dw 0x00

%include "Bootloader/fat32.asm"

times 510 - ($ - $$) db 0x00
dw 0xAA55