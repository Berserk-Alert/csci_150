; who: Orion Chen
; what: test

global _start

section .txt 

_start:
    mov     EAX,    4
    mov     EBX,    1
    mov     ECX,    hello
    mov     EDX,    helloL
    int     0x80

    mov     EAX,    4
    mov     EBX,    1
    mov     ECX,    intro
    mov     EDX,    introL
    int     0x80

    mov     EAX,    3
    mov     EBX,    2
    mov     ECX,    input1
    mov     EDX,    2
    int     0x80

    mov     EAX,    3
    mov     EBX,    2
    mov     ECX,    input1 + 2
    mov     EDX,    2
    int     0x80

add:
    xor     ax,     ax
    mov     ax,     [input1 + 0]
    add     ax,     [input1 + 2]
    mov     [sum],    ax
    int     0x80

    mov     EAX,    4
    mov     EBX,    1
    mov     ECX,    sum
    mov     EDX,    2                                                       ; the length of sum is 1
    int     0x80
    
    

exit:
    mov     EAX,     1
    mov     EBX,     0   
    int     0x80                                                        ; calls the kernal
    
    


section .data

hello:      db      "Hello, Welcome to adding Caluclulator", 0x0a         ; declaring message
helloL:     equ     $ - hello                                             ; hello's length
intro:      db      "Please enter 2 Integers", 0x0a
introL:     equ     $ - intro

section .bss

input1:     resw    2
sum:        resw    1

