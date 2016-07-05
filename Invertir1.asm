# Invertir caracteres 1
# Adolfo Jeritson
# 2016

.data
palabra:	.asciiz "Venezuela"
respuesta:	.space 30

.text
main:		la $t0, palabra
		li $a0, 0
		
seguir:		lb $t1, 0($t0)
		beqz $t1, fin
		sw $t1, 0($sp)
		addi $sp, $sp, -4
		addi $t0, $t0, 1
		b seguir

fin:		la $t2, respuesta
push: 		lb $s0, 4($sp)
		addi $sp, $sp, 4
		sb $s0, 0($t2)
		addi $t2, $t2, 1
		subi $t0, $t0, 1
		bnez $t0, push
		
		sb $0, 0($t2)
		
		li $v0, 4
		la $a0, respuesta
		syscall
		
		li $v0, 10
		syscall