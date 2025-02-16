bits 64

%include "callconv.nasm"

section .text

; Searches a buffer for a value.
; @param rdi buffer to look at
; @param rsi value we are searching for
; @return rax address to the element. 0 if not found
global mem_find
mem_find:
    prologue_c
    ; TODO
    epilogue_c
    ret

; @callingconv TODO
; @param rdi buffer address to be printed
; @param rsi value to be set
; @return rax number of bytes written by write syscall
global mem_set
mem_set:
    prologue_c
    ; TODO
    epilogue_c
    ret