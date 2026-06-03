; who:  David Zhou Cao
; what: 
; why:  
; when: 
 
%include "../../lib.inc"
%define syscall int 0x80

section .text
global _start

_start:
    mov     edi, esi

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
    push    esi
    call    read_file
    add     esp, 4

    cmp     eax, 0
    jl      .wend

    push    eax
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

section .text           ; for procedures
;-------------------------------------------------------------------------------
open_file:
;
; Description:  Opens file for read only
; Receives:     arg1: file path address (nul terminated string)
; Returns:      eax:  file descriptor
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, 5
    mov     ebx, [ebp - 8]
    mov     ecx, 0
    mov     edx, 0o777          ; set permission bytes in octal
    syscall

    pop     ebx
    leave
    ret
; end open_file -----------------------------------------------------

;-------------------------------------------------------------------------------
create_file:
;
; Description:  create a file
; Receives:     arg1: file path address (nul terminated string)
; Returns:      eax:  file descriptor
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, 8
    mov     ebx, [ebp + 8]
    mov     ecx, 0o777
    syscall

    pop     ebx
    leave
    ret
; end create_file -----------------------------------------------------

;-------------------------------------------------------------------------------
read_file:
;
; Description:  read into buffer (output) from file (input)
; Receives:     arg1: file descriptor
; Returns:      eax:  number of bytes read
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, 3  
    mov     ebx, [ebp + 8]
    mov     ecx, buffer             ; hardcoded buffer, fix if you want to use it for other applications
    mov     edx, BUFF_SZ
    syscall


    pop     ebx
    leave
    ret
; end read_file -----------------------------------------------------

;-------------------------------------------------------------------------------
write_file:
;
; Description:  write into a file (output) from buffer (input)
; Receives:     arg1: file descriptor
;               arg2: size of the buffer
; Returns:      eax:  number of bytes read
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, 3  
    mov     ebx, [ebp + 8]
    mov     ecx, buffer             ; hardcoded buffer, fix if you want to use it for other applications
    mov     edx, [ebp + 12]
    syscall

    pop     ebx
    leave
    ret
; end read_file -----------------------------------------------------

;-------------------------------------------------------------------------------
close_file:
;
; Description:  close a file
; Receives:     arg1: file descriptor
; Returns:      na
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, 6
    mov     ebx, [ebp + 8]
    syscall

    pop     ebx
    leave
    ret
; end close_file -----------------------------------------------------