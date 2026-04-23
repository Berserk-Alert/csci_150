; who:
; what: 
; why: 
; when: 

%include "../lib.inc"

global  _start
section .text
_start: 
    push    prompt
    call    print

    push    buff_sz         ; arg2
    push    buffer          ; arg1
    call    getUserInput

    call    println
    add     esp, 12

    push    DWORD 0
    call    exit


section .bss
buffer:         resb    buff_sz
buff_sz:        equ     100

section .data
prompt:        db  "Enter name: ", 0