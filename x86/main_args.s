# -----------------------------------------------------------------------------
# A 64-bit program that displays its commandline arguments, one per line.
#
# On entry, %rdi will contain argc and %rsi will contain argv.
#
# int main (int argc, char *argv[])
# -----------------------------------------------------------------------------
# recall:
#		   func args: rdi, rsi, rdx, rcx, r8d, r9d + stack vars
#                        ret:  rax  or rdx:rax (if you need 128 bits eg mult)
#
# stack pointer %rsp *must* be aligned to a 16 byte boundary before making a call
# must preserve these regs by saving to stack: rbp, rbx, r12, r13, r14, r15
# -----------------------------------------------------------------------------
# as far as C library is concerned, all command line args are strings
#

        .global main

        .text
main:
        push    %rdi                    # save registers that puts uses
        push    %rsi
        sub     $8, %rsp                # must align stack before call

        mov     (%rsi), %rdi            # the argument string to display
        call    puts                    # print it

        add     $8, %rsp                # restore %rsp to pre-aligned value
        pop     %rsi                    # restore registers puts used
        pop     %rdi

        add     $8, %rsi                # point to next argument - 8 bytes 
        dec     %rdi                    # count down
        jnz     main                    # if not done counting keep going

        ret

.data

#format:
#        .asciz  "%s\n"
