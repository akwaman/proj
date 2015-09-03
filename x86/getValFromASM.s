;; call function getValFromASM() from C program c_asm.c
;;
;; put integer return value into the return register rax
;;
;;------------------------------------------------------------------------------

section .data
;; no data 

section .text
	global getValFromASM



getValFromASM:
	mov rax, 46763
	ret




