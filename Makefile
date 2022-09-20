ASM 	:= nasm
ASM_OUT := build/boot.o

GCC 		:= i386-elf-g++
GCC_FLAGS 	:= -nostdlib -ffreestanding -std=c++11 -mno-red-zone -fno-exceptions -nostdlib -fno-rtti -Wall -Wextra -Werror

BUILD_FILE 	:= src/boot.asm
CPP_FILE 	:= src/kmain.cpp
LINKER_FILE := linker.ld
KERNEL 		:= build/kernel.bin



all: comp run


comp:
	-@mkdir build
	$(ASM) -f elf32 $(BUILD_FILE) -o $(ASM_OUT)
	$(GCC) -m32 $(CPP_FILE) $(ASM_OUT) -o $(KERNEL) $(GCC_FLAGS) -T $(LINKER_FILE)


run:
	qemu-system-x86_64 -fda $(KERNEL) & vncviewer 127.0.0.1:5900


clean:
	rm -rdf build/*.*



# i386-elf-gcc / -g++
# https://aur.archlinux.org/packages/i386-elf-gcc
