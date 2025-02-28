bits 64

; @param rdi buffer address
; @param rsi buffer max size
; @return rax 32-bit
global parse_int
parse_int:
    push rbp
    mov rbp, rsp
   
    ; Stack Allocation
    push rdi     ; 64-bits (8 bytes) (addr: rbp-8)       the start of the buffer
    sub  rsp, 8  ; 64-bits (8 bytes) (addr: rbp-8-8)     the end of the digits
    push rsi     ; 64-bits (8 bytes) (addr: rbp-8-8-8)   max size of the buffer
    sub  rsp, 8  ; 64-bits (8 bytes) (addr: rbp-8-8-8-8) digits count

    ; find the last digit and store the end address and the digits count
    call find_last_digit
    mov [rbp-8-8], rax
    mov rdi, [rbp-8]
    sub rax, rdi
    mov [rbp-8-8-8-8], rax

    ; r8: the base factor (multiples of 10). starts with 10^0 == 1
    mov r8, 1
    ; r10: total sum
    xor r10, r10

    ; loads the start of the buffer back to rdi
    mov rdi, [rbp-8]
    ; loads the last digit address as our cursor
    mov rsi, [rbp-8-8]

.compute_digit:
    ; if cursor == buffer, then goto end (we've read it all)
    cmp rdi, rsi
    je .end
    ; point to the last digit
    dec rsi
    ; load the digit
    movzx rax, BYTE [rsi]
    ; ascii-convert it to number
    sub rax, '0'
    ; multiply it by the decimal current factor
    mul r8
    ; acumulate it into the sum
    add r10, rax
    ; multiply factor by 10 for the next decimal digit
    mov rax, r8
    mov r11, 10
    mul r11
    mov r8, rax
    ; go to the next iteration
    jmp .compute_digit
.end:
    mov rax, r10
    leave
    ret
.err:
    mov rax, -1  ;FIXME what if the parsed value is this?
    leave
    ret

; Finds the last digit of a buffer.
; @param rdi buffer
; @param rsi max size
; @return rax address past the last digit
find_last_digit:
    push rbp
    mov rbp, rsp

    ; Stack Allocation
    push rdi   ; 64-bits (8 bytes) (addr: rbp-8)       the start of the buffer. we won't change it
    push rdi   ; 64-bits (8 bytes) (addr: rbp-8-8)     our cursor. starts from the buffer address
    push rsi   ; 64-bits (8 bytes) (addr: rbp-8-8-8)   our counter. starts as the max size
    sub rsp, 8 ; 64-bits (8 bytes) (addr: rbp-8-8-8-8) padding to keep rsp 16-bit aligned

.search:
    ; if byte counter >= max size, then end of digits
    mov rcx, [rbp-8-8-8]
    cmp rcx, 0
    jle .search_end

    ; if current byte is not a digit, then end of digits
    mov rdi, [rbp-8-8]
    movzx rdi, BYTE [rdi]
    call is_digit
    cmp rax, 0
    je .search_end

    ; iterate
    ; inc cursor
    mov rdi, [rbp-8-8]
    inc rdi
    mov [rbp-8-8], rdi
    ; dec counter
    mov rcx, [rbp-8-8-8]
    dec rcx
    mov [rbp-8-8-8], rcx
    jmp .search

.search_end:
    mov rax, [rbp-8-8]
    leave
    ret

; Checks if its a digit. (Care about the size of the register)
; @param rdi the byte to check
; @return rax 1 if it's a digit. 0 othersize
is_digit:
    cmp rdi, '0'
    jl .not_digit

    cmp rdi, '9'
    jg .not_digit

    mov rax, 1
    ret

.not_digit:
    xor rax, rax
    ret

