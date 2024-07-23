.text


.extern malloc
.extern realloc


# name: uint_add
# args: %rdi: first uint's pointer, %rsi: first uint's length, %rdx: second uint's pointer, %rcx: second uint's length
# return: %rax: result uint's pointer, %rdx: result uint's length
# description: add two uints and return the result uint.
# call convention: fastcall
.globl uint_add
uint_add:
    cmpq %rcx, %rsi
    jge uint_add_fge
    xchgq %rsi, %rcx
    xchgq %rdi, %rdx

# name: uint_add_fge
# description: add two uints and return the result uint, but the first uint's length is greater than or equal to the second uint's length.
# other: same as uint_add.
.globl uint_add_fge
uint_add_fge:
    # save and initialize used registers.
    pushq %rbp
    xorq %rbp, %rbp # current digit (save the value of current digit of result uint)
    pushq %r12
    movq %rcx, %r12 # save the length of second uint
    pushq %r13
    movq %rdx, %r13 # save the pointer of second uint
    pushq %r14
    movq %rsi, %r14 # save the length of first uint
    pushq %r15
    movq %rdi, %r15 # save the pointer of first uint
    movq %rbp, %rdi
    call malloc # allocate memory of zero length for initializing result uint
    pushw %bx
    xorw %bx, %bx # current digit register and carray register (save the value of current digit of result uint and carray of result uint)

    # start adding for each uint's digit.
    uint_add_loop:
        # check if the current digit is greater than first uint's length.
        cmpq %r14, %rbp
        # if greater or equal, jump to the end of loop.
        jge uint_add_end
            # add the value of current digit of first uint to current digit register of previous carray.
            addb (%r15, %rbp), %bl
        # if have not carray flag, jump this intruction.
        jnc uint_add_f_not_carray
            # if have carray flag, increment carray register for next addition.
            incb %bh
        uint_add_f_not_carray:

        # check if the current digit is greater than second uint's length.
        cmpq %r12, %rbp
        # if greater or equal, skip this addition.
        jge uint_add_s_not_add
            # add the value of current digit of second uint to current digit register of previous addition.
            addb (%r13, %rbp), %bl
        # if have not carray flag (zero flag), skip this instruction.
        jnc uint_add_s_not_carray
            # if have carray flag (zero flag), increment carray register for next addition.
            incb %bh
        uint_add_s_not_carray:
        # if both two uints had addition, increment current digit register.
        incb %bl
        # if have not carray flag (zero flag), skip this instruction.
        jnz uint_add_i_not_carray
            # if have carray flag (zero flag), increment carray register for next addition.
            incb %bh
        uint_add_i_not_carray:
        uint_add_s_not_add:
        
        # reallocate memory for result uint and save the value of current digit register to result uint.
        incq %rbp
        movq %rax, %rdi
        movq %rbp, %rsi
        call realloc
        movb %bl, -1(%rax, %rbp)

        # clear the carry register and set value of carray register to current digit register.
        shrw $8, %bx
    # continue loop until all digits are added.
    jmp uint_add_loop

    # end program
    uint_add_end:
    # if current digit register is zero, skip the instructions follow this block.
    testb %bl, %bl
    jz uint_add_ret

    # if current digit register is more than zero, reallocate result uint and save the value of current digit register to result uint.
    decb %bl
    incq %rbp
    movq %rbp, %rsi
    movq %rax, %rdi
    call realloc
    movb %bl, -1(%rax, %rbp)

    # reload the saved registers.
    uint_add_ret:
    movq %rbp, %rdx # return the length of result uint
    popw %bx
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp

    # return.
    retq
