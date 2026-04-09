
;-------------------------------------------------------------------------------
extern itoa
;
; Description:	Converts an integer to null-terminated string representation
; Receives: 	EAX = integer
;               EBX = buffer address
; Returns:  	EAX = size of the resultant string
; Requires: 	rev_str: reverse the string
; Notes:    	buffer must be at least 12 bytes large
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern atoi
;
; Description:	Convert a null-terminated string representation of a 32bit integer to an integer
; Receives: 	EAX = null-terminated string address
; Returns:  	EAX = integer
; Algo:     	Horner's method
;-------------------------------------------------------------------------------

