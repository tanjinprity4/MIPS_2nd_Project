.data

.text                           # Assembly language instructions
main:

	li $v0, 10                  # system call code for exit = 10
	syscall