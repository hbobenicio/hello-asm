bits 64

%define SYSCALL_READ  0
%define SYSCALL_WRITE 1
%define SYSCALL_OPEN  2
%define SYSCALL_CLOSE 3
%define SYSCALL_EXIT  60

%define STDIN_FILENO  0
%define STOUT_FILENO  1
%define STDERR_FILENO 2

%define O_RDONLY  0
%define O_CLOEXEC (1 << 19)

section .data
    random_file_path: db "/dev/urandom", 0

    title: db "Try to guess the magic number (tip: it cannot be negative and it's less than 10)...", 10, 0
    title_len: equ $ - title

    too_big_label: db "Value is too big... try something smaller...", 10, 0
    too_big_label_len: equ $ - too_big_label

    too_small_label: db "Value is too small... try something greater...", 10, 0
    too_small_label_len: equ $ - too_small_label

    congratulations_label: db "Correct! Congratulations, YOU WON!", 10, 0
    congratulations_label_len: equ $ - congratulations_label

section .bss
    random_file_fd: resq 1
    random_number: resb 1

    iobuf32: resb 4

section .text

global _start

_start:
    mov rax, SYSCALL_WRITE
    mov rdi, STOUT_FILENO
    lea rsi, [title]
    mov rdx, title_len
    syscall

    ; int open(const char* random_file_path, int flags)
    mov rax, SYSCALL_OPEN
    lea rdi, [random_file_path]
    mov rsi, O_RDONLY | O_CLOEXEC
    syscall
    cmp rax, 0
    jle .err
    mov [random_file_fd], rax

    ; read 4 random bytes into iobuf32
    mov rax, SYSCALL_READ
    mov rdi, [random_file_fd]
    lea rsi, [iobuf32]
    mov rdx, 4
    syscall
    cmp rax, 0
    jle .err_close

    ; random_number = iobuf32 % 10 (a random number between [0, 10))
    xor rax, rax
    mov rax, [iobuf32]
    mov rcx, 10
    xor rdx, rdx
    div rcx
    mov [random_number], dl

    ; read a number from stdin
.guess_loop:
    mov DWORD [iobuf32], 0
    mov rax, SYSCALL_READ
    mov rdi, STDIN_FILENO
    lea rsi, [iobuf32]
    mov rdx, 3
    syscall
    cmp rax, 0
    jle .err_close
    cmp rax, 3
    jge .err_close

    ; atoi just on the first byte of the buffer
    xor rax, rax
    mov al, [iobuf32]
    sub al, '0'

    ; check the guess
    mov dl, [random_number]
    cmp al, dl
    jl .too_small
    cmp al, dl
    jg .too_big
    cmp al, dl
    jne .guess_loop
    jmp .corret_answer

.too_small:
    mov rax, SYSCALL_WRITE
    mov rdi, STOUT_FILENO
    lea rsi, [too_small_label]
    mov rdx, too_small_label_len
    syscall
    jmp .guess_loop

.too_big:
    mov rax, SYSCALL_WRITE
    mov rdi, STOUT_FILENO
    lea rsi, [too_big_label]
    mov rdx, too_big_label_len
    syscall
    jmp .guess_loop
    
.corret_answer:
    mov rax, SYSCALL_WRITE
    mov rdi, STOUT_FILENO
    lea rsi, [congratulations_label]
    mov rdx, congratulations_label_len
    syscall

    mov rax, SYSCALL_CLOSE
    mov rdi, [random_file_fd]
    syscall

    mov rax, SYSCALL_EXIT
    xor rdi, rdi
    syscall

.err_close:
    mov rax, SYSCALL_CLOSE
    mov rdi, [random_file_fd]
    syscall
.err:
    mov rax, SYSCALL_EXIT
    mov rdi, 1
    syscall
