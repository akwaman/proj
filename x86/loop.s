;;------------------------------------------------------------------------------	 
;; Compiling:
;; nasm -f elf64 loop.s
;; ld loop.o
;; a.out
;;
;; Running and and analysis
;; objdump a.out
;; gdb a.out
;;------------------------------------------------------------------------------	 
	global _start

        section .data
number:	db 0x30,0x30,0x0,0xA  ; '0','0', NULL, LF
msg:	db "hello, loop",0,10 ; with string termination (0) and linefeed (10)
msglen: equ $-msg  	      ; number of bytes in msg string

	section .text

_start:
	mov rbx, 10		; load a loop counter with 10
        mov r9, 0x30		; 0x30 is the ASCII code for 0
	mov byte [number+1], r9b	; lowest byte of r9
        mov r10, 0x30	
	mov byte [number], r10b
	
label:
	call wrint	
	call write		; call subroutine

	call inc_num

	sub rbx, 1
	cmp rbx, 0

 	jle done
	jmp label

	;; increment register R9 and mov into number string
inc_num:
	add r9, 1
	mov byte [number+1], r9b	; lowest byte of r9
	ret

	;; system call to write "msg"
write:	mov rax, 1
	mov rdi, 1		; file handle is stdout
	mov rsi, msg		; address of string to write
	mov rdx, msglen		; number of bytes in string
	syscall
	ret			; return from subroutine

	;; system call to write integer value in rbx
wrint:	mov rax, 1
	mov rdi, 1		; file handle is stdout
	mov rsi, number		; address of string to write
	mov rdx, 4		; number of bytes in string
	syscall
	ret			; return from subroutine
	
	;; system call to exit
done:	mov eax, 60
	xor rdi, rdi
	syscall
	ret


	

