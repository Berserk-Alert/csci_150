FOLDER=topic_9/
BIN=${FOLDER}main.out
OBJ=${FOLDER}main.o
SRC=${FOLDER}main.asm

LIB=lib.o
LIB_SRC=lib.asm
INC=lib.inc

NASM_OPTS=-f elf -g

all: ${BIN}
${BIN}: ${LIB} ${OBJ}
	ld -m elf_i386 -o ${BIN} ${LIB} ${OBJ}

${LIB}: ${LIB_SRC}
	nasm ${NASM_OPTS} ${LIB_SRC}

${OBJ}: ${SRC} ${INC}
	nasm ${NASM_OPTS} ${SRC}

clean: 
	rm -f ${FOLDER}*.out ${FOLDER}*.o ${LIB}

run: ${BIN}
	./${BIN}

debug: ${BIN}
	gdb ${BIN}