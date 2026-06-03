; who:  David Zhou Cao
; what: 
; why:  
; when: 
 
%include "lib.inc"

section .text
global _start

_start:
    mov     eax, 4  
    mov     ebx, 1
    mov     ecx, test_str
    mov     edx, test_str_length
    int     0x80

    push    DWORD 0
    call    exit

section .bss

section .data
test_str:           db  "testing, hello world"
test_str_length:    equ  $ - test_str