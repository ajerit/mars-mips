# velocidad.s
# Calcula la velocidad final de un cuerpo en caida libre.

.data
vo:	.asciiz "Introduzca la velocidad inicial\n> "
tiempo:	.asciiz "Introduzca el tiempo\n> "

.text
main:
	li $v0, 4
	la $a0, vo
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	li $v0, 4
	la $a0, tiempo
	syscall
	li $v0, 5
	syscall
	
	move $a0, $t0
	move $a1, $v0
	
	jal velocidad
	
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 10
	syscall

# fun velocidad(vo, t)
# Calcula la velocidad final de un cuerpo
# en caida libre con velocidad inicial vo,
# transcurrido un tiempo t
# Parametros:
# a0  vo
# a1  t
# Devuelve: $v0  velocidad final
velocidad:
	subu $sp, $sp, 12
	sw $fp, 12($sp)
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	addu $fp, $sp, 12
# Registros:
# s0 valor de la formula
	move $s0, $a0
	move $a0, $a1
	jal cuadrado
	li $t0, 5
	mul $t0, $t0, $v0
	add $s0, $s0, $t0
	
	move $v0, $s0
	lw $fp, 12($sp)
	lw $ra, 8($sp)
	lw $s0, 4($sp)
	addu $sp, $sp, 12
	jr $ra

# fun cuadrado(n)
# Eleva un numero al cuadrado
# Parametros:
# a0  n
cuadrado:
	mul $v0, $a0, $a0
	jr $ra
