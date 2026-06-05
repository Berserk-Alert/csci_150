;-------------------------------------------------------------------------------
extern open_file:
;
; Description:  Opens file for read only
; Receives:     arg1: file path address (nul terminated string)
; Returns:      eax:  file descriptor
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern create_file:
;
; Description:  create a file
; Receives:     arg1: file path address (nul terminated string)
; Returns:      eax:  file descriptor
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern read_file:
;
; Description:  read into buffer (output) from file (input)
; Receives:     arg1: file descriptor
; Returns:      eax:  number of bytes read
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern write_file:
;
; Description:  write into a file (output) from buffer (input)
; Receives:     arg1: file descriptor
;               arg2: size of the buffer
; Returns:      eax:  number of bytes read
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
extern close_file:
;
; Description:  close a file
; Receives:     arg1: file descriptor
; Returns:      na
;-------------------------------------------------------------------------------