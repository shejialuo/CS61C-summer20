.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1,
# this function exits with error code 7.
# =================================================================
argmax:
loop_start:
    add t0, x0, x0
    addi t0, x0, 1
    blt a1, t0, loop_error
    # t0 is used as the current length
    add t0, x0, x0
    # t1 is used as the offset
    add t1, x0, x0
    add t1, x0, a0
    # t2 is used as the index stored
    add t2, x0, x0
    # t3 is used as the minimum
    lw t3, 0(t1)

loop_continue:
    lw t4, 0(t1)
    bge t3, t4, greater_equal_min
    add t2, t0, x0
    add t3, t4, x0
  greater_equal_min:
    addi t0, t0, 1
    addi t1, t1, 4
    blt t0, a1, loop_continue

loop_end:
    add a0, t2, x0
    ret

loop_error:
    add a0, x0, x0
    addi a0, x0, 7
    ret
