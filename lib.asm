; who:  David Zhou Cao
; what: library of procedures
; note: responsibility: ebx, ebp, esp, edi
;       arg1 @ ebp + 8

;-------------------------------------------------------------------------------
global sum_array
sum_array:
;
; Description:  sums the values in an array of 32b elements
; Receives:     arg1: address of the array
;               arg2: the size of the array
;                     note: number of elements in the array
; Returns:      EAX = sum
; Requires:     Nothing
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi

    ; base case
    mov     ecx, [ebp + 12]             ; ecx = arg2  
    cmp     ecx, 0                      ; if arg2 == 0, return base case
    jle     .base

    ; recursive case
    dec     ecx
    push    ecx                         ; arg2 for recursion
    mov     esi, [ebp + 8]              ; esi = arg1
    push    esi                         ; arg1 for recursion
    call    sum_array
    add     esp, 8                      ; clean stack of args

    ; sum to eax AFTER recursion
    mov     esi, [ebp + 8]              ; reload arr
    mov     ecx, [ebp + 12]             ; reload og size
    dec     ecx
    add     eax, [esi + ecx*4]          ; sum += arr[size - 1]
    jmp     .return

    .base:
    mov     eax, 0;                     ; clean eax to hold sum when base case runs
    .return:
    pop     esi
    mov     esp, ebp
    pop     ebp
    ret
 
; End sum_array------------------------------------------------------

;------------------------------------------------------------------------------
global  to_sentence_case
to_sentence_case:
;
; takes in a null-terminated string arg1, converts the first letter to upper case
;   and the folowing letters to lower case
; Receives:     arg1: address of the string 
; Returns:      na
; Requires:     to_lower
; Note:         can't distinguish sentences; it will only capitalize the first 
;               letter of the given string
;-------------------------------------------------------------------------------
    push    ebp 
    mov     ebp, esp
    push    esi
    
    mov     esi, [ebp + 8]          ; arg1 in esi

    ; check if first letter is capitalized
    cmp     BYTE[esi], 97          
    jl      .notLowerCase
    cmp     BYTE[esi], 122
    jg      .notLowerCase
    sub     BYTE[esi], 32           
    .notLowerCase:

    ; call to_lower to fix the following letters
    inc     esi
    push    esi
    call    to_lower
    add     esp, 4                  ; clean args

    pop     esi
    mov     esp, ebp
    pop     ebp
    ret
; end to_sentence_case

;------------------------------------------------------------------------------
global  to_upper
to_upper:
;
; takes in a null-terminated string arg1, converts all lower case alphabet characters 
;   to upper case.
; Receives:     arg1: address of the string 
; Returns:      na
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi

    mov     esi, [ebp + 8]          ; get arg1 and put into esi

    .whileNotNull:
    cmp     BYTE[esi], 0            ; look through string until null terminator
    jz      .wEnd

    ; check if char is a lower case letter               
    cmp     BYTE[esi], 97          
    jl      .notLowerCase
    cmp     BYTE[esi], 122
    jg      .notLowerCase
    sub     BYTE[esi], 32           ; if yes, change, else continue
    
    ; move to next char and repeat
    .notLowerCase:
    inc     esi
    jmp     .whileNotNull
    .wEnd: 

    pop     esi
    mov     esp, ebp
    pop     ebp
    ret

; end to_upper

;------------------------------------------------------------------------------
global  to_lower
to_lower:
;
; takes in a null-terminated string arg1, converts all upper case alphabet characters 
;   to lower case.
; Receives:     arg1: address of the buffer to store user input
; Returns:      na
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi

    mov     esi, [ebp + 8]          ; get arg1 and put into esi

    .whileNotNull:
    cmp     BYTE[esi], 0            ; look through string until null terminator
    jz      .wEnd

    ; check if char is a upper case letter               
    cmp     BYTE[esi], 65           
    jl      .notUpperCase
    cmp     BYTE[esi], 90
    jg      .notUpperCase
    add     BYTE[esi], 32           ; if yes, change, else continue
    
    ; move to next char and repeat
    .notUpperCase:
    inc     esi
    jmp     .whileNotNull
    .wEnd: 

    pop     esi
    mov     esp, ebp
    pop     ebp
    ret
