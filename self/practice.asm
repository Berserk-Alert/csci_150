;who:   
;what:  
;why:   
;when:  

global  _start
section .text
_start:
    mov     ecx, 10

    .loop:
    mov     eax, [temp]
    mov     eax, (10 - ecx)
    loop


exit: 
    mov     eax, 1
    mov     ebx, 0
    int     0x80

section .bss
; buffer:     rest    1

section .data

temp:       db      '1', 0x0a
buffer:     db      0, 10
array:      db      "1,2,3,4,5,6,7,8,9,0"
endline:    db      10
array2:     db      'look at that, we have a on overflow'
