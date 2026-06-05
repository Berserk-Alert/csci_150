%define syscal int 0x80
section .text           ; for procedures

;-------------------------------------------------------------------------------
global open_file
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
global create_file
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
    mov     ecx, 0o660
    syscall

    pop     ebx
    leave
    ret
; end create_file -----------------------------------------------------

;-------------------------------------------------------------------------------
global read_file
read_file:
;
; Description:  read into buffer (output) from file (input)
; Receives:     arg1: file descriptor
;               arg2: address of the buffer
;               arg3: size of the buffer
; Returns:      eax:  number of bytes read
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, 3  
    mov     ebx, [ebp + 8]
    mov     ecx, [ebp + 12]             ; hardcoded buffer, fix if you want to use it for other applications
    mov     edx, [ebp + 16]
    syscall


    pop     ebx
    leave
    ret
; end read_file -----------------------------------------------------

;-------------------------------------------------------------------------------
global write_file
write_file:
;
; Description:  write into a file (output) from buffer (input)
; Receives:     arg1: file descriptor
;               arg2: address of the buffer
;               arg3: size of the buffer
; Returns:      eax:  number of bytes read
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, 3  
    mov     ebx, [ebp + 8]
    mov     ecx, [ebp + 12]             ; hardcoded buffer, fix if you want to use it for other applications
    mov     edx, [ebp + 16]
    syscall

    pop     ebx
    leave
    ret
; end read_file -----------------------------------------------------

;-------------------------------------------------------------------------------
global close_file
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