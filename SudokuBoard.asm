# Create the board
# A pregenerated board is intialized
# A completely empty board with 0's for every position can be replaced by changing the address to "emptyBoard"

# (As an aside we could use a loop to initalize the values)
# (In addition if we want to generate our own boards we can do it with an algorithm)
# (1. Create a solvable board by placing in numbers randomly and checking if it is valid.)
# (2. Once a complete board is created, begin removing numbers randomly and checking if: )
# ( a. The board is still solvable )
# ( b. The puzzle has only 1 unique solution )
# ( If not we put the number back and repeat for n number of times [ n changes depending on difficulty])

.data
emptyBoard: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
board: .word 1,0,7,0,0,0,0,3,0,0,9,6,1,0,0,0,4,0,2,0,0,5,0,3,0,9,0,0,2,8,0,3,4,5,0,1,7,0,3,0,1,0,0,2,0,4,1,0,6,9,0,3,7,0,0,7,2,0,0,0,0,0,4,0,0,1,4,6,0,2,0,0,0,0,9,2,8,0,0,1,0
space: .asciiz " "
newLine: .asciiz "\n"
colLength: .word 9
rowLength: .word 9

.text
main:
    la $s0, board
    lw $t0, colLength     # number of rows
    lw $t1, rowLength     # number of columns (save original value too)
    move $t3, $t1         # $t3 will store the original rowLength to reset later

printLoop:
    beqz $t0, exit        # If no more rows, exit

printRow:
    beqz $t1, nextRow     # If no more columns, go to next row

    lw $t2, 0($s0)        # Load element from board
    
    # Print integer
    li $v0, 1
    move $a0, $t2
    syscall

    # Print space
    li $v0, 4
    la $a0, space
    syscall

    addi $s0, $s0, 4      # Move to next element (4 bytes)
    subi $t1, $t1, 1      # Decrease column counter
    j printRow

nextRow:
    # After finishing a row, print newline
    li $v0, 4
    la $a0, newLine
    syscall

    move $t1, $t3         # Reset column counter
    subi $t0, $t0, 1      # Decrease row counter
    j printLoop

exit:
    li $v0, 10
    syscall
