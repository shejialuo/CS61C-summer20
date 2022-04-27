.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1,
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
loop_start:
    addi t0, x0, 1
    blt a2, t0, loop_error1
    blt a3, t0, loop_error2
    blt a4, t0, loop_error2

    addi t0, x0, 4
    mul a3, a3, t0
    mul a4, a4, t0

    # t0 is used as the current length
    add t0, x0, x0
    # t1 is used as the vector 1 offset
    add t1, x0, a0
    # t2 is used as the vector 2 offset
    add t2, x0, a1
    # t3 is used to store the last computed result
    add t3, x0, x0

loop_continue:
    lw t4, 0(t1)
    lw t5, 0(t2)
    mul t4, t4, t5
    add t3, t3, t4
    add t1, t1, a3
    add t2, t2, a4
    addi t0, t0, 1
    blt t0, a2, loop_continue

loop_end:
    add a0, t3, x0
    ret

loop_error1:
    addi a0, x0, 5
    ret

loop_error2:
    addi a0, x0, 6
    ret
