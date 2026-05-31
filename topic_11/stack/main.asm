; who:  David Zhou Cao
; what: 
; why:  
; when: 
 
%include "lib.inc"
%include "topic_11/stack/stack.inc"

section .text
global _start

_start:
    mov     edi, 0
    mov     ecx, 10

    ; make a stack from 1-10
    .loop: 
    push    ecx
    push    edi
    call    stk_push
    add     esp, 4
    pop     ecx
    mov     edi, eax

    loop    .loop

    ; print the values and pop 
    .while:
    test    edi, edi
    jz      .wend

    ; print value in head
    push    edi
    call    stk_peek
    push    eax

    ; print: "#, #, #, ..." 
    call    print_uint
    add     esp, 4

    push    comma_str
    call    print
    add     esp, 4

    ; pop 
    call    stk_pop
    add     esp, 4
    mov     edi, eax

    jmp     .while
    .wend:
    call    endl

    push    DWORD 0
    call    exit

section .bss
; uninitialized data here
section .data
comma_str:      db  ", ", 0