; who:  David Zhou Cao
; what: buble sort and binary search hw
; why:  
; when: 5/24/26

%include "lib.inc"

global  _start
section .text
_start:
    ; test bubble sort
    push    DWORD array_sz / 4
    push    DWORD array
    call    print_uint_array
    call    endl
    
    call    bubble_sort

    call    print_uint_array
    call    endl
    add     esp, 8

    ; test binary search
    push    DWORD 100                ; arg3 = target value
    push    DWORD array_sz / 4
    push    DWORD array
    call    binary_search
    add     esp, 12

    ; print "element not found" if binary search returns -1
    cmp     eax, 0
    jg      .found
    push    element_not_found
    call    println
    jmp     .end

    .found:
    ; since binary search outputs the address of the target element, derefrencing it should give you the
    ; same target value inputed
    push    DWORD [eax]
    call    print_uint
    call    endl   
    add     esp, 4
    
    .end:
    push    DWORD 0
    call    exit
section .bss

section .data
array:                  dd  5, 5, 13, 1, 11, 2, 3, 4, 12, 0
array_sz:               equ $ - array
element_not_found:      db  "element not found", 0
