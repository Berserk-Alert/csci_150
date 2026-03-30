

Global      _start
section .data
valB db -1
valW dw +32767
section .text
_start
mov al, [valB] ; AL = -1
neg al ; AL = +1
neg word [valW] ; valW = -32767