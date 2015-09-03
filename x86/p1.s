;; nasm -f elf64 -l p1.lst
;;  gcc -o p1 p1.o
	
.section data
	var db 64		; global variable of size byte with value 64 (address is var)
	var2 db ?		; unitialized byte at address var2
	     db 10		; byte at address var2+1
	x dw ?			; unitialized 16-bit word at address x
	y dd 33000		; 32-bit word with value 33000 at address y

	;; strings must terminate with a byte holding 0
	str db 'hello',0	; 6 bytes (with 0 termination byte) at address str

	arr dd 100 dup(0)	; 100 32-bit word array initialized with 0, first address is arr
	bytes db 10 ?		; 10 unitialized bytes starting at address bytes
	
	