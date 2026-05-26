; who:  
; what:     
; why:
; when:

%include "lib.inc"

global  _start  
section .text
_start:
    call    rand
    push    eax
    call    print_uint
    call    endl

    call    rand
    push    eax
    call    print_uint
    call    endl

    call    rand
    push    eax
    call    print_uint
    call    endl

    add     esp, 12

    push    DWORD 0 
    call    exit

    ; test mul 64
    ; push    DWORD [qw + 4]
    ; push    DWORD [qw]
    ; push    DWORD 2
    ; call    mul64_var1
    ; add     esp, 4
    ; pop     DWORD [qw]
    ; pop     DWORD [qw + 4]

section .bss 
buffer:     resb    32

section .data
qw:         dq 0xffffffff

;-------------------------------------------------------------------------------
add64_var1:

; Description:  adds a unsigned 32b value to a unsigned 64b value
; Receives:     arg1: address of 64b double precision (qword)
;               arg2: 32b value
; Returns:      sum stored in the address of arg1
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    ; reservations
    push    esi

    mov     esi, [ebp + 8]          ; esi = qword address
    mov     eax, [esi]              ; eax = low order (dword) of the qword
    adc     eax, [ebp + 12]         ; eax = eax + arg2
    jnc     .end_carry_flag         ; jump if no overflow from adc
    inc     DWORD [esi + 4]
    mov     [esi], eax
    .end_carry_flag:

    ; restorations
    pop     esi
    leave
    ret
; end add64_var1



;-------------------------------------------------------------------------------
mul64_var1:
;
;
; Description:  multiplies a double precision 64b value by a single precision value
; Receives:     arg1: address of 64b double precision
;               arg2: multiplier
; Returns:      product stored in the address of arg1
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    ebx

    mov     ebx, [ebp + 8]
    mov     ecx, [ebp + 12]
    mov     eax, ecx
    mul     DWORD [ebx]
    push    edx
    mov     [ebx], eax
    mov     eax, [ebx + 4]
    mul     ecx
    add     eax, [esp]
    add     esp, 4
    mov     [ebx + 4], eax

    pop     ebx
    leave 
    ret 
; end mul64
