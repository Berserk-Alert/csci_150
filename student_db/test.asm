; who:  David Zhou Cao
; what: 
; why:  
; when: 
 
%include "../io.inc"
%include "../lib.inc"

section .text
global _start

_start:
    mov     eax, stud_size
    mul     DWORD [stud_qty]
    push    eax

    ; malloc
    push    eax
    call    malloc  
    add     esp, 4
    mov     [array_ptr], eax

    ; file ops

    ; free 
    pop     eax
    push    eax
    call    free
    add     esp, 4

    push    DWORD 0
    call    exit

section .bss
array_ptr:          resd 1

section .data
filepath:       db  "student.db", 0
stud_qty:       dw  3
colon_str:      db  ": ", 0
sep_str:        db  " ", 0

struc stud           ; student
    .id:        resb 12
    .fname:     resb 100
    .lname:     resb 100
    .mname:     resb 100
endstruc


section .text
;-------------------------------------------------------------------------------
read_students:
;
; Description:  Reads student information (name, id) from a file
; Receives:     
; Returns:      io.inc
;-------------------------------------------------------------------------------
%define descriptor ebp - 4
    push	ebp
    mov 	ebp, esp
    sub     esp, 4              ; descriptor
    push    edi 
    push    ebx

    mov     edi, [array_ptr]

    ; open the file
    push    DWORD filepath
    call    open_file
    add     esp, 4
    mov     [descriptor], eax

    mov     ecx, stud_qty

    ; for each student, 
    ;   read the student into the array
    .loop:
    push    ecx

    push    DWORD stud_size
    push    edi
    push    DWORD [descriptor]
    call    read_file
    add     esp, 12

    pop     ecx

    add     edi, stud_size

    loop    .loop

    ; close the file
    push    DWORD [descriptor]
    call    close_file
    add     esp, 4

    pop     ebx
    pop     edi
    leave
    ret
; end read_students -----------------------------------------------------

;-------------------------------------------------------------------------------
write_studs:
;
; Description:  write student information to the data base
; Receives:     
; Returns:      
; Requires:     
; Notes:        
; Algo:         
;-------------------------------------------------------------------------------
%define descriptor ebp - 4
    push	ebp
    mov 	ebp, esp
    sub     esp, 4              ; var storing file desc
    push    esi

    mov     esi, [array_ptr]

    ; open the file
    push    DWORD filepath
    call    create_file
    add     esp, 4
    mov     [descriptor], eax

    mov     ecx, stud_qty
    ; for each student
    ;   write the student
    .loop:
    push    ecx

    push    DWORD stud_size
    push    edi
    push    DWORD [descriptor]
    call    read_file
    add     esp, 12

    pop     ecx
    add     esi, stud_size
    
    loop    .loop

    ; close
    push    DWORD [descriptor]
    call    close_file
    add     esp, 4

    pop     esi
    leave
    ret
; end write_studs -----------------------------------------------------

;-------------------------------------------------------------------------------
print_stud:
;
; Description:  prints a student
; Receives:     arg1: address of the student
; Returns:      
; Requires:     println
;-------------------------------------------------------------------------------
    push	ebp
    mov 	ebp, esp
    push    esi
    push    ebx

    mov     ebx, [ebp + 8]
    mov     esi, ebx

    push    esi
    call    print
    
    push    colon_str
    call    print

    add     esi, stud.fname
    push    esi
    call    print
    push    sep_str
    call    print

    mov     esi, ebx
    add     esi, stud.mname
    push    esi 
    call    print
    push    sep_str
    call    print

    mov     esi, ebx
    add     esi, stud.lname
    push    esi 
    call    println    

    add     esp, 28

    pop     ebx
    pop     esi
    leave
    ret
; end print_stud -----------------------------------------------------

