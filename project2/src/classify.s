.globl classify

.data
m0: .word 0 0
m1: .word 0 0
input: .word 0 0

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    #
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    addi t0, x0, 5
    bne a0, t0, arg_error

    addi sp, sp, -40
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw ra 36(sp)

    # s0 is argc
    add s0, x0, a0
    # s1 is argv
    add s1, x0, a1
    # s2 is a flag to indicate whether print
    add s2, x0, a2
    # s3 is a pointer to point to the m0
    add s3, x0, x0
    # s4 is a pointer to point to the m1
    add s4, x0, x0
    # s5 is a poiner to point to the input matrix
    add s5, x0, x0
    # s6 is the dynamic memory in the heap
    add s6, x0, x0
    # s7 is the dynamic memory in the heap
    add s7, x0, x0
    # s8 is the return value
    add s8, x0, x0

	  # =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0

    lw a0, 4(s1)
    la t0, m0
    addi a1, t0, 0
    addi a2, t0, 4
    jal ra, read_matrix

    add s3, a0, x0

    # Load pretrained m1

    lw a0, 8(s1)
    la t0, m1
    addi a1, t0, 0
    addi a2, t0, 4
    jal ra, read_matrix

    add s4, a0, x0

    # Load input matrix

    lw a0, 12(s1)
    la t0, input
    addi a1, t0, 0
    addi a2, t0, 4
    jal ra, read_matrix

    add s5, a0, x0

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # Here, we need to allocate the memory
    la t0, m0
    la t1, input
    lw t2, 0(t0)
    lw t3, 4(t1)
    mul t4, t2, t3
    addi t5, x0, 4
    mul a0, t4, t5

    jal ra, malloc
    add s6, a0, x0

    # m0 * input
    add a0, x0, s3
    la t0, m0
    lw a1, 0(t0) # m0 row
    lw a2, 4(t0) # m0 col
    add a3, x0, s5
    la t0, input
    lw a4, 0(t0) # input row
    lw a5, 4(t0) # input col
    add a6, x0, s6
    jal ra, matmul

    # ReLU(m0 * input)
    add a0, x0, s6
    la t0, m0
    la t1, input
    lw t2, 0(t0)
    lw t3, 4(t1)
    mul a1, t2, t3
    jal ra, relu

    # m1 * ReLU(m0 * input)
    la t0, m1
    la t1, input
    lw t2, 0(t0)
    lw t3, 4(t1)
    mul t4, t2, t3
    addi t5, x0, 4
    mul a0, t4, t5

    jal ra, malloc
    add s7, a0, x0

    add a0, s4, x0
    la t0, m1
    lw a1, 0(t0) # m1 row
    lw a2, 4(t0) # m1 col
    add a3, s6, x0
    la t0, m0
    la t1, input
    lw a4, 0(t0)
    lw a5, 4(t1)
    add a6, x0, s7

    jal ra, matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw a0, 16(s1)
    add a1, s7, x0
    la t0, m1
    la t1, input
    lw a2, 0(t0)
    lw a3, 4(t1)

    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    la t0, m1
    la t1, input
    lw t2, 0(t0)
    lw t3, 4(t1)
    mul t4, t2, t3

    add a0, x0, s7
    add a1, x0, t4
    jal ra, argmax

    # Print classification

    add s8, x0, a0
    bne s2, x0, end
    add a1, x0, s8
    jal ra, print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal ra, print_char

end:

    add a0, s3, x0
    jal ra, free
    add a0, s4, x0
    jal ra, free
    add a0, s5, x0
    jal ra, free
    add a0, s6, x0
    jal ra, free
    add a0, s7, x0
    jal ra, free


    add a0, s8, x0
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw ra 36(sp)
    addi sp, sp, 40

    ret
arg_error:
    addi a0, x0, 49
    ret