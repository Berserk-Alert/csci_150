;who:   David Zhou Cao
;what:  Arithmetic hw + printing a int range: 0-99
;why:   
;when:  3/22/26

section .text
global  _start
_start:
    ; mov     al, -128
    ; neg     al          ;CF = 0  OF = 1

    ; mov     ax, 8000h
    ; add     ax, 2       ;CF = 0  OF = 0

    ; mov     ax, 0
    ; sub     ax, 2       ;CF = 0  OF = 0

    mov     al, -5
    sub     al, 125     ;CF = 0  OF = 0


exit:   
    mov     eax, 1
    mov     ebx, 0
    int     0x80


section .bss


section .data
