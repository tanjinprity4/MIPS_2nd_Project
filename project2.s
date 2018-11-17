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
	
exit:
	li $v0, 10                  # system call code for exit = 10
	syscall