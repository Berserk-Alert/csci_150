; who:  David
; what: test driver for the array_sum method
; why:  hw and practice
; when: 4.19.26

%include "../../lib.inc"

global  _start
section .text
_start:
    push    arr_sz
    push    arr
    call    sum_array
    add     esp, 8    

    push    BYTE 0
    call    exit

section .bss    


section .data
arr:        dd      0,1,2,3,4,5,6,7,8,9
arr_sz:     equ     ($ - arr)/4