; who:  David Zhou Cao
; what: sort and search test driver
; why:  to test the procedure "binary search" and "bubble sort"
; when: 5/24/26

%include "lib.inc"

global  _start
section .text
_start:
    lea     esi, array

    

exit:
    push    DWORD 0
    call    exit

section .bss

section .data
hi:         db  "hello world", 0
array:      dd  10, 20, 40, 30