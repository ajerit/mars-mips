.data
mensaje:	.asciiz "Hola "
nombre:		.asciiz "Organizacion del Computador"
linea:		.asciiz "\n"

.text
main:
	li $v0, 4
	la $a0, mensaje
	syscall
	
	li $v0, 4
	la $a0, nombre
	syscall
	
	la $a0, linea
	syscall
	
	li $t0, 10
	sll $a0, $t0, 2
	li $v0, 1
	syscall
	
	li $v0,10
	syscall