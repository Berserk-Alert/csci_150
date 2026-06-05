FOLDER=topic_13/temp
BIN=${FOLDER}/main.out
OBJ=${FOLDER}/main.o
SRC=${FOLDER}/main.asm
LIBS_=${LIB} ${STACK} ${IO}

INC=lib.inc stack.inc io.inc

LIB_SRC=lib.asm
LIB=lib.o

STACK_SRC=stack.asm
STACK=stack.o

IO_SRC=io.asm
IO=io.o

NASM_OPTS=-f elf -g

all: ${BIN}
${BIN}: ${LIB} ${OBJ} ${STACK} ${IO}
	ld -m elf_i386 -o ${LIB} ${OBJ} ${STACK} ${IO}

${OBJ}: ${SRC} ${INC}
	nasm ${NASM_OPTS} ${SRC}

${LIB}: ${LIB_SRC}
	nasm ${NASM_OPTS} ${LIB_SRC}

${STACK}: ${STACK_SRC}
	nasm ${NASM_OPTS} ${STACK_SRC}

${IO}: ${IO_SRC}
	nasm ${NASM_OPTS} $<

clean: 
	rm -f ${FOLDER}/*.out ${FOLDER}/*.o ${LIB}

run: ${BIN}
	./${BIN}

debug: ${BIN}
	gdb ${BIN}
