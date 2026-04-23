; who:  David Zhou Cao
; what: stringop hw test driver
; why: 
; when 4.19.26

%include "../../lib.inc"

global  _start
section .text
_start:
    ; testing to_lower
    push    header1
    call    println
    push    test1
    call    println
    call    to_lower
    call    println
    call    endl
    add     esp, 8

    ; testing to_upper
    push    header2
    call    println
    push    test2
    call    println
    call    to_upper_inclass
    call    println
    call    endl
    add     esp, 8

    ; testing to_sentence_case
    ; testing to_upper
    push    header3
    call    println
    push    test3
    call    println
    call    to_sentence_case
    call    println
    call    endl
    add     esp, 8

    push    DWORD 0
    call    exit

section .bss

section .data
header1:        db  "test to_lower", 0
header2:        db  "test to_upper", 0
header3:        db  "test to_sentence_case", 0
test1:          db  "Write 3 GLOBAL PrOCedUrEs in your lib.asm file.", 0
test2:          db  "Write 3 GLOBAL PrOCedUrEs in your lib.asm file.", 0
test3:          db  "write 3 GLOBAL PrOCedUrEs in your lib.asm file.", 0