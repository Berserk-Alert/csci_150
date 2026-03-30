;who:   David Zhou Cao
;what:  summation hw
;why:   practic user input, loops, and lib.o
;when:  3/29
%include "lib.inc"

global  _start
section .text
_start:
    ;print prompt
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, prompt
    mov     edx, prompt_sz
    int     0x80

    ;user input
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, buffer
    mov     edx, buf_sz
    int     0x80
    
    ;convert atoi
    mov     edi, buffer
    add     edi, eax
    dec     edi
    mov     BYTE[edi], 0
    mov     eax, buffer         
    call    atoi     

    ;to do: complete for 0 and neg case

    ;summation algorithm
    mov     ecx, eax
    xor     eax, eax

    .loop:
    add     eax, ecx
    dec     ecx
    jnz     .loop 

    ;convert itoa and add endl
    mov     [sum], eax
    mov     ebx, buffer
    call    itoa
    mov     ebx, buffer
    add     ebx, eax
    mov     BYTE[ebx], 0x0a
    inc     eax

    ;print sum
    mov     edx, eax
    mov     ecx, buffer
    mov     ebx, 1
    mov     eax, 4
    int     0x80

exit: 
    mov     eax, 1
    mov     ebx, 0
    int     0x80

section .bss
sum:        resd    1
buffer:     resb    buf_sz
buf_sz:     equ     100

section .data
prompt:     db      'Welcome to the summation calculator', 0x0a, 'Please enter a number: '
prompt_sz:  equ     $ - prompt
syscall:    db      0x80