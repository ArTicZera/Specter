BIN="Binaries"

nasm -fbin Bootloader/boot.asm -o $BIN/boot.bin
nasm -fbin Kernel/kernel.asm -o $BIN/kernel.bin

dd if=/dev/zero of=Specter.img bs=1M count=128
mkfs.fat -F 32 -n "SPECTER" Specter.img
dd if=$BIN/boot.bin of=Specter.img conv=notrunc

mcopy -i Specter.img $BIN/kernel.bin "::kernel.bin"