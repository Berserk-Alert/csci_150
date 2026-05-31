; who:  David Zhou Cao
; what: library of procedures
; note: responsibility: ebx, ebp, esp, esi, edi
;       arg1 @ ebp + 8
%define     TIME_OP     0x0d
%define     SYSCALL     int 0x80
%define     BRK_OP      0x2d
section .text

;-------------------------------------------------------------------------------
global free
free:
;
; Description:  deallocates heap space
; Receives:     arg1: amount of bytes to deallocate
; Returns:      na
;-------------------------------------------------------------------------------
    push	ebp         
    mov 	ebp, esp
   
    ; get current brk
    push    DWORD [ebp  + 8]    ; malloc(this.arg1)
    neg     DWORD [esp]         ; make it a negative num
    call    malloc              ; eax = brk

    leave
    ret
; end free -----------------------------------------------------

;-------------------------------------------------------------------------------
global malloc
malloc:
;
; Description:  Allocate heap space
; Receives:     arg1: number of bytes to allocated
; Returns:      eax: address of the allocated space
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, BRK_OP
    mov     ebx, 0
    SYSCALL
    
    mov     ebx, [ebp + 8]

    test    ebx, ebx
    jz      .endif

    push    eax
    add     ebx, eax
    mov     eax, BRK_OP
    SYSCALL
    pop     eax

    .endif:

    pop     ebx
    leave
    ret
; end malloc -----------------------------------------------------

;-------------------------------------------------------------------------------
global binary_search
binary_search:
;
; Description:  public wrapper for rec_binary_search. Sets up initial low/high
;               address bounds and calls the recursive procedure
; Receives:     arg1: address of the array
;               arg2: number of elements in the array
;               arg3: target value to search for
; Returns:      eax = address of element if found, -1 if not found
; Requires:     rec_binary_search
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    ebx

    ; get address of last element
    mov     ebx, [ebp + 12]         ; ebx = number of elements
    dec     ebx                     ; ebx = n - 1
    sal     ebx, 2                  ; ebx = (n-1) * 4

    mov     eax, [ebp + 8]          ; eax = base address of array
    add     ebx, eax                ; ebx = address of last element

    push    DWORD [ebp + 16]        ; arg3 = target
    push    ebx                     ; arg2 = address of last element
    push    eax                     ; arg1 = address of first element
    call    rec_binary_search
    add     esp, 12

    pop     ebx
    leave
    ret
; end binary_search -----------------------------------------------------

;-------------------------------------------------------------------------------
rec_binary_search:
;
; Description:  recursively searches a sorted dword array for a target value
; Receives:     arg1: address of first element
;               arg2: address of last element
;               arg3: target value
; Returns:      eax = address of element if found, -1 if not found
; Requires:     na
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi
    push    edi
    push    ebx

    mov     esi, [ebp + 8]          ; esi = low  address
    mov     edi, [ebp + 12]         ; edi = high address
    mov     edx, [ebp + 16]         ; edx = target

    ; base case: if low > high, not found
    cmp     esi, edi
    jg      .not_found

    ; mid address = low + ((high - low) / 2) rounded to dword boundary
    mov     eax, edi                ; eax = high address
    sub     eax, esi                ; eax = high - low
    shr     eax, 3                  ; eax / 2 and alling offset
    shl     eax, 2
    add     eax, esi                ; eax = address of arr[mid]
    mov     ebx, eax                ; ebx = mid address

    ; compare arr[mid] to target
    mov     eax, [ebx]              ; eax = value at mid
    cmp     eax, edx
    je      .found
    jg      .go_left

.go_right:
    ; recurse with low = mid + 4  (next dword)
    push    edx                     ; arg3 = target
    push    edi                     ; arg2 = high (unchanged)
    lea     eax, [ebx + 4]          ; eax = mid + 4
    push    eax                     ; arg1 = new low address
    call    rec_binary_search
    add     esp, 12
    jmp     .return

.go_left:
    ; recurse with high = mid - 4  (previous dword)
    push    edx                     ; arg3 = target
    lea     eax, [ebx - 4]          ; eax = mid - 4
    push    eax                     ; arg2 = new high address
    push    esi                     ; arg1 = low (unchanged)
    call    rec_binary_search
    add     esp, 12
    jmp     .return

.found:
    mov     eax, ebx                ; return mid address
    jmp     .return

.not_found:
    mov     eax, -1

.return:
    pop     ebx
    pop     edi
    pop     esi
    leave
    ret
; end rec_binary_search ---------------------------------------------------

;-------------------------------------------------------------------------------
global bubble_sort
bubble_sort:
;
; Description:  given the address of an array of dword sized elements and the
;               size of the array, perform bubble sort least to greatest
; Receives:     arg1: address of the array
;               arg2: number of elements in the array
; Returns:      na
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
    push    esi
    push    edi
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
global time_w_ptr
time_w_ptr:
;
; Description:  Return the time as a unsigned integer (number of seconds
;               elapsed since the Unix epoch, January 1, 1970, at 00:00:00 UTC)
; Receives:     arg1: address of the dword to store the time
; Returns:      eax: the time
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    mov     eax, TIME_OP
    mov     ebx, [ebp + 8]
    SYSCALL

    pop     ebx
    leave
    ret
