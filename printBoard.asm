.data
	#board: .space 324
	border_row: .asciiz "---+---+---+\n"
	border_col: .asciiz "|"
	#space: .asciiz "0" 


.eqv printLoopCounter $s5
.eqv printLoopReturnAddress $s6
.eqv printBoardReturnAddress $s7


.text
.globl printBoard
#input is row number, and in $a0
printBoard:
	#printing row by row
	move printBoardReturnAddress, $ra
	li printLoopCounter, 0
	jal printLoop
	
	jr printBoardReturnAddress
	
printLoop:
	#saving the return address
	move printLoopReturnAddress, $ra
	
	# Columns 0-2
	#setting counter
	move $a0, printLoopCounter
	li $a1, 0
	jal printCellValue

	#setting counter
	move $a0, printLoopCounter
	li $a1, 1
	jal printCellValue

	#setting counter
	move $a0, printLoopCounter
	li $a1, 2
	jal printCellValue

	printString(border_col)

	# Columns 3-5
	#setting counter
	move $a0, printLoopCounter
	li $a1, 3
	jal printCellValue

	#setting counter
	move $a0, printLoopCounter
	li $a1, 4
	jal printCellValue

	#setting counter
	move $a0, printLoopCounter
	li $a1, 5
	jal printCellValue

	printString(border_col)
	
	# Columns 6-8
	#setting counter
	move $a0, printLoopCounter
	li $a1, 6
	jal printCellValue

	#setting counter
	move $a0, printLoopCounter
	li $a1, 7
	jal printCellValue

	#setting counter
	move $a0, printLoopCounter
	li $a1, 8
	jal printCellValue

	printString(border_col)
	goToNewLine
	# Go to new line for next row and print border for every third row
	addi $t2, printLoopCounter, 1
	li $t0, 3
	div $t2, $t0
	mfhi $t1    # remainder of printLoopCounter / 3
	beqz $t1, printBorderRow
	j dontPrintBorderRow
	
printBorderRow:
	printString(border_row)	
	addi printLoopCounter, printLoopCounter, 1
	move $ra, printLoopReturnAddress	#this is required because after looping back, the return address is not changed 
	ble printLoopCounter, 8, printLoop
	
	# Jump back to printBoard
	jr printLoopReturnAddress
	
dontPrintBorderRow:
	addi printLoopCounter, printLoopCounter, 1
	move $ra, printLoopReturnAddress	#this is required because after looping back, the return address is not changed 
	ble printLoopCounter, 8, printLoop
	
	# Jump back to printBoard
	jr printLoopReturnAddress


# row, and col
printCellValue:
	get_value($a0, $a1)
	
	# Check if zero(empty cell)
	beqz $v0, printSpace
	move $v1, $v0
	
	li $v0, 1
	move $a0, $v1
	syscall
	
	jr $ra
	
printSpace:
	li $v0, 4
	la $a0, space
	syscall
	jr $ra

exit:
    	li $v0, 10              # terminate program run and
    	syscall                      # Exit 
