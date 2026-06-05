%include "lib.inc"

struc node
    .value:     resd    1
    .next:      resd    1
endstruc

;-------------------------------------------------------------------------------
global stk_push
stk_push:
;
; Description:  add a value to the top of the stack
; Receives:     arg1: head address
;               arg2: value to add
; Returns:      EAX = address of the new node (in the heap)
; Requires:     malloc
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp

    ; allocated space on the heap for a new node
    push    DWORD node_size
    call    malloc                  ; eax = brk or the address of the node

    ; load the node
    mov     edx, [ebp + 12]         
    mov     [eax + node.value], edx ; node.value = value
    mov     edx, [ebp + 8]          
    mov     [eax + node.next], edx  ; node.next = head

    leave
    ret
; end push -----------------------------------------------------

;-------------------------------------------------------------------------------
global stk_pop
stk_pop:
;
; Description:  removes top value off the stack
; Receives:     arg1: head address
; Returns:      EAX = new head
; Requires:     free
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp

    mov     eax, [ebp + 8]              ; eax = ptr of head
    mov     eax, [eax + node.next]      ; eax = &head.next (AKA new head address)
    push    eax

    ; remove the space for top node, data still remains but is open to be overwritten
    push    DWORD node_size
    call    free
    add     esp, 4
    pop     eax                         ; restore eax, free() clobbers it

    leave
    ret
; end pop -----------------------------------------------------

;-------------------------------------------------------------------------------
global stk_peek
stk_peek:
;
; Description:  Retrieves the value at the top of the stack without removing it
; Receives:     arg1: head address
; Returns:      EAX = value of at the top of the stack   
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp

    mov     eax, [ebp + 8]              ; eax = head address
    mov     eax, [eax + node.value]     ; eax = value (head.value)

    leave
    ret
; end peek -----------------------------------------------------

