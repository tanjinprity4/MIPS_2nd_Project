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
	addi $t2, $t2, 1  
	bne $t2, 1, check_prev 
	li $t4, 1 
	j loop
	
char_digit:
	addi $s1, $s1, 1  
	addi $t2, $t2, 1  
	bne $t2, 1, check_prev 
	li $t4, 1 
	j loop
	
char_upper:
	addi $s1, $s1, 1  
	addi $t2, $t2, 1  
	bne $t2, 1, check_prev
	li $t4, 1
	j loop

char_lower:
	addi $s1, $s1, 1  
	addi $t2, $t2, 1  
	bne $t2, 1, check_prev
	li $t4, 1
	j loop

check_prev:
	beq $t4, 0, space_between_valid_chars 
	j loop

space_between_valid_chars:
	li $s0, -1
	add $t2, $t2, $t3 
	li $t3, 0  
	li $t4, 1  
	j loop

invalid:

	li $v0, 4  
	la $a0, invalid
	syscall
	j exit

conversion:

	li $a1, 36 
	li $a2, 46656  
	li $a3, 4  
	li $t8, 0 

    move $t0, $t7  
    beq $t2, 0, empty  

    slti $t1, $t2, 5  
    beq $t1, $zero, is_long  

    beq $s0, -1, invalid 
    slti $t1, $s1, 4 
    bne $t1, $zero, padding

actual_conversion_loop:
    lb $a0, 0($t0)
    beq $a0, 10, print_value 
    addi $t0, $t0, 1  

    slti $t1, $a0, 123 
    beq $t1, $zero, invalid

    beq $a0, 32, actual_conversion_loop 

    slti $t1, $a0, 48  
    bne $t1, $zero, invalid

    slti $t1, $a0, 58  
    bne $t1, $zero, digit_conversion

    slti $t1, $a0, 65 
    bne $t1, $zero, invalid

    slti $t1, $a0, 91  
    bne $t1, $zero, upper_conversion

    slti $t1, $a0, 97  
    bne $t1, $zero, invalid

    slti $t1, $a0, 123 
    bne $t1, $zero, lower_conversion

    j actual_conversion_loop

digit_conversion:
    addi $a0, $a0, -48 
    mult $a0, $a2  
    mflo $t9
    add $t8, $t8, $t9  
    div $a2, $a1
    mflo $a2 
    j actual_conversion_loop

upper_conversion:
    addi $a0, $a0, -55
    mult $a0, $a2 
    mflo $t9
    add $t8, $t8, $t9  
    div $a2, $a1
    mflo $a2 
    j actual_conversion_loop

lower_conversion:
    addi $a0, $a0, -87
    mult $a0, $a2  
    mflo $t9
    add $t8, $t8, $t9  
    div $a2, $a1
    mflo $a2  
    j actual_conversion_loop

padding:
    sub $t5, $a3, $s1  
padding_loop:
    beq $t5, 0, actual_conversion_loop
    addi $t5, $t5, -1
    div $a2, $a1
    mflo $a2
    j padding_loop

is_long:
    li $v0, 4  
    la $a0, long  
    syscall
    j exit 

print_value:
    li $v0, 1  
    addi $a0, $t8, 0  
    syscall

	
exit:
	li $v0, 10                  
	syscall