; end to_lower

;------------------------------------------------------------------------------
global  getUserInput
getUserInput:
;
; read input from the user 
; Receives:     arg1: address of the buffer to store user input
;               arg2: size of the buffer
; Returns:      EAX = char qty
;               a null terminated string in the provided buffer
; Requires:     na
;-------------------------------------------------------------------------------
    push    ebp                 ; caller's base p
    mov     ebp, esp            ; set up procedure's stack frame
    push    ebx                 

    ; std in
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, [ebp + 8]      ; args are pushed in reverse order, ie push arg2, then push arg1
    mov     edx, [ebp +12]
    int     0x80

    ; add nul terminator
    mov     ebx, [ebp + 8]      ; ebx = buffer pointer to first char
    dec     eax                 ; last char is nul terminator
    add     ebx, eax            ; shift ebx to point to end of the string
    mov     BYTE[ebx], 0        ; add nul 
    
    pop     ebx
    pop     ebp
    ret
; End getUserInput --------------------------------------------------------------------

;------------------------------------------------------------------------------
global  println
println:
;
; prints a null-terminated string to stdout and then a endl char
; Receives: arg1: address of the null-terminated string
; Returns:  EAX: number of characters
; Requires: strlen, print, and endl
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi

    ; print the given string
    mov     esi, [ebp + 8]
    push    esi
    call    print
    add     esp, 4
    call    endl

    pop     esi
    pop     ebp
    ret
; end println

;------------------------------------------------------------------------------
global  endl
endl:
;
; just prints a next line character
; Receives: na
; Returns:  na
; Requires: na
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    ebx

    mov     eax, 4
    mov     ebx, 1
    mov     ecx, endl_char
    mov     edx, 1
    int     0x80

    pop     ebx
    pop     ebp
    ret
; End endl

;------------------------------------------------------------------------------
global  print
print:
;
; prints a null-terminated string to stdout
; Receives: arg1: address of the null-terminated string
; Returns:  EAX: number of characters
; Requires: strlen
;-------------------------------------------------------------------------------
    push    ebp                 ; caller's base p
    mov     ebp, esp            ; set up procedure's stack frame
    push    ebx                 ; save ebx
    push    esi                 ; preseve esi

    ; get length
    mov     esi, [ebp + 8]      ; esi = string address
    push    esi                 ; pass argument to srlen
    call    strlen
    add     esp, 4              ; deallocate argument

    ; std print
    mov     edx, eax            ; edx = length 
    mov     ecx, esi            ; ecx = string address
    mov     ebx, 1
    mov     eax, 4
    int     0x80

    pop     esi                 ; restore reg
    pop     ebx             
    pop     ebp
    ret

; End print --------------------------------------------------------------------

;------------------------------------------------------------------------------
global  strlen
strlen:
;
; Returns the number of characters in a null terminated string
; Receives: arg1: address of the null terminated string
; Returns:  EAX: number of characters
; Requires: na
; Notes:    na
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp            ; setup stack frame

    push    esi                 ; preserve register
    mov     esi, [ebp + 8]      ; esi = string address
    mov     eax, 0              ; eax = char count

    .while:
    cmp    BYTE[esi], 0        ; test for null terminator? set zero flag : nothing
    jz      .wend               ; jump if zf set
    inc     esi
    inc     eax
    jmp     .while

    .wend: 
    
    ; restore register
    pop     esi
    mov     esp, ebp        
    pop     ebp
    ret
    
; End  strlen -------------------------------------------------------


;------------------------------------------------------------------------------
global  exit
exit:
;
; regular exit program
; Receives: arg1: exit code
; Returns:  na
; Requires: na
; Notes:    na
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp

    mov     ebx, [ebp + 8]      ;load exit code
    mov     eax, 1
    int     0x80

    mov     esp, ebp
    pop     ebp
    ret
    
; End  exit -------------------------------------------------------

section .data   
endl_char:       db  0x0a