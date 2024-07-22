.text


.extern malloc
.extern realloc


.globl uint_add
uint_add:
    cmpq %rcx, %rsi
    jge uint_add_fg
    xchgq %rsi, %rcx
    xchgq %rdi, %rdx

.globl uint_add_fg
uint_add_fg:
    pushq %rbp
    xorq %rbp, %rbp
    pushq %r12
    movq %rcx, %r12
    pushq %r13
    movq %rdx, %r13
    pushq %r14
    movq %rsi, %r14
    pushq %r15
    movq %rdi, %r15
    movq %rbp, %rdi
    call malloc
    pushw %bx
    xorw %bx, %bx

    uint_add_loop:
        cmpq %rbp, %r14
        jle uint_add_end
            addb (%r15, %rbp), %bl
        jnc uint_add_f_not_carray
            incb %bh
        uint_add_f_not_carray:

        cmpq %rbp, %r12
        jle uint_add_s_not_add
            addb (%r13, %rbp), %bl
            incb %bl
            jnz uint_add_i_not_carray
                incb %bh
            uint_add_i_not_carray:
        uint_add_s_not_add:
        jnc uint_add_s_not_carray
            incb %bh
        uint_add_s_not_carray:
        
        incq %rbp
        movq %rax, %rdi
        movq %rbp, %rsi
        call realloc
        movb %bl, -1(%rax, %rbp)

        shrw $8, %bx
    jmp uint_add_loop

    uint_add_end:
    testb %bl, %bl
    jz uint_add_ret

    decb %bl
    incq %rbp
    movq %rbp, %rsi
    movq %rax, %rdi
    call realloc
    movb %bl, -1(%rax, %rbp)

    uint_add_ret:
    movq %rbp, %rdx
    popw %bx
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %rbp

    retq
