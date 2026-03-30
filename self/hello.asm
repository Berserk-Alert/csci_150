



Global      _start
section     .text

_start:
    mov     EAX, 4
    mov     EBX, 1
    mov     ECX, msg
    mov     EDX, msg_e
    int     0x80

    ; mov     EAX, 3
    ; mov     EBX, 2
    ; mov     ECX, input1

exit:
    mov     EBX, 0
    mov     EAX, 1
    int     0x80

section     .bss
input1  resw    1
input2  resw    1


section     .data
msg     db      "Hello assembly", 0x0a
msg_e   equ     $ - msg