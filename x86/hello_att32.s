# use GNU assembler  - at&t syntax
#
# gcc -c hello_call.s 
# ld hello_call.o -o hello_call

  .global start

  .text

_start:
	# write(1, msg, 13)

	mov $1, %rax	# system call 1 is write
	mov $1, %rdi	# file handle 1 is stdout
	mov $msg, %rsi	# address of string to output
	mov $13, %rdx	# number of bytes
	syscall

	# exit(0)
	mov $60, %rax	# system call 60 is exit
	xor %rdi, %rdi	# put 0 into register as return code
	syscall

msg:
	.ascii "Hello, world\n"

