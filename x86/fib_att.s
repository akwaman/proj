# fib_asm.c calls function fib_att defined here (AT&T syntax)
# extern "C" int fib_att(int n0, int n1, int count);
#
# it works!
#-------------------------------------------------------------------------------
.global fib_att

.text         

# recall:  func args: rdi, rsi, rdx, rcx, r8d, r9d + stack vars
#                ret:  rax  or rdx:rax (if you need 128 bits eg mult)
#
# recall: must preserve these regs by saving to stack: rbp, rbx, r12, r13, r14, r15
#

# arguments:
# rdi - n0
# rsi - n1
# rdx - count

# locals:
# rcx - temp

fib_att:
	push	%rbx		# must save it if we use it

        mov     %rsi, %rax      # acc := n1
        add     %rdi, %rax      # acc := acc + n0
loop:
        mov     %rax, %rcx      # temp := acc
        add     %rdi, %rax      # acc := acc + n0
        mov     %rcx, %rdi      # n0 := temp (previous acc)

/*
        # debugging -- print value on the accumulator
	push	 %rax  	        # caller-save registers
	push	 %rdi  	        # 
	push	 %rcx           # 
	push	 %rdx           # 
	mov	 $format, %rdi	# set arg1
	mov	 %rax, %rsi	# arg2 is the value of the current sequence number
	xor	 %rax, %rax	# because printf is varargs
	# stack is already aligned because we pushed three 8 byte registers ??
	call	printf	   	# printf(format=%rdi, current_number=%rsi)
	pop	%rdx		# restore caller-save register
	pop	%rcx		# 
	pop	%rdi		# 
	pop	%rax		# 
*/

	dec	%rdx  		# count down
	jnz	loop		# if not done counting down, do some more



	pop	%rbx		# restore rbx before returning

	ret                     # %rax aka acc is returned


format:
	.asciz "%20ld\n"
