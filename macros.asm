.data
newline: .asciiz "\n"

.macro getInt
	li $v0, 5
	syscall
.end_macro

.macro printInt(%integer)
	li $v0, 1
	move $a0, %integer
 	syscall
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

.macro getCell(%row, %col)
	li $v0, 0
.end_macro

