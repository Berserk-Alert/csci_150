; who:  
; what:     
; why:  
; when: 

%include "lib.inc";

global  _start
section .text

_start:

    mov     eax, n 
    and     eax, eax
    jz      convert_value

fib_algo:
    mov     ecx, n

    .loop:
    mov     eax, [next]
    mov     [temp], eax
    add     eax, [prev]
    mov     [next], eax
    mov     eax, [temp]
    mov     [prev], eax
    loop    .loop

convert_value: 
    mov     eax, prev
    mov     ebx, buffer
    call    itoa
    call    print_str
    call    print_nl

exit: 
    mov     eax, 1
    mov     ebx, 0
    int     0x80

section .bss
temp:       resd    1
buffer:     resb    12


section .data
nl:         db      0x0a
prev:       dd      0
next:       dd      1
n:          equ     5


section .text

print_nl:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, nl
    mov     edx, 1
    int     0x80
    ret

print_str:
    mov     edx, eax
    mov     ecx, buffer             ;string rep of prev (which holds the fibonacci final value)
    mov     ebx, 1
    mov     eax, 4
    int     0x80
    ret