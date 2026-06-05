;-------------------------------------------------------------------------------
extern stk_push:
;
; Description:  add a value to the top of the stack
; Receives:     arg1: head address
;               arg2: value to add
; Returns:      EAX = address of the new node (in the heap)
; Requires:     malloc
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern stk_pop:
;
; Description:  removes top value off the stack
; Receives:     arg1: head address
; Returns:      EAX = new head
; Requires:     free
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern stk_peek:
;
; Description:  Retrieves the value at the top of the stack without removing it
; Receives:     arg1: head address
; Returns:      EAX = value of at the top of the stack   
;------------------------------------------------------------------------------