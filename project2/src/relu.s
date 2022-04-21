.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1,
# this function exits with error code 8.
# ==============================================================================
relu:
loop_start:

    add t0, x0, x0
    addi t0, x0, 1
    blt a1, t0, loop_error

    # t0 is used as the current length
    add t0, x0, x0
    # t1 is used as the offset
    add t1, x0, x0
    add t1, x0, a0


loop_continue:
    lw t2, 0(t1)
    bge t2, x0, great_than_0
    add t3, x0, x0
    sw t3, 0(t1)
  great_than_0:
    addi t0, t0, 1
    addi t1, t1, 4
    blt t0, a1, loop_continue
loop_end:
	  ret
loop_error:
    add a0, x0, x0
    addi a0, x0, 8
    ret
