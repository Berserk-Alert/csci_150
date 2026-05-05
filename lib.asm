; who:  David Zhou Cao
; what: library of procedures
; note: responsibility: ebx, ebp, esp, edi
;       arg1 @ ebp + 8

;-------------------------------------------------------------------------------
global itoa
itoa:
;
; Description:  given a 32b unsigned int, return a null termintated string 
;               representation
; Receives:     arg1: address FOR the null terminated string 32b
;               arg2: 32b unsigned int value
; Returns:      EAX: quantity of characters in the string
; Requires:      
; Notes:        - arg1 must be an array of 10 bytes long
; Algo:         Horner's method
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    edi                     ; preserve EDI
    push    DWORD 10                ; local var storing BASE10
    push    DWORD 48                ; local var storing DIGIT_OFFSET

    mov     edi, [ebp + 8]          ; EDI = array pointer
    mov     eax, [ebp + 12]         ; EAX = int value

    ; edge case for 
    test    eax, eax                ; if EAX != 0
    jnz     .endif                  ; jump out, else continue
    inc     eax                     ; string has 1 char, 0 itself
    mov     BYTE [edi], '0'         ; store '0' in string
    inc     edi                     ; set up for null termi.
    jmp     .exit
    .endif:

    xor     ecx, ecx                ; ECX = char counter

    .while:
    cmp     eax, 0
    jz      .wend

    mov     edx, 0                  ; prep EDX for div
    div     DWORD [ebp - 4]         ; EAX / 10
    ;add     edx, DWORD [ebp - 4]          
    add     edx, DIGIT_OFFSET       ; convert to char
    push    edx                     ; store char in stack
    inc     ecx                     ; ++char counter
    jmp     .while
    .wend:

    mov     eax, ecx                ; for return: quantity of chars in string

    ; pop chars from stack into arg1
    .loop:
    pop     edx                     ; char val
    mov     BYTE [edi], dl               ; store char val (BYTE) into string array
    inc     edi
    loop    .loop

    .exit:
    mov     [edi], BYTE 0                ; add nul terminator

    pop     edi                     ; restore EDI
    leave
    ret
; end itoa

;-------------------------------------------------------------------------------
global atoi
atoi:
;
; Description:  given a null terminated string of a 32b unsigned int, return it as a number
;               convert the string representation of a number into its number
; Receives:     arg1: address of the null terminated string 32b
; Returns:      EAX: unsigned int value
; Requires:     NULL, BASE10 
; Notes:        ret 0 for an invalid string
; Algo:         Horner's method
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi

    mov     eax, 0                  ; eax = accumulate int
    mov     esi, [ebp + 8]          ; esi = arg1[0]     ; array pointer
    mov     ecx, DWORD BASE10

    .while:
    cmp     BYTE[esi], 0            ; break out if we reach the nul char
    jz      .wend

    mul     ecx                     ; eax *= 10
    movzx   edx, BYTE[esi]          ; EDX = char code   ; convert the BYTE into a DWORD
    add     eax, edx                ; eax += edx
    sub     eax, DWORD DIGIT_OFFSET

    inc     esi
    jmp     .while
    .wend:

    pop     esi
    leave
    ret
; end atoi

;-------------------------------------------------------------------------------
;global dec_to_bin
;dec_to_bin:
;
; Description:  returns a nul terminated string representation of the decimal 
;               value in binary
; Receives:     arg1: address of the dec val (32b)
;               arg2: buffer address to store the bin
;               buffer must be 33 bits big to store the 32b value and nul char
; Returns:      na
; Requires:     
;-------------------------------------------------------------------------------

; end dec_to_bin

;-------------------------------------------------------------------------------
;global dec_to_hex
;dec_to_hex:
;
; Description:  returns a nul terminated string representation of the decimal 
;               value in hex
; Receives:     arg1: address of the dec val (32b)
;               arg2: buffer address to store the hex
;                     buffer must be 9 bits big to store the 8 hex char value and nul char
; Returns:      na
; Requires:     
;-------------------------------------------------------------------------------

