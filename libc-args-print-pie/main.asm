bits 64

; uses rip-relative addressing by default for PIE compatibility.
; this is optional, but when calling libc functions, you must use [rel ADDR].
; or disable PIE with the linking -no-pie instead.
default rel

extern puts
extern printf

section .data
    hello: db "Hello, World!", 0
    hello_len: equ $ - hello

    program_label: db "Program: ", 0
    program_label_len: equ $ - program_label

section .bss
    argc: resd 1
    argv: resq 1
    i: resq 1

section .text
global main
main:
    ; prologue
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ; storing cli args
    mov [argc], edi
    mov [argv], rsi

    ; puts(hello)
    lea rdi, [hello]
    call puts wrt ..plt

    ; printf(program_label)
    lea rdi, [program_label]
    xor rsi, rsi
    call printf wrt ..plt

    mov QWORD [i], 0

.start_args_printing:
    mov rdi, [argv]
    add rdi, [i]
    mov rdi, [rdi]
    cmp rdi, 0
    je .end_args_printing
    call puts wrt ..plt

    ; i += 8
    mov rdi, [i]
    add rdi, 8
    mov [i], rdi

    jmp .start_args_printing
.end_args_printing:

    mov eax, DWORD [argc]
    
    ; epilogue
    leave

    ret
