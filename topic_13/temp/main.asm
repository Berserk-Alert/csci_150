; who:  David Zhou Cao
; what: file_copy
; why:  
; when: 
 
%include "lib.inc"
%include "io.inc"

global _start
section .text

_start:
    mov     edi, esi

    call    endl

    ; open the src file
    push    src; [esp + 8]
    call    open_file
    add     esp, 4
    mov     esi, eax

    ; creat the destination (dst) file
    push    dst;    [esp + 12]
    call    open_file
    add     esp, 4
    mov     edi, eax

    ; buffer by buffer read from src, write to dst
    .while:
    push    DWORD BUFF_SZ
    push    buffer 
    push    esi
    call    read_file
    add     esp, 4

    cmp     eax, 0
    jl      .wend

    push    eax
    push    buffer
    push    edi
    call    write_file
    add     esp, 8

    jmp     .while
    .wend:

    ; close src and dst
    push    esi
    call    close_file
    push    edi
    call    close_file
    add     esp, 8

    push    DWORD 0
    call    exit

section .bss
buffer:     resb    BUFF_SZ
BUFF_SZ:    equ     4096

section .data
src:        db      "asdf2.txt", 0
dst:        db      "holo.txt", 0