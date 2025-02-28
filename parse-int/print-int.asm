bits 64

; Prints an integer to stdout
; @param rdi the number to be printed
print_int:
    push rbp
    mov rbp, rsp

    ; Stack Allocation
    sub rsp, 16 ; 16-bytes array for io buffering

    ; Algorithm:
    ; divide x by 10
    ; push R to the io buffer
    ; if quocient > 0, x = quocient

    leave
    ret

