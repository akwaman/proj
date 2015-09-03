# hello_att.a  x86_64 for Linux, Intel, gcc
#
# as -gstabs -o hello_att.o hello_att.s
# ld -o hello_att hello_att.o
# 


.data

msg:	
	.ascii "hello ATT!\n"
	msglen = . - msg

msg2:	
	.ascii "some more text\n"
	msg2len = . - msg2


.text

.global _start

_start:
	mov $1,	%eax		# write syscall
	mov $1, %edi		# write to stdout (fd 1)
	mov $msg, %rsi		# address of string to write
	mov $msglen, %edx	# length of string to write
	syscall
				# eax get return value so we need to 
	mov $1,	%eax		# reset it to syscall 
	mov $msg2, %rsi		# print msg2
	mov $msg2len, %edx	# 
	syscall

	mov $60, %eax		# exit syscall
	mov $0, %edi		# return code 0
	syscall



