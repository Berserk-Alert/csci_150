; David Zhou Cao
; practice eflags
; 
; 3/19/26

global  _start

section .text
_start:
    mov     eax, [val1]
    add     eax, [val2]
    inc     DWORD[val1]
    neg     eax

exit:
    mov     eax, 1
    mov     ebx, 0
    int     0x80

section .data
val1:       dd      5
val2:       dd      100

