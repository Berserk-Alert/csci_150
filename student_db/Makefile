OBJ=../lib.o ../io.o

all: test.out

test.out: test.o ${OBJ}
	ld -m elf_i386 -o test.out test.o ${OBJ}

test.o: test.asm ../lib.inc ../io.inc
	nasm -f elf -g $<

../lib.o: ../lib.asm
	nasm -f elf -g $<

../io.o: ../io.asm
	nasm -f elf -g $<

run: test.out
	./test.out

debug: test.out
	gdb test.out
