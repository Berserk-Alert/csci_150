;who:   David Zhou Cao
;what:  Arithmetic hw + printing a int range: 0-99
;why:   
;when:  3/22/26

section .text
global  _start
_start:
    ;val1 + val2 - val3 - val4 + val5
    mov     ax, [val1]
    add     ax, [val2]
    sub     ax, [val3]
    sub     ax, [val4]
    add     ax, [val5]
    mov     [sum], ax

print:              ;prints out sum
    mov     ax, [sum]
    ; convert to ASCII (0–99 only)
    mov bl, 10
    xor dx, dx
    div bl        ;ax/bl = sum/10 = 43/10

    ; AL = tens, AH = ones, aka al = 4 & ah = 3 
    ; because al = quotient & ah = remainder
    add al, '0'
    add ah, '0'

    mov [buffer], al
    mov [buffer+1], ah  

    ;syscall print
    mov     eax, 4 
    mov     ebx, 1
    mov     ecx, buffer
    mov     edx, 3      ;size of 3 bytes, 2 for the int and 1 for endl
    int     0x80

exit:   
    mov     eax, 1
    mov     ebx, 0
    int     0x80


section .bss
sum:        resw    1


section .data
val1:       dw  0x09
val2:       dw  0x19
val3:       dw  0x05
val4:       dw  0x14
val5:       dw  0x22
buffer:     db  "00", 0x0a