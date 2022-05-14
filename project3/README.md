# Project 3

Look, I made a CPU! Here's what I did:

+ ALU part: It's an easy component. 2's complement makes addition
and subtraction easier, however, it makes multiplication complicated.
In this project, we already have a multiplier for two unsigned number.
When we just want the low 32 bit of the result, it doesn't matter, which
means for the multiplier for two unsigned number, although the inputs are
two signed number, the low 32 bit is the same. But we want to finish the
functionality of `mulh`. So we need to first convert the signed number to
unsigned number. And product the two converted unsigned numbers and last
we need to convert the production to signed number.
+ Register file part: It is simple to construct a register file. We need two
multiplexors to determine the register we want to read. And for writing, we
should use a demultiplexor to determine which register to write

