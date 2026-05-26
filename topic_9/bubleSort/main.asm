%include "lib.inc"

global  _start
section .text
_start:
    push    DWORD array_sz / 4
    push    DWORD array
    call    print_uint_array
    call    endl
    
    call    bubble_sort

    call    print_uint_array
    call    endl
    add     esp, 8

    push    DWORD 0
    call    exit
section .bss

section .data
array:          dd  5, 3, 8, 1, 9, 2, 7, 4, 6, 0
array_sz:       equ $ - array