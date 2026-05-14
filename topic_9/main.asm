; who:  
; what:     
; why:
; when:

%include "lib.inc"

global  _start  
section .text
_start:
.c1:        equ     1103515245
.c2:        equ     12345
.RAND_MAX:  equ     32768

    push    DWORD .c1
    push    lo
    call    mul64

    push    DWORD 0 
    call    exit

section .bss 

section .data
lo:         dq 0xffffffff