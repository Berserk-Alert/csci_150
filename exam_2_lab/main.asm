; who: 
; what: 
; why: 
; when:

%include "lib.inc"

global  _start
section .text   
_start:
    push    elem_qty
    push    int_array
    ;call print_uint_array

    call    selection_sort


    push    DWORD 0
    call    exit

section .bss 

section .data 
test:           db  'hello world', 0
int_array:      dd  42, 25, 11, 12, 14, 64, 23, 0
int_array_sz:   equ $ - int_array
elem_qty:        equ int_array_sz/4 