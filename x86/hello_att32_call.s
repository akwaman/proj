# use GNU assembler  - at&t syntax using system call to C library
#
# gcc hello.s -o hello

  .global main

  .text

main:				# called by C library's startup code
	mov	$msg, %rdi	# first pointer
	call	puts  		# puts(msg)
	ret			# return to C library code

msg:
	.asciz "Hello, world"	# asciz puts a 0 byte at the end

