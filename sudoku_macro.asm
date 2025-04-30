# General use macros for sudoku board
# Assume we have access to board from data portion
# Row and column are assumed to be integers stored in registers

.macro get_value(%row, %column)
	#move board address to $t0
	move $t0, board
	
	#multiply column by rowSize
	#rowSize is 9
	mul $t1, %column, 9
	
	#add rowIndex
	add $t1, $t1, %row
	
	#multiply index by dateSize, 4
	mul $t1, $t1, 4
	
	#add index to board address
	add $t0, $t0, $t1
	
	#move cell address to $v0
	move $v0, $t0
.end_macro
