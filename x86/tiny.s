; nasm -f elf64 tiny.s
; gcc -Wall -s -nostdlib tiny.o
; echo $?


bits 32
global _start
section  .text

_start:
        mov eax, 1
        mov ebx, 42
        int 0x80            ; call exit in 32 bit mode


; call _exit





; wc -c tiny  ---> 4880 bytes  vs 6192 in tiny.c with stripping