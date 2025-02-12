%ifndef CALLCONV_INC
%define CALLCONV_INC

; # x64 Calling Convention
;
; https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention?view=msvc-170
;
; ## Parameter Passing
; 
; In 64-bit Linux system, function arguments of type integer/pointers are passed to the callee function in the following way:
; - Arguments 1-6 are passed via registers RDI, RSI, RDX, RCX, R8, R9 respectively;
; - Arguments 7 and above are pushed on to the stack.
;
; https://www.ired.team/miscellaneous-reversing-forensics/windows-kernel-internals/linux-x64-calling-convention-stack-frame
; https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention?view=msvc-170#parameter-passing
;
; ## Caller/Callee Saved Registers
;
; The x64 ABI considers the registers RAX, RCX, RDX, R8, R9, R10, R11, and XMM0-XMM5 volatile.
; Consider volatile registers destroyed on function calls
;
; The x64 ABI considers registers RBX, RBP, RDI, RSI, RSP, R12, R13, R14, R15, and XMM6-XMM15 nonvolatile.
; They must be saved and restored by a function that uses them.

%macro prologue_c 0
    push rbp
    mov  rbp, rsp
    ; Red Zone?
    ; sub  rsp, 16
%endmacro

%macro epilogue_c 0
    ;pop  rbp
    leave
%endmacro

%endif

