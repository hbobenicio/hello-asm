bits 64

default rel

struc Person
    .age:       resd 1
    .height:    resd 1
    .name:      resb 64
endstruc

section .data

personDefault: istruc Person
    at .age,      dd 37
    at .height,   dd 171
    at .name,     db "Fulano",0
iend

section .text

global main
main:
    push rbp
    mov rbp, rsp

    ; Stack Layout
    sub rsp, Person_size
    %define personPtr (rbp - Person_size)
    ; mov dword [rbp - Person_size + Person.age   ], 37
    ; mov dword [rbp - Person_size + Person.height], 171

    ; src: RSI
    ; dst: RDI
    ; cnt: RCX
    ; memcpy($rbp - Person_size, personDefault, sizeof(Person))
    mov rsi, personDefault
    lea rdi, [personPtr]
    mov rcx, Person_size
    repe movsb

    ;xor rax, rax
    mov eax, dword [personPtr + Person.height]
    leave
    ret
