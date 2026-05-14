; who:  
; what: 
; why:  
; when: 

%include "../../lib.inc"

global  _start
section .text
_start:
    mov     eax, 1
    test    eax, eax 
    mov     eax, 0
    test    eax, eax
    

    push    DWORD 0
    call    exit

section .bss        


section .data