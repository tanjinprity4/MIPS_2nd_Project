.data
	userInput: .space 10000
	empty: .asciiz "Input is empty."
	invalid: .asciiz "Invalid base-36 number."
	long: .asciiz "Input is too long."
.text                           # Assembly language instructions
main:
	li $v0, 8  #  Taking in input
	la $a0, userInput  #  load byte space into address
	li $a1, 10000  #  allot the byte space for string
	syscall
	move $t0, $a0  #  move user input to $t0
	move $t7, $a0  #  move user input in another register, $t7 for later
	
check_if_empty:
	lb $a0, 0($t0)
	beq $a0, 10, empty
	j loop
	
empty:
	li $v0, 4  		# for printing string
	la $a0, empty  		
	syscall
	j exit
	
	li $t2, 0		#$t2 will be used for length of characters
	li $t4, -10		
	li $t3, 0		#$t3 will count space
	li $s0, -1 		# check if valid
	li $s1, 0  		# total valid characters
	
loop:
	lb $a0, 0($t0)
	beq $a0, 10, conversion 	#if linefeed found, conversion starts
	addi $t0, $t0, 1		
	slti $t1, $a0, 123        #if value in $a0 less than 123, char valid or $t1 = 1
	beq $t1, $zero, char_invalid
	beq $a0, 32, space
	slti $t1, $a0, 48
	bne $t1, $zero, char_invalid
	slti $t1, $a0, 58
	bne $t1, $zero, char_digit
	slti $t1, $a0, 65
	bne $t1, $zero, char_invalid
	slti $t1, $a0, 91 
	bne $t1, $zero, char_upper
	slti $t1, $a0, 97 
	bne $t1, $zero, char_invalid
	slti $t1, $a0, 123
	bne $t1, $zero, char_lower
	j loop
space:
	beq $t2, 0, loop
	beq $t4, 1, space_after_valid_char
	beq $t4, 0, increase_space_count
	j loop
	
increase_space_count:
	addi $t3, $t3, 1  
	j loop

space_after_valid_char:
	li $t4, 0
	addi $t3, $t3, 1  
	j loop
	
char_invalid:
	li $s0, -1
	addi $t2, $t2, 1  #  increment for character count
	bne $t2, 1, check_prev  #  if valid char occered for multiple occurences check all prev char to be correct
	li $t4, 1  # only set if first valid char is seen
	j loop
	
char_digit:
	addi $s1, $s1, 1  #  increment for valid character count
	addi $t2, $t2, 1  #  increment for character count
	
	
exit:
	li $v0, 10                  # system call code for exit = 10
	syscall