     # .data: prompts for getInput function
.data
prompt_row: .asciiz "Enter row  (1–9, 0 to exit): "
prompt_col: .asciiz "Enter col  (1–9, 0 to exit): "
prompt_val: .asciiz "Enter value(1–9, 0 to clear): "

    # .macro is the getInt function — wrapper for syscall 5
    .macro getInt dst
        li   $v0, 5       # syscall: read integer
        syscall
        move \dst, $v0
    .end_macro
    # getInput uses the function (jal/jr)
    # Will return:
    # $v0 = row
    # $v1 = col
    # $v2 = val
    .text
    .globl getInput
getInput:
    # reads the row 
    li   $v0, 4       # prints prompt_row
    la   $a0, prompt_row
    syscall
    getInt $a0       # read into $a0
    move $v0, $a0       # return the row to $v0

    # optional: range check 0–9, otherwise reprompt if invalid
    # reads the collumn
    li   $v0, 4
    la   $a0, prompt_col
    syscall
    getInt $a0       # read into $a0
    move $v1, $a0       # returns thr col to $v1

    # reads the value
    li   $v0, 4
    la   $a0, prompt_val
    syscall
    getInt $a0       # read into $a0
    move $v2, $a0       # return the val function to $v2

    jr   $ra       # sends back to the caller







    ####### For the .text/main section: #######
    jal  getInput
    # So now: $v0=row, $v1=col, $v2=val
    # checks for an exit condition, such as: beq $v0,$zero,exit, and more
    # compute the index and stores into the grid as before

