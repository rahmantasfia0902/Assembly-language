; weird5_win.asm
; Build (from "x64 Native Tools Command Prompt for VS"):
;   nasm -f win64 weird5_win.asm -o weird5_win.obj
;   link /subsystem:console /entry:main /nodefaultlib weird5_win.obj kernel32.lib
; Run:
;   weird5_win.exe & echo ExitCode=%ERRORLEVEL%

default rel
BITS 64

extern  ExitProcess                 ; kernel32.dll

section .data
    ; 4 weird-sized integers, 5 bytes each = 20 bytes total
    weird_array: times 4*5 db 0

section .text
global  main

main:
    ; --- compute address of slot 3 (index 2): base + 2*5 = +10
    lea     rdi, [rel weird_array]
    add     rdi, 10

    ; --- store 5-byte value 0x01_02_03_04_05 in little-endian
    ; memory (low addr) <- 05 04 03 02 01 -> (high addr)
    mov     byte [rdi+0], 0x05
    mov     byte [rdi+1], 0x04
    mov     byte [rdi+2], 0x03
    mov     byte [rdi+3], 0x02
    mov     byte [rdi+4], 0x01

    ; --- rebuild into RAX using MSB->LSB fold with SHL/OR
    xor     rax, rax
    lea     rsi, [rdi+4]            ; point at MSB (0x01)
    mov     ecx, 5                  ; 5 bytes

.rebuild:
    shl     rax, 8
    movzx   rbx, byte [rsi]
    or      rax, rbx
    dec     rsi
    loop    .rebuild

    ; expected = 0x0000_0102_0304_05
    mov     rdx, 0x00000102030405
    cmp     rax, rdx
    jne     .fail

.success:
    xor     ecx, ecx                ; ExitProcess(0) — RCX holds arg #1
    call    ExitProcess

.fail:
    mov     ecx, 1                  ; ExitProcess(1)
    call    ExitProcess
