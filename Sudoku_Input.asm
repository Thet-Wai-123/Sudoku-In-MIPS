     # .data: prompts for getInput function
.data
prompt_row: .asciiz "Enter row  (1–9, 0 to exit): "
prompt_col: .asciiz "Enter col  (1–9, 0 to exit): "
prompt_val: .asciiz "Enter value(1–9, 0 to clear): "

.text
.globl getInput
getInput:
    # Reads the row
    li   $v0, 4
    la   $a0, prompt_row
    syscall

    li   $v0, 5
    syscall
    move $v0, $v0   #returns the row in $v0

    # Reads a colummn
    li   $v0, 4
    la   $a0, prompt_col
    syscall

    li   $v0, 5
    syscall
    move $v1, $v0   #returns the col in $v1

    # Reads the value
    li   $v0, 4
    la   $a0, prompt_val
    syscall

    li   $v0, 5
    syscall
    move $v2, $v0   #returns val in $v2

    jr $ra
    
    
    
    
    
    
    ####### For the .text/main section: #######
    .text
.globl main
main:
    jal getInput
    #you can use $v0 (row), $v1 (col), $v2 (val)
    # e.g., check for exit:
    beq $v0, $zero, exit
#More logic can go here if anythimg

exit:
    li $v0, 10
    syscall
