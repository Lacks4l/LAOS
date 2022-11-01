CC=gcc
ASM=as
LD=ld

CCFLAGS=-std=c11 -O2 -g -Wall -Wextra -Wno-return-type -Wno-unused-function -nostdlib

BOOTSECT_SOURCES=\
	src/boot.S

BOOTSECT_OBJECTS=$(BOOTSECT_SOURCES:.S=.o)

KERNEL_C_SOURCES=$(wildcard src/*.c)
KERNEL_S_SOURCES=$(wildcard src/*.S)
KERNEL_OBJECTS=$(KERNEL_C_SOURCES:.c=.o) $(KERNEL_S_SOURCES:.S=.o)

BOOTSECT=bootsect.bin
KERNEL=kernel.bin
ISO=boot.iso

all: dirs bootsect kernel

dirs:
	mkdir -p bin

clean:
	-rm ./**/*.o
	-rm ./**/*.bin
	-rm ./*.iso

%.o: %.c
	$(CC) -o $@ -c $< $(CCFLAGS)

%.o: %.S
	$(ASM) -o $@ -c $<

bootsect: $(BOOTSECT_OBJECTS)
	$(LD) -o ./bin/$(BOOTSECT) $^ -nostdlib -Tsrc/link.ld

kernel: $(KERNEL_OBJECTS)
	$(LD) -o ./bin/$(KERNEL) $^ -nostdlib -Ttext 0x0

img: bootsect
	dd if=/dev/zero of=boot.iso bs=512 count=2880
	dd if=./bin/$(BOOTSECT) of=boot.img conv=notrunc seek=0 count=1
	dd if=./bin/$(KERNEL) of=boot.img conv=notrunc seek=1 bs=512

run: 
	qemu-system-i386 -drive format=raw,file=boot.img


