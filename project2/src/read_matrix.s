.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof,
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    addi sp, sp, -32
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw ra 28(sp)

    # s0 is the pointer to string representing the filename
    add s0, x0, a0
    # s1 is the pointer to string representing the number of rows
    add s1, x0, a1
    # s2 is the pointer to string representing the number of cols
    add s2, x0, a2
    # s3 is the file descriptor
    add s3, x0, x0
    # s4 is used as the total size
    add s4, x0, x0
    # s5 is used as the pointer to the head
    add s5, x0, x0
    # s6 is the return value

    # Use fopen to open the file
    add a1, x0, s0
    addi a2, x0, 0
    jal ra, fopen

    # To store the file descriptor
    add s3, x0, a0

    # Error handling
    addi t0, x0, -1
    beq s3, t0, open_error

    # Row
    add a1, x0, s3
    add a2, x0, s1
    addi a3, x0, 4
    jal ra, fread

    # Error handling
    addi t0, x0, 4
    bne a0, t0, read_error

    # Col
    add a1, x0, s3
    add a2, x0, s2
    addi a3, x0, 4
    jal ra, fread

    # Error handling
    addi t0, x0, 4
    bne a0, t0, read_error

    # To calculate the total size
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul s4, t0, t1

    # To allocate the memory
    addi t0, x0, 4
    mul a0, t0, s4
    jal ra, malloc

    add s5, x0, a0
    # Error handling
    add t0, x0, x0
    beq s5, t0, malloc_error

    # To read the remained
    add a1, x0, s3
    add a2, x0, s5
    addi t0, x0, 4
    mul a3, t0, s4
    jal ra, fread

    # Error handling
    addi t0, x0, 4
    mul t0, t0, s4
    bne a0, t0, read_error

    add s6, x0, s5

    j end

open_error:
    addi s6, x0, 50
    j end

read_error:
    addi s6, x0, 51
    j end

malloc_error:
    addi s6, x0, 48
    j end

end:

    add a1, x0, s3
    jal ra, fclose

    add t0, x0, x0
    beq a0, t0, restore
    addi s6, x0, 52

restore:
    add a0, x0, s6
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp, sp, 32

    ret
