; who:  David Zhou Cao
; what: 
; why:  
; when: 
 
%include "../lib.inc"

section .text
global _start

_start:
    mov     esi, esp

    mov     ecx, [esi]
    
    .loop:
    push    ecx
    add     esi, 4
    push    DWORD [esi]
    call    println
    add     esp, 4

    pop     ecx
    loop    .loop

    push    DWORD 0
    call    exit

section .bss
; uninitialized data here
section .data
; initialized data here