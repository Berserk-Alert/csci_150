; who:  David Zhou Cao
; what: 
; why:  
; when: 
 
%include "lib.inc"

section .text
global _start

_start:
    push    DWORD 0
    call    malloc

    push    DWORD 8
    call    malloc

    push    DWORD 8
    call    free

    push    DWORD 8
    call    malloc

    push    DWORD 0
    call    exit

section .bss
; uninitialized data here
section .data
