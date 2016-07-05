# Adolfo Jeritson. 12-10523
# Tarea 1. Taller de Organizacion del Computador
# Ultima modificacion: 26/04/2016

.data
mensaje:	.asciiz "Hola "
nombre:		.asciiz "Organizacion del Computador"
linea:		.asciiz "\n"
mensaje2: 	.asciiz "Ingresa tu nombre: "
mensaje3: 	.asciiz "Ingresa tu edad: "
name: 		.space 50			# Guardamos el espacio para el nombre

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
	
	# Tarea: input nombre y edad 
	li $v0, 4
	la $a0, linea
	syscall
	
	la $a0, mensaje2		
	syscall
	
	li $v0, 8
	la $a0, name
	li $a1, 41
	syscall				# Se recibe el nombre en name, max 40 caracteres 
	
	li $v0, 4
	la $a0, mensaje3		
	syscall
	
	li $v0, 5
	syscall				# Se recibe la edad en $v0
	move $t0, $v0			# Movemos la edad $t0 para que no se borre
	
	li $v0, 4
	la $a0, name
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall				# Imprimimos la edad
	
	li $v0, 10
	syscall
	
	
	
	