; end dec_to_hex

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

;-------------------------------------------------------------------------------
global class_sum_array
class_sum_array:
;
; Description:  sums the values in an array of 32b elements
; Receives:     arg1: address of the array
;               arg2: num of elements
; Returns:      EAX = sum
; Requires:     rec_array_sum
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp

    mov     ecx, [ebp + 12]         
    push    ecx
    push    DWORD [ebp + 8]
    call    rec_array_sum
    add     esp, 8

    pop     ebp 
    ret
; end sum_array

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
global  to_upper_inclass
to_upper_inclass:
;
; takes in a null-terminated string arg1, converts all lower case alphabet characters 
;   to upper case. Made in class using alter_char_by_range
; Receives:     arg1: address of the string 
; Returns:      na
; Requires:     alter_char_by_range
;-------------------------------------------------------------------------------
    push    ebp
    mov     esp, ebp

    push    DWORD -32               ; offset to upper case
    push    DWORD 'z'
    push    DWORD 'a'
    push    DWORD [ebp + 8]
    call    alter_char_by_range


    mov     esp, ebp                ; practically does this --> add     esp, 16 (aka, clean the args)
    pop     ebp
    ret
; end to upper inclass

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
; Requires: constant var endl_char = db 0x0a, 
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

; private methods bellow

;------------------------------------------------------------------------------
alter_char_by_range:
;
; Description:  alter the characters of nul terminated string in a range 
;               based on a character code
; Receives:     arg1: address of the nul terminated string
;               arg2: start of the range (inclusive)
;               arg3: end of the range (inclusive)
;               arg4: offset
; Returns:      na
; Requires:     na
; Notes:        na
;-------------------------------------------------------------------------------
    push    ebp
    mov     esp, ebp
    push    ebx
    
    mov     cl, BYTE [ebp + 12]         ; ecx = start
    mov     dl, BYTE [ebp + 16]         ; edx = end
    mov     eax, [ebp + 20]         ; eax = offset (arg4)
    shl     eax, 8                  ; ah = offset

    mov     ebx, [ebp + 8]          ; ebx = string pointer = arg1
    .while:
    mov     al, [ebx]               ; al = char unders inspection
    test    al, al                  ; if al is nul terminater, end loop
    jz      .wend

    cmp     al, cl                 ; al < start (arg2)
    jb      .endif                  
    cmp     al, dl                 ; al > end (arg3)
    ja      .endif
    
    add     al, ah                  ; add offset
    mov     [ebx], al               ; store to string

    .endif:
    inc     ebx
    jmp     .while
    .wend:

    pop     ebx
    pop     ebp
    ret
; end alter char by range

;-------------------------------------------------------------------------------
rec_array_sum:
;
; Description:  recursively sum an array
; Receives:     arg1: address of the array
;               arg2: num of elements
; Returns:      EAX = sum
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi 

    mov     eax, 0
    mov     ecx, [ebp +12]
    test    ecx, ecx            ; ecx == 0 ?
    je      .base_case

    .recursive_case:
    mov     esi, [ebp + 8]      ; esi = 1st value in array
    add     esi, 4              ; go to next element
    dec     ecx                 ; dec size
    push    ecx                 ; push arg2
    push    esi                 ; push arg1
    call    rec_array_sum       ; recursion
    add     esp, 8              ; clean stack
    add     eax, [esi - 4]      ; sum = &array      (-4 to accound for add 4 in line 490)

    .base_case:
    pop     esi
    pop     ebp     
    ret 
; end rec_array_sum

; CONSTANTS
section .data   
endl_char:      db  0x0a
NUL:            equ 0
NULL:           equ NUL         ; incase of typos
BASE10:         equ 10
DIGIT_OFFSET:   equ 48