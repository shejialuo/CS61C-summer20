.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense,
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense,
#   this function exits with exit code 3.
#   If the dimensions don't match,
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	  a1 (int)   is the # of rows (height) of m0
#	  a2 (int)   is the # of columns (width) of m0
#	  a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	  a5 (int)   is the # of columns (width) of m1
#	  a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    addi t0, x0, 1
    blt a1, t0, loop_error1
    blt a2, t0, loop_error1
    blt a4, t0, loop_error2
    blt a5, t0, loop_error2
    bne a2, a4, loop_error3

    addi sp, sp, -44
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw ra 40(sp)

    # s0 is used as the first matrix row pointer
    add s0, x0, a0
    # s1 is used as the second matrix column pointer
    add s1, x0, a3
    # s2 is used as the current pointer to the result
    add s2, x0, a6

    # s3 is used as the step of s0
    add t0, x0, a2
    addi t1, x0, 4
    mul t0, t0, t1
    add s3, t0, x0

    # s4 is used as the outer iteration step
    add s4, x0, a1

    # s5 is used as the inner iteration step
    add s5, x0, a5

    # s6 is used as the length of the dot
    add s6, x0, a2

    # s7 is used as the outer iteration index
    add s7, x0, x0
outer_loop_start:

    # s8 is used as the inner iteration index
    add s8, x0, x0

    # s9 is used as the innert pointer
    add s9, x0, s1

inner_loop_start:

    add a0, x0, s0
    add a1, x0, s9
    add a2, x0, s6
    addi a3, x0, 1
    add a4, x0, s5
    jal ra, dot
    sw a0, 0(s2)

    addi s8, s8, 1
    addi s9, s9, 4
    addi s2, s2, 4

    blt s8, s5, inner_loop_start

inner_loop_end:

    addi, s7, s7, 1
    add, s0, s0, s3
    blt s7, s4, outer_loop_start

outer_loop_end:

    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw ra 40(sp)
    addi sp, sp, 44

    ret

loop_error1:
    addi a0, x0, 2
    ret
loop_error2:
    addi a0, x0, 3
    ret
loop_error3:
    addi a0, x0, 4
    ret
