; nasm -f elf64 -g -O0 -o main.o main.asm && gcc -Wall -Wextra -static -g -o main main.o
; -nostdlib ?
bits 64

extern puts

; linux constants
%define SYSCALL_READ  0
%define SYSCALL_WRITE 1
%define SYSCALL_EXIT 60
%define STDIN_FD  0
%define STDOUT_FD 1

%define EOL 10
%define NUL 0

; section .data
section .data
    msg db "Hello, libc!", EOL, NUL

section .text
    global main

main:
    push rbp
    mov rbp, rsp
    lea rdi, [rel msg]
    call puts
    pop rbp

    ret

