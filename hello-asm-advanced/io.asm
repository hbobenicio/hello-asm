bits 64

%include "linux.asm"
%include "callconv.asm"

section .text

; @callingconv TODO
; @param rdi buffer address to be printed
; @param rsi buffer size
; @return rax number of bytes written by write syscall
global io_print_buffer
io_print_buffer:
    prologue_c

    ; r11 should be good because it's not callee saved (which means it can be modified)
    mov r11, rdi

    ; write syscall (rax: 0, rdi: fd, rsi: buf, rdx: buflen)
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT
    mov rdx, rsi
    mov rsi, r11
    syscall

    epilogue_c
    ret

