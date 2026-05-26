; who:  David Zhou Cao
; what: sort and search test driver
; why:  to test the procedure "binary search" and "bubble sort"
; when: 5/24/26

%include "lib.inc"

global  _start
section .text
_start:
    mov     eax, array
    push    DWORD [eax]
    call    print_uint
    call    endl

    push    DWORD array_sz / 4   ; arg2 = number of elements (40 / 4 = 10)
    push    DWORD array           ; arg1 = address of array
    call    bubble_sort_claude
    add     esp, 8              ; clean up args

    mov     eax, array
    push    DWORD [eax]
    call    print_uint
    call    endl

    .exit:
    push    DWORD 0
    call    exit

section .bss

section .data
hi:         db  "hello world", 0
array:        dd  5, 3, 8, 1, 9, 2, 7, 4, 6, 0    ; unsorted array
array_sz:     equ $ - array                           ; size in bytes = 40

;-------------------------------------------------------------------------------
bubble_sort_claude:
;
; Description:  given the address of an array of dword sized elements and the
;               size of the array, perform bubble sort least to greatest
; Receives:     arg1: address of the array
;               arg2: number of elements in the array
; Returns:      nothing, sorts in place
; Requires:     swap
;-------------------------------------------------------------------------------
push    ebp
mov     ebp, esp
sub     esp, 8              ; [ebp - 4] = bool swapped, [ebp - 8] = pass size
push    esi
push    edi

; initialize
mov     esi, [ebp + 8]      ; esi = base address of array
mov     ecx, [ebp + 12]     ; ecx = number of elements
dec     ecx                 ; pass size starts at n-1 comparisons
mov     [ebp - 8], ecx      ; store pass size

.outer:
    ; if pass size == 0, array is sorted
    mov     ecx, [ebp - 8]
    cmp     ecx, 0
    jle     .wend

    mov     DWORD [ebp - 4], 0  ; swapped = false
    mov     esi, [ebp + 8]      ; reset esi to base address
    mov     ecx, [ebp - 8]      ; ecx = number of comparisons this pass

.inner:
    cmp     ecx, 0
    jle     .inner_end

    mov     edi, esi
    add     edi, 4              ; edi = address of next element

    mov     eax, [esi]          ; eax = current element
    cmp     eax, [edi]          ; compare current vs next
    jle     .no_swap            ; if current <= next, no swap needed

    ; swap current and next
    push    edi                 ; arg2 = address of next element
    push    esi                 ; arg1 = address of current element
    call    swap
    add     esp, 8

    mov     DWORD [ebp - 4], 1  ; swapped = true

.no_swap:
    add     esi, 4              ; advance to next element
    dec     ecx
    jmp     .inner

.inner_end:
    ; if no swaps happened, array is sorted — early exit
    mov     eax, [ebp - 4]
    test    eax, eax
    jz      .wend

    ; shrink pass size by 1 (largest element bubbled to end)
    mov     ecx, [ebp - 8]
    dec     ecx
    mov     [ebp - 8], ecx
    jmp     .outer

.wend:
pop     edi
pop     esi
leave
ret
; end bubble_sort -----------------------------------------------------

;-------------------------------------------------------------------------------
bubble_sort:
;
; Description:  given the address of an array of dword sized elements and the 
;               size of the array, perform bubble sort to sort from least to greatest
; Receives:     arg1: address of the array
;               arg2: number of elements in the array
; Returns:      
; Requires:     swap, 
; Notes:        
; Algo:         bubble sort
;-------------------------------------------------------------------------------
    push	ebp
    mov	    ebp, esp
    sub     esp, 4              ; bool1 = if 1, then the array is still unsorted
    push    esi

    ; innitialize args
    lea     esi, [ebp + 8]      ; esi = arg1 or pointer to index 0 of the array
    mov     ecx, [ebp + 12]     ; ecx = arg2
    mov     DWORD [ebp - 4], 1  ; bool1 = 1 or unsorted

    .while:
    mov     eax, [ebp - 4]
    ; while bool1 is 1 and ecx >= 0, keep sorting
    test    eax, eax
    jz      .wend
    cmp     ecx, 0
    jl      .wend

    ; while esi < address of last element, keep sorting
    lea     edx, [ebp + 8]
    add     edx, ecx
    cmp     esi, edx
    jl      .not_reset_esi
    lea     esi, [ebp + 8]      ; reset esi to first index
    mov     DWORD [ebp - 4], 0  ; reset bool1 = sorted
    .not_reset_esi:

    ; if [esi] > [esi + 4], swap(eax, esi) && set bool1 = unsorted
    mov     eax, esi            ; eax = esi
    mov     edx, [eax]
    add     esi, 4              ; esi += 4
    cmp     edx, [esi]
    jle     .if_not
    mov     DWORD [ebp - 4], 1
    push    eax
    push    esi
    call    swap
    add     esp, 8
    .if_not:

    sub     ecx, 4              ; ecx -= 4
    jmp     .while
    .wend:

    pop     esi
    leave
    ret
; end bubble_sort -----------------------------------------------------

;-------------------------------------------------------------------------------
global print_uint_array
print_uint_array:
;
; Description:  print an array of unsigned integers
; Receives:     arg1: address of the array
;               arg2: number of elements in the array
; Requires:     print_uint
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    sub     esp, 3                  ; string1 to store separator: ", NUL"
    push    esi

    ; build separator
    lea     esi, [ebp - 3]
    mov     BYTE [esi], 0x2C        ; esi[0] = ','
    mov     BYTE [esi + 1], 0x20    ; esi[1] = ' '
    mov     BYTE [esi + 2], 0x00    ; esi[2] = 'NUL'

    ; print integer + separator
    mov     ecx, [ebp + 12]         ; counter = arg2
    mov     esi, [ebp + 8]          ; esi = array[0]
    mov     edx, ebp
    sub     edx, 4                  ; edx = address of the separator

    .loop:
    push    DWORD edx
    call    print
    
    pop     esi
    leave
    ret
; end print_uint_array -----------------------------------------------------    