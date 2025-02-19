bits 64

section .text

extern puts

global main
main:
    push rbp,
    mov rbp, rsp
    push rbx
    push rsi

    ; loops for each command line argument from our
.args_loop_init:
    mov rbx, qword [rbp-16]
.args_loop_condition:
    mov rdi, [rbx]
    cmp rdi, 0
    je .args_loop_end
.args_loop_body:
    call puts wrt ..plt
.args_loop_step:
    add rbx, 8
    jmp .args_loop_condition
.args_loop_end:

    pop rbx
    xor rax, rax
    leave
    ret
