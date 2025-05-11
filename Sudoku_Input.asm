.data
# Data for input
prompt_row: .asciiz "Enter row (1-9): "
prompt_col: .asciiz "Enter col (1-9): "
prompt_val: .asciiz "Enter value (1-9), 0 to delete value: "
error_msg: .asciiz "Invalid input. Please enter a value between 1 and 9.\n"

.text
.globl getInput
getInput:
    # Read the row
get_row:
    li   $v0, 4                    # Print prompt_row message
    la   $a0, prompt_row
    syscall

    li   $v0, 5                    # Read integer input
    syscall
    move $s2, $v0                  # Store the row in $s2

    # Check if row is valid (1-9)
    blt  $s2, 1, invalid_input_row # If row < 1, go to invalid input
    bgt  $s2, 9, invalid_input_row # If row > 9, go to invalid input

    # Read the column
get_col:
    li   $v0, 4                    # Print prompt_col message
    la   $a0, prompt_col
    syscall

    li   $v0, 5                    # Read integer input
    syscall
    move $s3, $v0                  # Store the column in $s3

    # Check if column is valid (1-9)
    blt  $s3, 1, invalid_input_col # If col < 1, go to invalid input
    bgt  $s3, 9, invalid_input_col # If col > 9, go to invalid input

    # Read the value
get_val:
    li   $v0, 4                    # Print prompt_val message
    la   $a0, prompt_val
    syscall

    li   $v0, 5                    # Read integer input
    syscall
    move $s4, $v0                  # Store the value in $s4

    # Check if value is valid (1-9)
    blt  $s4, 0, invalid_input_val # If value < 0 go to invalid input
    bgt  $s4, 9, invalid_input_val # If value > 9, go to invalid input

    jr $ra  # Return to the caller function when inputs are valid

# Invalid input handlers
invalid_input_row:
    li $v0, 4                       # Print error message
    la $a0, error_msg
    syscall
    j get_row                        # Loop back to input row

invalid_input_col:
    li $v0, 4                       # Print error message
    la $a0, error_msg
    syscall
    j get_col                        # Loop back to input column

invalid_input_val:
    li $v0, 4                       # Print error message
    la $a0, error_msg
    syscall
    j get_val                        # Loop back to input value