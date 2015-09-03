; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
; To assemble and run:
;
;     nasm -f elf64 hello.s && ld hello.o -o hello  && ./hello
; ----------------------------------------------------------------------------------------
; note - the difference in registers specified vs hello.s
;        this is specifically for 64 bit architecture x86_64 vs x86_32
;        Uses syscall versus int 0x80 and arg regs are also different


section .data
msg:        db   "Hello, World",0,10      ; 0 terminated string plus line feed (LF)
msg_len:    equ  $-msg	; num bytes from current mem position ($) to first char of msg


section .text
        global  _start

_start:
        ; write(1, message, 13)
        mov     rax, 1                  ; system call 1 is write
        mov     rdi, 1                  ; file handle 1 is stdout
        mov     rsi, msg            ; address of string to output
        mov     rdx, msg_len                 ; number of bytes
        syscall                         ; invoke operating system to do the write


        ; exit(0)
        mov     eax, 60                 ; system call 60 is exit
        xor     rdi, rdi                ; exit code 0
        syscall                         ; invoke operating system to exit


