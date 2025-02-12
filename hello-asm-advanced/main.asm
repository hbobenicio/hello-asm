bits 64

%include "linux.asm"
%include "callconv.asm"

extern io_print_buffer

; initialized global and static objects
section .data
    prompt_msg: db "Enter the desired loop count: "
    prompt_msg_len: equ $ - prompt_msg

    hello_world: db "Hello, World!", LF
    hello_world_len: equ $ - hello_world
    ; TODO explore the use of $strlen in NASM

; uninitialized global and static objects and
section .bss

    %define IOBUF_SIZE 32
    iobuf: resb IOBUF_SIZE

; the code section
section .text
    global _start

; the programs entrypoint
_start:
    mov rdi, iobuf       ; arg 1: buffer address
    mov rsi, 0           ; arg 2: value
    mov rdx, IOBUF_SIZE  ; arg 3: buffer size in bytes
    call my_memset

; writes the message prompt to stdout
_prompt_write:
    mov rdi, prompt_msg
    mov rsi, prompt_msg_len
    call io_print_buffer

; reads a int64 from stdin to the local count variable
_prompt_read:
    ; stack-allocate 8 bytes (int64) for the loop count local var
    sub rsp, 8
    mov QWORD [rsp+8], 0

    ; read(stdin, &loop_count, 1 /* or 8? */)
    mov rax, SYSCALL_READ  ; syscall number
    mov rdi, STDIN         ; arg 1: stdin
    lea rsi, QWORD [rsp+8] ; arg 2: buffer address
    mov rdx, 1             ; arg 3: buffer size
    ; mov rsi, iobuf
    ; mov rdx, IOBUF_SIZE
    syscall

_debug:
    ; converts the ascii count into integer
    mov r15, QWORD [rsp+8]
    sub r15, '0'
    mov QWORD [rsp+8], r15

loop_start:
    cmp r15, 0
    jz loop_end

    ; io_print_buffer(hello_world, hello_world_len)
    ; NOTE save rax because we use it as our loop counter (and it's caller-save)
    mov rdi, hello_world
    mov rsi, hello_world_len
    call io_print_buffer

    dec r15
    jmp loop_start
loop_end:

_exit_success:
    mov rax, SYSCALL_EXIT
    mov rdi, EXIT_SUCCESS
    syscall

; rdi: arg 1: buffer address
; rsi: arg 2: value
; rdx: arg 3: buffer size in bytes
my_memset:
    prologue_c

.while_begin:
    cmp rdx, 0
    jle .while_end
    mov [rdi], sil ; sil is the 8 bit lower bytes of rsi
    inc rdi
    dec rdx
.while_end:

    epilogue_c
    ret
