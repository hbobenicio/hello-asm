; nasm -f elf64 -g -O0 -o main.o main.asm && gcc -Wall -Wextra -nostdlib -static -g -o main main.o
bits 64

; linux constants
%define SYSCALL_READ  0
%define SYSCALL_WRITE 1
%define SYSCALL_EXIT 60
%define STDIN_FD  0
%define STDOUT_FD 1

%define EOL 10

%define PROMPT_INPUT_BUFFER_SIZE 64

section .data
    hello_world db "Hello, "
    hello_world_len equ $ - hello_world

section .bss
    prompt_input_buffer resb PROMPT_INPUT_BUFFER_SIZE

section .text
    global _start

_start:
    ; read from stdin to buffer
    mov rsi, prompt_input_buffer
    mov rdx, PROMPT_INPUT_BUFFER_SIZE
    call read_stdin

    ; syscall write: write "Hello, "
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT_FD
    mov rsi, hello_world
    mov rdx, hello_world_len
    syscall

    ; syscall write: write subject from buffer
    mov rax, SYSCALL_WRITE
    mov rdi, STDOUT_FD
    mov rsi, prompt_input_buffer
    mov rdx, PROMPT_INPUT_BUFFER_SIZE
    syscall
    
    ; syscall exit
    mov rax, SYSCALL_EXIT
    xor rdi, rdi
    syscall

; inputs:
;   - rsi: input buffer addr
;   - rdx: input buffer size
; output:
;   - rax: where do I get the syscall return value??
read_stdin:
    mov rax, SYSCALL_READ
    mov rdi, STDIN_FD
    syscall
    ret

