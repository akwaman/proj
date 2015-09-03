# 64-bit Fibonacci number generator in AT&T syntax using GNU assembler
# see cs.lmu.edu/~ray/notes/gasexamples/
#
# gcc fib.s


	.global main

	.text
main:
	push	%rbx		# must save it since we use it

# recall: must preserve these regs by saving to stack: rbp, rbx, r12, r13, r14, r15

	mov	$20, %ecx	# counter 20 downto 0
	xor	%rax, %rax	# holds current number
	xor	%rbx, %rbx	# holds next number
	inc	%rbx  		# first rbx is 1  i.e. sequence starts with 0, 1 ..

print:
	# call printf, but we are using eax, ebx, and ecx
	# printf may destroy eax and ecx (function args and returns) so save before
	# making the call and restore them afterwards

# recall:  func args: rdi, rsi, rdx, rcx, r8d, r9d + stack vars
#                ret:  rax  or rdx:rax (if you need 128 bits eg mult)

	push	 %rax  	        # caller-save register
	push	 %rcx           # caller-save register

	mov	 $format, %rdi	# set arg1
	mov	 %rax, %rsi	# arg2 is the value of the current sequence number
	xor	 %rax, %rax	# because printf is varargs

	# stack is already aligned because we pushed three 8 byte registers ??

	call	printf	   	# printf(format=%rdi, current_number=%rsi)

	pop	%rcx		# restore caller-save register
	pop	%rax		# restore caller-save register

	mov 	%rax, %rdx	# save current number
	mov 	%rbx, %rax	# next number is now current number
	add	%rdx, %rbx	# compute next number
	dec	%ecx  		# count down
	jnz	print		# if not done counting down, do some more

	pop	%rbx		# restore rbx before returning
	ret

format:
	.asciz "%20ld\n"
