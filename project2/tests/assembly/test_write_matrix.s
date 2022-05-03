.import ../../src/write_matrix.s
.import ../../src/utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9 # MAKE CHANGES HERE TO TEST DIFFERENT MATRICES
file_path: .asciiz "outputs/test_write_matrix/student_write_outputs.bin"

.text
main:
    la s0 m0
    la s1 file_path

    addi s2, x0, 3
    addi s3, x0, 3
    mv a0 s1
    mv a1 s0
    mv a2 s2
    mv a3 s3

    jal ra write_matrix

    # Exit the program

    jal exit
