FOLDER=topic_12
BIN=${FOLDER}/main.out
OBJ=${FOLDER}/main.o
SRC=${FOLDER}/main.asm

LIB_SRC=lib.asm
STACK_SRC=topic_11/stack/stack.asm
INC=lib.inc topic_11/stack/stack.inc
LIB=lib.o 
STACK=topic_11/stack/stack.o

NASM_OPTS=-f elf -g

all: ${BIN}
${BIN}: ${LIB} ${OBJ} ${STACK}
	ld -m elf_i386 -o ${BIN} ${LIB} ${OBJ} ${STACK}

${LIB}: ${LIB_SRC}
	nasm ${NASM_OPTS} ${LIB_SRC}

${STACK}: ${STACK_SRC}
	nasm ${NASM_OPTS} ${STACK_SRC}

${OBJ}: ${SRC} ${INC}
	nasm ${NASM_OPTS} ${SRC}

clean: 
	rm -f ${FOLDER}/*.out ${FOLDER}/*.o ${LIB}

run: ${BIN}
	./${BIN}

debug: ${BIN}
	gdb ${BIN}
