global _start

section .data
    arr     dd  0,1,2,3,4,5,6,7,8,9   ; 10 doublewords (4 bytes each)
    arr_sz  equ $ - arr                ; total byte size = 40

section .text
_start:

    mov eax, 0              ; eax will accumulate the sum
    mov ecx, arr_sz / 4     ; ecx = number of elements (40/4 = 10)
    mov esi, [arr]              ; esi = array index

.loop:
    cmp ecx, 0              ; are there elements left?
    je  .done

    add eax, esi  ; eax += arr[esi]

    add esi, 4             ; next index
    dec ecx                 ; one less element
    jmp .loop

.done:
    ; eax now holds the sum (0+1+2+...+9 = 45)

    mov ebx, 0
    mov eax, 1              ; syscall: exit
    int 0x80