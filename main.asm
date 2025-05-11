.include "sudoku_macro.asm"

.data
emptyBoard: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
board: .word 1,0,7,0,0,0,0,3,0,0,9,6,1,0,0,0,4,0,2,0,0,5,0,3,0,9,0,0,2,8,0,3,4,5,0,1,7,0,3,0,1,0,0,2,0,4,1,0,6,9,0,3,7,0,0,7,2,0,0,0,0,0,4,0,0,1,4,6,0,2,0,0,0,0,9,2,8,0,0,1,0
space: .asciiz " "
newLine: .asciiz "\n"
colLength: .word 9
rowLength: .word 9



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
	
	#check if conditions are met
	
	#set the value in the array
	
	set_value($s2, $s3, $s4)
	
	#next turn
	j gameLoop

	
	#checking sudoku rulesets for column
	move $t8, $s3
	move $t9, $s4
	checkColumnDuplicates
	