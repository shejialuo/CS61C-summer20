.globl write_matrix

.data
row: .word 0
col: .word 0

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof,
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    addi sp, sp, -28
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw ra 24(sp)

    # s0 is the pointer to string representing the filename
    add s0, x0, a0
    # s1 is the pointer to the start of the matrix memory
    add s1, x0, a1
    # s2 is the number of rows
    add s2, x0, a2
    # s3 is the number of cols
    add s3, x0, a3
    # s4 is the file descriptor
    add s4, x0, x0
    # s5 is the return value
    add s5, x0, x0

    # First, open the file to get the file descriptor
    add a1, x0, s0
    addi a2, x0 , 1
    jal ra, fopen

    # To store the file descriptor
    add s4, x0, a0

    # Error handling
    addi t0, x0, -1
    beq s4, t0, open_error

    # Write the row
    add a1, x0, s4
    la a2, row
    sw s2, 0(a2)
    addi a3, x0, 1
    addi, a4, x0, 4
    jal ra, fwrite

    # Error handling
    addi t0, x0, 1
    bne a0, t0, write_error

    # Write the col
    add a1, x0, s4
    la a2, col
    sw s3, 0(a2)
    addi a3, x0, 1
    addi, a4, x0, 4
    jal ra, fwrite

    # Error handling
    addi t0, x0, 1
    bne a0, t0, write_error

    # Write to the file
    mul t0, s2, s3
    add a1, x0, s4
    add a2, x0, s1
    add a3, x0, t0
    addi a4, x0, 4
    jal ra, fwrite

    # Error handling
    mul t0, s2, s3
    bne a0, t0, write_error

    j end

open_error:
    addi s5, x0, 53
    j end

write_error:
    addi s5, x0, 54
    j end

end:

    add a1, x0, s4
    jal ra, fclose

    add t0, x0, x0
    beq a0, t0, restore
    addi s6, x0, 55

restore:
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw ra 24(sp)
    addi sp, sp, 28

    ret
