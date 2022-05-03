.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"
row: .word 0
col: .word 0

.text
main:
    # Read matrix into memory
    la s0 file_path
    la s1 row
    la s2 col

    mv a0 s0
    mv a1 s1
    mv a2 s2
    jal ra read_matrix

    # Print out elements of matrix

    lw a1, 0(s1)
    lw a2, 0(s2)
    jal ra print_int_array

    # Terminate the program
    jal exit
