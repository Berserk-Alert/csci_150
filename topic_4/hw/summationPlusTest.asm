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

    ;test: increment input
    ;part 1 convert input to int
    mov     edi, buffer         ; mov buffer's[0] addres to edi
    add     edi, eax            ; point edi to end of buffer 'string'
    dec     edi                 ; dec to point to endl char
    mov     BYTE[edi], 0        ; write over with null terminator
    mov     eax, buffer         
    call    atoi                
    ; ;part 2 inc input
    ; inc     eax
    ; ;part 3 convert int to char for printing
    ; mov     ebx, buffer
    ; call    itoa
    ; mov     edi, buffer         ;line 37-40: add endl to buffer, same way as in part 1
    ; add     edi, eax
    ; mov     BYTE[edi], 0x0a
    ; inc     eax                 ;add endl

    ;summation algorithm
    mov     ecx, eax
    xor     eax, eax

    .loop:
    add     eax, ecx
    dec     ecx
    jnz     .loop 

    mov     [sum], eax
    mov     ebx, buffer
    call    itoa
    mov     ebx, buffer
    add     ebx, eax
    mov     BYTE[ebx], 0x0a
    inc     eax

    ;print user input
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