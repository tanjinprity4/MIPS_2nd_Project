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
	
	li $v0, 10                  # system call code for exit = 10
	syscall