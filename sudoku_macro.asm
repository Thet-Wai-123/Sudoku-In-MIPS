.data
	.align 2  
	track: .space 40  # 10 * 4 bytes (index 0 unused)
	newline: .asciiz "\n"
	found: .asciiz "duplicate found"
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

# $v0 : 0=success, 1=rowError, 2=columnError, 3=3x3Error
.macro set_value_if_valid(%row, %column, %value)
	# Base address of board
	move $t0, $s0

	# Correct index = row * 9 + column
	mul $t1, %row, 9
	add $t1, $t1, %column

	# Multiply by size of word (4 bytes)
	mul $t1, $t1, 4

	# Address of desired cell
	add $t0, $t0, $t1

	# Store the previous value and address that was in this spot into memory in $sp
	lw $t1, 0($t0)
	move $s1, $t0
	
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	
	# Write the value here
	sw %value, 0($t0)

	# Checking if valid, if not reverting back
	checkRow(%row)
	beq $v0, 1, invalidRow
	checkColumn(%column)
	beq $v0, 1, invalidColumn
	checkBox(%row, %column)
	beq $v0, 1, invalidNeighbor

	
	addi $sp, $sp, 4
	j endOfMacro
	
invalidRow:
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	li $v0, 1
	j revertBackValue
invalidColumn:
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	li $v0, 2
	j revertBackValue
invalidNeighbor:
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	li $v0, 3
	j revertBackValue
revertBackValue:
	#we set the t1 using the stack pointer, and s1 is the value used to store the address at the top
	sw $t1, 0($s1)
endOfMacro:
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
	
	j _checkRowDup_exit

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

# Macro to check column for duplicates
# %column = column index
# $v0 = 0 if no duplicates, 1 if duplicate exists
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

.macro checkRows
	li $s1, 0
loopRows:
	# stop loop after all rows
	bgt $s1, 8, _loopRows_stop
	checkRow($s1)
	
	# stop loop with outputs already in $v0 & $v1 if duplicate exists
	beq $v0, 1, _loopRows_stop
	
	addi $s1, $s1, 1
_loopRows_stop:
.end_macro

.macro checkColumns
	li $s1, 0
loopColumns:
	# stop loop after all rows
	bgt $s1, 8, _loopColumns_stop
	checkColumn($s1)
	
	# stop loop with outputs already in $v0 & $v1 if duplicate exists
	beq $v0, 1, _loopColumns_stop
	
	addi $s1, $s1, 1
_loopColumns_stop:
.end_macro


# Macro to check duplicates in a 3x3 box
# Assumes $t8 = row index, $t9 = col index
# Returns $v0 = 0 if no duplicates, 1 if duplicate found
.macro checkBoxDuplicates()
    # clear tracker
    la $t3, track
    clearLoop()

    # Compute box start row and column (top-left of 3x3 box)
    div $t0, $t8, 3       # $t0 = box start row index
    mflo $t0
    mul $t0, $t0, 3       # actual row index of box start

    div $t1, $t9, 3       # $t1 = box start col index
    mflo $t1
    mul $t1, $t1, 3       # actual col index of box start

    li $t2, 0             # box row offset
_box_row_loop:
    li $t4, 0             # box col offset
_box_col_loop:
    # Compute actual row and col: a0 = row, a1 = col
    add $a0, $t0, $t2
    add $a1, $t1, $t4

    # Inline get_value(a0, a1)
    mul $t5, $a0, 9       # offset = row * 9
    add $t5, $t5, $a1     # offset += col
    mul $t5, $t5, 4       # offset *= 4
    add $t6, $s0, $t5     # address = base + offset
    lw $t7, 0($t6)        # value = board[row][col]

    # skip if value is 0 (empty cell)
    beqz $t7, _next_box_cell

    # check for duplicates using track array
    subi $t7, $t7, 1      # convert to 0-based index
    mul $t5, $t7, 4
    la $t6, track
    add $t5, $t5, $t6
    lw $t6, 0($t5)
    beq $t6, 1, _found_box_dup
    li $t6, 1
    sw $t6, 0($t5)

_next_box_cell:
    addi $t4, $t4, 1
    blt $t4, 3, _box_col_loop

    addi $t2, $t2, 1
    blt $t2, 3, _box_row_loop

    li $v0, 0
    j _exit_box_check

_found_box_dup:
    li $v0, 1
_exit_box_check:
.end_macro



# Macro to check 3x3 box for duplicates
# %row = row index, %col = col index
# $v0 = 0 if no duplicates, 1 if duplicate exists
.macro checkBox(%row, %col)
    move $t8, %row
    move $t9, %col
    checkBoxDuplicates()
.end_macro


# macro to check if entire board is filled
# since check for duplicate numbers is part of input validation, this only checks all spaces in the board are filled
# we assume board address is at $s0
# output: $v0 is 0 to indicate win, 1 to indicate board is still incomplete
.macro checkWin
	# initialize counter at $t0
	li $t0, 0
loop:
	# check if entire board has been traversed
	bge $t0, 81, _checkWin_complete
	
	# calculate memory address of current index
	mul $t1, $t0, 4
	add $t1, $t1, $s0
	
	# load cell number into $t1
	lw $t1, 0($t1)
	
	# jump to incomplete if cell number is 0 (value has not been filled)
	beq $t1, 0, _checkWin_incomplete
	
	# increment counter and begin next iteration
	addi $t0, $t0, 1
	j loop
_checkWin_complete:
	li $v0, 0
	j _checkWin_exit
_checkWin_incomplete:
	li $v0, 1
	j _checkWin_exit
_checkWin_exit:
.end_macro
 
.macro printString(%string)
    li $v0, 4
    la $a0, %string
    syscall
.end_macro

.macro goToNewLine
    li $v0, 4
    la $a0, newline
    syscall
.end_macro

#returns 1 if the cell is mutable, and 0 if not into v0
.macro checkIfCellIsMutable(%row, %column, %allowChange)
	# Base address of board
	la $t0 %allowChange
	
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
	

	
