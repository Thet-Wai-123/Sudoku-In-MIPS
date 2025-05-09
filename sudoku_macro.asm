.data
	track: .space 40  # 10 * 4 bytes (index 0 unused)

.text

# addr = baseAddr + (row * 9 + column) * 4
.macro get_value(%row, %column)
	# Base address of board
	move $t0, $s0
	
	# Correct index = row * 9 + column
	mul $t1, %row, 9
	add $t1, $t1, %column

	# Multiply by size of word (4 bytes)
	mul $t1, $t1, 4

	# Address of desired cell
	add $t0, $t0, $t1

	# Load word into $v0
	lw $v0, 0($t0)
.end_macro

# Macro to clear the track array
.macro clearLoop()
	li $t2, 0
	la $t3, track 
_clearLoop_loop:
	bgt $t2, 8, _clearLoop_end
	
	sw $zero, 0($t3)
	
	addi $t2, $t2, 1
	addi $t3, $t3, 4
	j _clearLoop_loop

_clearLoop_end:
.end_macro

# Macro to check duplicates in a row
# Assumes $t8 = row index
# Returns $v0 = 0 if no duplicates, 1 if duplicate found
.macro checkRowDuplicates()
	li $t2, 0           # column index = 0
_checkRowDup_loop:
	bgt $t2, 8, _checkRowDup_end
	
	get_value($t8, $t2)
	move $t9, $v0
	
	# skip empty cells
	beq $t9, $zero, _checkRowDup_next
	
	# convert to 0-based index
	subi $t9, $t9, 1
	
	# calculate address in track array
	mul $t4, $t9, 4
	la $t5, track
	add $t4, $t4, $t5
	
	# if value moved to $t6 from memory is 1, it is a duplicate
	lw $t6, 0($t4)
	beq $t6, 1, _checkRowDup_found
	
	# update array in memory to be 1 as value has been used in row
	li $t7, 1
	sw $t7, 0($t4)

_checkRowDup_next:
	addi $t2, $t2, 1
	j _checkRowDup_loop

_checkRowDup_found:
	# increment cell number again because we decremented it for 0-based index
	addi $t9, $t9, 1
	
	# load results
	li $v0, 1
	move $v1, $t9

_checkRowDup_end:
	li $v0, 0
_checkRowDup_exit:
.end_macro

# Macro to check duplicates in a column
# Assumes $t8 = column index
# Returns $v0 = 0 if no duplicates, 1 if duplicate found
.macro checkColumnDuplicates()
	li $t2, 0           # row index = 0
_checkColumnDup_loop:
	bgt $t2, 8, _checkColumnDup_end
	
	get_value($t2, $t8)
	move $t9, $v0
	
	# skip empty cells
	beq $t9, $zero, _checkColumnDup_next
	
	# convert to 0-based index
	subi $t9, $t9, 1
	
	# calculate address in track array
	mul $t4, $t9, 4
	la $t5, track
	add $t4, $t4, $t5
	
	# if value moved to $t6 from memory is 1, it is a duplicate
	lw $t6, 0($t4)
	beq $t6, 1, _checkColumnDup_found
	
	# update array in memory to be 1 as value has been used in column
	li $t7, 1
	sw $t7, 0($t4)

_checkColumnDup_next:
	addi $t2, $t2, 1
	j _checkColumnDup_loop

_checkColumnDup_found:
	# increment cell number again because we decremented it for 0-based index
	addi $t9, $t9, 1
	
	# load results
	li $v0, 1
	move $v1, $t9
	j _checkColumnDup_exit

_checkColumnDup_end:
	li $v0, 0
_checkColumnDup_exit:
.end_macro

# Macro to check row for duplicates
# %row = row index
# $v0 = 0 if no duplicates, 1 if duplicate exists
.macro checkRow(%row)
	# Setup
	la $t3, track
	clearLoop()

	move $t8, %row
	checkRowDuplicates()
.end_macro

.macro checkColumn(%column)
	# Setup
	la $t3, track
	clearLoop()

	move $t8, %column
	checkColumnDuplicates()
.end_macro

.macro printInt(%int)
	li $v0, 1
	move $a0, %int
	syscall
.end_macro
