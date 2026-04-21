;-------------------------------------------------------------------------------
extern sum_array:
;
; Description:  sums the values in an array of 32b elements
; Receives:     arg1: address of the array
;               arg2: the size of the array
; Returns:      EAX = sum
; Requires:     Nothing
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
