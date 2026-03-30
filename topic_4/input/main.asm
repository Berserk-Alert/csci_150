; when:     3/24/26

%include "lib.inc"
global  _start

section .text
_start:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, prompt
    mov     edx, prompt_sz
    int     0x80

    ; standard in
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, buffer
    mov     edx, buf_sz
    int     0x80

    mov     edi, buffer
    add     edi, eax
    dec     edi

    mov     edx, eax        ;stardard in - stores the string into 'buffer' and the string.length into eax
    mov     ecx, buffer
    mov     ebx, 1
    mov     eax, 4
    int     0x80    

    mov     BYTE[edi], 0
    mov     eax, buffer
    call    atoi


exit:
    mov     eax, 1
    mov     ebx, 0
    int     0x80

section .bss

buffer:         resb    buf_sz
buf_sz:         equ     100


section .data

prompt:         db      "Enter age: "
prompt_sz:      equ     $ - prompt
