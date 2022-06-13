BITS 64

%define SYSCALL_EXIT 60
%define SYSCALL_WRITE 1
%define STDOUT 1

section .text
global _start
_start:
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov rax, SYSCALL_EXIT 
    mov rdi, 0
    syscall

section .data
msg: db "Hello, World!", 10
msg_len: equ $-msg

