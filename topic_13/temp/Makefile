all: file_copy.out

test.out: test.o ../../lib.o
	ld -m elf_i386 -o $@ $^

file_copy.out: file_copy.o ../../lib.o
	ld -m elf_i386 -o $@ $^

test.o: test.asm ../../lib.inc
	nasm -f elf -g $<

../../lib.o: ../../lib.asm
	nasm -f elf -g $<

file_copy.o: file_copy.asm ../../lib.inc
	nasm -f elf -g $<

clean: 
	rm -f *.o *.out ../../lib.o

test: test.out
	./$< arg1 arg2 arg3