; end time_w_ptr -----------------------------------------------------

;-------------------------------------------------------------------------------
global time
time:
;
; Description:  Return the time as a unsigned integer (number of seconds
;               elapsed since the Unix epoch, January 1, 1970, at 00:00:00 UTC)
; Receives:     
; Returns:      eax: the time
; Requires:     time_w_ptr
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    ebx

    push    DWORD 0
    call    time_w_ptr

    pop     ebx
    leave
    ret
; end time -----------------------------------------------------

;-------------------------------------------------------------------------------
global srand
srand:
;
; Description:  generate a random value [0, RAND_MAX]
; Receives:     arg1: a unsigned int qword seed
; Returns:      EAX = a random value 
; Requires:     next, mul64, add64, rand
; Algo:         linear cungruential generator
;-------------------------------------------------------------------------------
    push    ebp 
    mov     ebp, esp

    mov     eax, [ebp + 8]
    mov     [next], eax
    mov     eax, [ebp + 12]
    mov     [next + 4], eax

    ; call rand
    call    rand 

    leave   
    ret
; end srand

;-------------------------------------------------------------------------------
global swap
swap:
;
; Description:  given 2 data addresses, swap their values
; Receives:     arg1: address of value 1
;               arg2: address of value 2
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi
    push    edi

    mov     esi, [ebp + 8]      ; esi = address of arg1
    mov     edi, [ebp + 12]     ; edi = address of arg2

    mov     eax, [esi]          ; eax = value of arg1
    mov     edx, [edi]          ; edx = value of arg2
    mov     [esi], edx
    mov     [edi], eax

    pop     edi
    pop     esi
    leave
    ret
; end swap -----------------------------------------------------

;-------------------------------------------------------------------------------
global RAND_MAX
global rand
rand:
;
; Description:  generate a random value [0, RAND_MAX]
; Receives:     
; Returns:      EAX = a random value 
; Requires:     next, mul64, add64
; Algo:         linear cungruential generator
;-------------------------------------------------------------------------------
%define c1 1103515245
%define c2 12345
%define c3 16
    .RAND_MAX:  equ     0x7fff      ; 32768

    push    ebp
    mov     ebp, esp

    push    DWORD [next + 4]
    push    DWORD [next]
    push    DWORD c1
    call    mul64

    mov     DWORD [esp], c2        ; overwrite .c1 with .c2
    call    add64

    add     esp, 4
    pop     DWORD [next]
    pop     DWORD [next + 4]

    mov     eax, [next]             ; eax = low order
    shr     eax, c3    
    and     eax, .RAND_MAX

    leave
    ret
; end rand

;-------------------------------------------------------------------------------
global add64
add64:
;
; Description:  adds a unsigned 32b value to a unsigned 64b value
;               both values are pushed into the arguments, none as addresses
; Receives:     arg1: 32b value
;               arg2: the qword
; Returns:      sum stored in the address of arg1
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp

    mov     eax, [ebp + 12]              ; eax = low order (dword) of the qword
    add     eax, [ebp + 8]         ; eax = eax + arg2
    jnc     .end_carry_flag         ; jump if no overflow from adc
    inc     DWORD [ebp + 16]
    mov     [ebp + 12], eax
    .end_carry_flag:

    leave
    ret
; end add64


;-------------------------------------------------------------------------------
global mul64
mul64:
;
; Description:  multiplies a double precision 64b value by a single precision value
; Receives:     arg1: multiplier
;               arg2: the qword
; Returns:      product stored in the address of arg1
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp

    mov     eax, [ebp + 12]         ; ecx = low order of qword
    mul     DWORD [ebp + 8]
    mov     [ebp + 12], eax         ; low order qword = low order product
    add     [ebp + 16], edx    

    leave 
    ret 
; end mul64

;-------------------------------------------------------------------------------
global print_uint_array
print_uint_array:
;
; Description:  given the address of an array of dword unsigned integers and
;               the size of the array
; Receives:     arg1: address of the array
;               arg2: number of elements in the array
; Returns:      na
; Requires:     print_uint
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    esi
    push    ebx

    mov     esi, [ebp + 8]      ; esi = base address of array
    mov     ecx, [ebp + 12]     ; ecx = number of elements

    ; edge case: if array is empty, do nothing
    cmp     ecx, 0
    jle     .done

    .loop:
    cmp     ecx, 0
    jle     .done

    ; print current element
    push    ecx                     ; save ecx — print_uint may clobber it
    push    esi                     ; save esi
    push    DWORD [esi]             ; arg1 = current element value
    call    print_uint
    add     esp, 4                  ; clean up arg
    pop     esi                     ; restore esi
    pop     ecx                     ; restore ecx

    ; print ", " separator only if not the last element
    cmp     ecx, 1
    je      .no_sep

    push    ecx
    push    esi
    push    DWORD separator         ; arg1 = address of ", " string
    call    print
    add     esp, 4
    pop     esi
    pop     ecx

    .no_sep:
    add     esi, 4                  ; advance to next element
    dec     ecx
    jmp     .loop

    .done:
    pop     ebx
    pop     esi
    leave
    ret
