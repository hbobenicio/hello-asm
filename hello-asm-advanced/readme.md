# Hello ASM (in NASM)

Demonstrates some basic x86_64 Assembly on Linux using NASM

## Conventions and Other Notes

### Registers

#### Caller-Save Registers

Caller-Save registers are not necessarily saved across function calls.

%rax, %rcx, %rdx, %rdi, %rsi, %rsp, and %r8-r11

#### Callee-Save Registers

Callee-Save registers are saved across function calls.

%rbx, %rbp, and %r12-r15

#### Function Return Register

rax

### Sections

- `.bss` section refers to uninitialized global and static objects and
- `.data` section refers to initialized global and static objects

### Function Calls and Stack Frames

C Calling Convention - Arguments

%rdi, %rsi, %rdx, %rcx, %r8, and %r9

subsequent parameters (or parameters larger than 64 bits) should be pushed onto the stack,
with the first argument topmost.

## References

- [Linux Syscalls Table](https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/)
