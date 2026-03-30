;who:   David Zhou Cao
;what:  practice making a loop to summation an array
;why:   to practice
;when:  3/24/26

%include "lib.inc"

section .text
global _start
_start:
    mov     ecx, array_qty      ;initialize the loop counter; aka i < array.length
                                ;for exam: 
                                ;   ECX: loop counter
                                ;   ESI: array pointer
                                ;   EAX: running sum
    mov     esi, array          ;counter/array pointer; aka int i = 0
    mov     eax, 0    

    .loop:
    add     eax, [esi]          ;add array elements to running sum
    add     esi, 4              ;increment arrayPointer
    dec     ecx
    jnz     .loop
    
    mov     [sum], eax

    ; eax = sum
    mov     ebx, buffer
    call    itoa

    mov     ebx, buffer
    add     ebx, eax
    mov     BYTE [ebx], 0x0a
    inc     eax

    ; print
    mov     edx, eax
    mov     ecx, buffer
    mov     ebx, 1
    mov     eax, 4              ; writen in this order bc eax

    exit: 
    mov     eax, 1
    mov     ebx, 0
    int     syscall


section .bss
sum:        resd    1
buffer:     resb    buf_sz
buf_sz:     equ     11

section .data
array:      dd      1,2,3,4,5,6,7,8,9,10
array_qty:  equ     ($ - array)/4           ;to get the num of elements
syscall:    equ     0x80