%ifndef LINUX_INC
%define LINUX_INC

; Linux System V x86_64 Syscalls Table:
; https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

%define SYSCALL_READ   0
%define SYSCALL_WRITE  1
%define SYSCALL_EXIT  60

%define STDIN  0
%define STDOUT 1
%define STDERR 2

%define EXIT_SUCCESS 0
%define EXIT_FAILURE 1

%define LF 10  ; Ascii Line Feed ('\n')
%define CR 13  ; Ascii Carriage Return ('\r')

%endif

