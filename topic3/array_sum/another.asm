;who:   David Zhou Cao
;what:  practice making a loop to summation an array
;why:   to practice
;when:  3/18/26

section .text
global _start
_start:
    mov     ecx, array_qty      ;initialize the loop counter; aka i < array.length
                                ;for exam: 
                                ;   ECX: loop counter
                                ;   ESI: array pointer
                                ;   EAX: running sum
    mov     esi, array          ;counter/array pointer; aka int i = 0
    mov     eax, 0    

    .loop:
    add     eax, [esi]          ;add array elements to running sum
    add     esi, 4              ;increment arrayPointer
    loop    .loop               ; does 2 things: decrements ecx (ecx -= 1) and checks if ecx != 0, if T loop, if F pass

    mov     [sum], eax

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, sum
    mov     edx, 4
    int     syscall

    exit: 
    mov     eax, 1
    mov     ebx, 0
    int     syscall


section .bss
sum:        resd    1

section .data
array:      dd      1,2,3,4,5,6,7,8,9,10
array_qty:  equ     ($ - array)/4           ;to get the num of elements
syscall:    equ     0x80