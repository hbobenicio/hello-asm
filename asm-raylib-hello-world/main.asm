bits 64
default rel

%define WINDOW_WIDTH  800
%define WINDOW_HEIGHT 600

section .data

WindowTitle:     db 'Hello, Raylib!', 0x0
HelloWorldLabel: db 'Hello, World!', 0x0

section .text

extern InitWindow
extern CloseWindow
extern SetTargetFPS
extern WindowShouldClose
extern BeginDrawing
extern EndDrawing
extern ClearBackground
extern DrawText

global main
main:
    push rbp
    mov rbp, rsp

    mov rdi, WINDOW_WIDTH
    mov rsi, WINDOW_HEIGHT
    mov rdx, WindowTitle
    call InitWindow

    mov rdi, 60
    call SetTargetFPS

.main_loop:

    ; rc!=0 => you should close
    ; rc==0 => you should not close
    call WindowShouldClose ;  
    cmp rax, 0
    jne .end

    call BeginDrawing
    call BackgroundDraw
    call HelloWorldLabelDraw
    call EndDrawing

    jmp .main_loop
.end:
    call CloseWindow
    xor rax, rax
    leave
    ret

BackgroundDraw:
    push rbp
    mov rbp, rsp
    mov rdi, 0xF5A5A5FF
    call ClearBackground
    leave
    ret
   
HelloWorldLabelDraw:
    push rbp
    mov rbp, rsp
    mov rdi, HelloWorldLabel
    mov rsi, 190
    mov rdx, 200
    mov rcx, 20
    mov r8, 0xFFFFFFFF
    call DrawText
    leave
    ret

