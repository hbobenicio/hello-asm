bits 64

section .data
    test1: db '42', 0, 0
    test1_len: equ $ - test1

section .text

    extern parse_int
    global _start
_start:
    lea rdi, [test1]
    mov rsi, 3
    call parse_int
_debug:
    mov rdi, rax
    mov rax, 60
    syscall

