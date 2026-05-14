; who:  
; what: 
; why:  
; when: 

%include "../lib.inc"
global  _start  
section .text
_start: 
    mov     ebp, esp            ; store 

    push    str
    call    atoi
    add     esp, 4

    push    eax
    push    buffer
    call    itoa

    call    println
    mov     esp, ebp            ; clear args (another way to clear args, but only at the end)

    push    DWORD 0
    call    exit

section .bss 
buffer:         resb    10

section .data
str:            db      "1024", 0