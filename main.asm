.include "sudoku_macro.asm"

.data
emptyBoard: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
board: .word 1,0,7,0,0,0,0,3,0,0,9,6,1,0,0,0,4,0,2,0,0,5,0,3,0,9,0,0,2,8,0,3,4,5,0,1,7,0,3,0,1,0,0,2,0,4,1,0,6,9,0,3,7,0,0,7,2,0,0,0,0,0,4,0,0,1,4,6,0,2,0,0,0,0,9,2,8,0,0,1,0



space: .asciiz " "
newLine: .asciiz "\n"
colLength: .word 9
rowLength: .word 9
brokeRowMessage: .asciiz "Invalid move. That number is already in the row. \n\n"
brokeColumnMessage: .asciiz "Invalid move. That number is already in the column. \n\n"
check: .asciiz "we just checked rows"
winMessage: .asciiz "You win, and completed the sudoku board!!!"



.text
.globl main
main:
	la $s0, board
	j gameLoop

gameLoop:
	#right now printBoard is set up with dummy values- need to read from s0- change inside printBoard.asm
	jal printBoard

	#get the user inputs
	jal getInput #row in s2, and then column in s3, and value in s4
	
	#subtract s2 and s3 by 1 to match the index 0 start in the internal implementations
	subi $s2, $s2, 1
	subi $s3, $s3, 1
	
	#set the value in the array
	set_value_if_valid($s2, $s3, $s4)
	
	beq $v0, 1, brokeRow
	beq $v0, 2, brokeColumn
	
	checkWin
	beq $v0, 0, gameOver
	
	#next turn
	j gameLoop

	
brokeRow:
	printString(brokeRowMessage)
	j gameLoop
	
brokeColumn:
	printString(brokeColumnMessage)
	j gameLoop
	
gameOver:
	printString(winMessage)
	li $v0, 10
	syscall
	



	