; end print_uint_array --------------------------------------------------

;-------------------------------------------------------------------------------
global print_uint
print_uint:
;
; Description:  given an unsigned integer, print it in the console
; Receives:     arg1: the integer
; Returns:      
; Requires:     itoa, print
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    sub     esp, 11             ; local var buffer for itoa
    push    ebx

    lea     ebx, [ebp - 11]
    push    DWORD [ebp + 8]
    push    DWORD ebx
    call    itoa
    call    print
    add     esp, 8

    pop     ebx
    leave
    ret
; end print_uint

;-------------------------------------------------------------------------------
global selection_sort
selection_sort:
;
; Description:  sort an array of unsigned dwords 
; Receives:     arg1: address of the array
;               arg2: qty of elements
; Returns:      
; Requires:     index_of_min_elem, swap
; Algo:         selection sort
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    ; preserve
    push    esi
    push    edi             

    ; innit addresses
    mov     ecx, [ebp + 12]             ; ecx = num of elem
    ; check if only 1 element (edge case)
    ; cmp     ecx, 1
    ; jbe     .return

    mov     esi, [ebp + 8]              ; esi = address of first elem, also the array pointer
    lea     edi, [esi + ((ecx - 1) * 4)]; edi = address of last elem

    push    edi                         ; for call min address
    .while:  
    cmp     esi, edi                    
    jae     .wend                       ; if address of esi >= edi, then break
    
    push    esi
    call    min_address
    add     esp , 4

    .if:
    test    eax, esi
    je      .endif

    .endif:

    add     esi, 4
    jmp     .while
    .wend:

    add     esp, 4                      ; dealocate push edi
    ; restore
    .return:
    pop     edi
    pop     esi
    leave
    ret
; end selection sort

;-------------------------------------------------------------------------------
min_address:
;
; Description:  given the start and end address of an array, return the address
;               of the smallest value
; Receives:     arg1: address beginning of the array
;               arg2: address end of the array
; Returns:      EAX: address of the min value
; Requires:      
; Notes:        - arg1 must be an array of 10 bytes long
; Algo:         Horner's method
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    ; preserve
    push    esi
    push    edi

    ; init addres
    mov     esi, [ebp + 8]              ; esi = address start
    mov     edi, [ebp + 12]             ; edi = address end
    mov     eax, esi                    ; eax = to-be min value

    .while:
    add     esi, 4
    cmp     esi, edi
    ja      .wend                       ; break after looping over the whole array

    mov     edx, [eax]                  ; 
    .if:
    cmp     edx, [esi]                  ; one operand must be a reg
    jbe     .endif

    ; call swap
    ;push    eax
    ;push    esi
    ;call      swap
    ;add    esp, 4
    ;pop    eax

    .endif:

    jmp     .while
    .wend:

    ; restore
    pop     edi
    pop     esi
    leave
    ret
; end index_of_min_elem

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
; Notes:        - arg1 must be an array of 11 bytes long
; Algo:         Horner's method
;-------------------------------------------------------------------------------
    push    ebp
    mov     ebp, esp
    push    DWORD 10                ; local var storing BASE10
    push    DWORD 48                ; local var storing DIGIT_OFFSET
    push    edi                     ; preserve EDI

    mov     edi, [ebp + 8]          ; EDI = array pointer
    mov     eax, [ebp + 12]         ; EAX = int value

    ; edge case for 
    test    eax, eax                ; if EAX != 0
    jnz     .endif                  ; jump out, else continue
    inc     eax                     ; string has 1 char, 0 itself
    mov     BYTE [edi], '0'         ; store '0' in string
    inc     edi                     ; set up for null termi.
    jmp     .exit_procedure
    .endif:

    xor     ecx, ecx                ; ECX = char counter

    .while:
    cmp     eax, 0
    jz      .wend

    mov     edx, 0                  ; prep EDX for div
    div     DWORD [ebp - 4]         ; EAX / 10
    add     edx, DWORD [ebp - 8]          
    ;add     edx, DIGIT_OFFSET       ; convert to char
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

    .exit_procedure:
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

section .data
next:           dq  1
separator:      db  ", ", 0     ; separator string
; CONSTANTS
endl_char:      db  0x0a
NUL:            equ 0
NULL:           equ NUL         ; incase of typos
BASE10:         equ 10
DIGIT_OFFSET:   equ 48

