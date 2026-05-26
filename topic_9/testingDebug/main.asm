; who:  David Zhou Cao
; what: 
; why:  
; when: 
 
%include "lib.inc"

section .text
global _start

_start:
    mov     eax, array

    push    DWORD 0
    call    exit

section .bss
    ; uninitialized data here
section .data
array:                  dd  5, 5, 13, 1, 11, 2, 3, 4, 12, 0
array_sz:               equ $ - array