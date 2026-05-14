;-------------------------------------------------------------------------------
extern mul64:
;
; Description:  multiplies a double precision 64b value by a single precision value
; Receives:     arg1: address of 64b double precision
;               arg2: multiplier
; Returns:      product in address of arg1
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern print_uint:
;
; Description:  given an unsigned integer, print it in the console, then an end
;               character 
; Receives:     eax: the unsigned integer
; Returns:      
; Requires:     
; Algo:         
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern selection_sort:
;
; Description:  sort an array of unsigned dwords 
; Receives:     arg1: address of the array
;               arg2: qty of elements
; Returns:      
; Requires:     index_of_min_elem 
; Algo:         selection sort
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern itoa:
;
; Description:  given a 32b unsigned int, return a null termintated string 
;               representation
; Receives:     arg1: address FOR the null terminated string 32b
;               eax: 32b unsigned int value
; Returns:      EAX: quantity of characters in the string
; Requires:     
; Notes:        - arg1 must be an array of 10 bytes long
; Algo:         Horner's method
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern atoi:
;
; Description:  given a null terminated string of a 32b unsigned int, return it as a number
;               convert the string representation of a number into its number
; Receives:     arg1: address of the null terminated string 32b
; Returns:      EAX: unsigned int value
; Requires:     NULL, BASE10 
; Notes:        ret 0 for an invalid string
; Algo:         Horner's method
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
extern sum_array:
;
; Description:  sums the values in an array of 32b elements
; Receives:     arg1: address of the array
;               arg2: the size of the array
; Returns:      EAX = sum
; Requires:     Nothing
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern class_sum_array:
;
; Description:  sums the values in an array of 32b elements
; Receives:     arg1: address of the array
;               arg2: num of elements
; Returns:      EAX = sum
; Requires:     rec_array_sum
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern to_sentence_case:
;
; takes in a null-terminated string arg1, converts the first letter to upper case
;   and the folowing letters to lower case
; Receives:     arg1: address of the string 
; Returns:      na
; Requires:     to_lower
; Note:         can't distinguish sentences; it will only capitalize the first 
;               letter of the given string
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern to_upper_inclass:
;
; takes in a null-terminated string arg1, converts all lower case alphabet characters 
;   to upper case. Made in class using alter_char_by_range
; Receives:     arg1: address of the string 
; Returns:      na
; Requires:     alter_char_by_range
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern to_upper:
;
; takes in a null-terminated string arg1, converts all lower case alphabet characters 
;   to upper case.
; Receives:     arg1: address of the string 
; Returns:      na
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern to_lower:
;
; takes in a null-terminated string arg1 and returns nothing. 
; It converts all upper case alphabet characters to lower case. 
; Receives:     arg1: address of the buffer to store user input
; Returns:      na
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern getUserInput:
;
; read input from the user 
; Receives:     arg1: address of the buffer to store user input
;               arg2: size of the buffer
; Returns:      EAX = char qty
;               a null terminated string in the provided buffer
; Requires:     na
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern println:
;
; prints a null-terminated string to stdout and then a endl char
; Receives: arg1: address of the null-terminated string
; Returns:  EAX: number of characters
; Requires: strlen, print, and endl
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern endl:
;
; just prints a next line character
; Receives: na
; Returns:  na
; Requires: na
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern print:
;
; prints a null-terminated string to stdout
; Receives: arg1: address of the null-terminated string
; Returns:  EAX: number of characters
; Requires: strlen
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern strlen:
;
; Returns the number of characters in a null terminated string
; Receives: arg1: address of the null terminated string
; Returns:  EAX: number of characters
; Requires: na
; Notes:    na
;-------------------------------------------------------------------------------

;------------------------------------------------------------------------------
extern exit:
;
; regular exit program
; Receives: arg1: exit code
; Returns:  na
; Requires: na
; Notes:    na
;-------------------------------------------------------------------------------
