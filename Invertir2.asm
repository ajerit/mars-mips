.data
cadena:		.asciiz "Venezuela"
respuesta:	.space 30

.text
main:		la $t0, cadena
		li $t1, 0
		
ciclo:		lb $t2, 0($t0)
		beqz $t2, fin
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		b ciclo
		
fin:		la $t3, respuesta
ciclo2:		addi $t0, $t0, -1
		beqz $t1, imprimir
		lb $t2, 0($t0)
		sb $t2, 0($t3)
		addi $t3, $t3, 1
		addi $t1, $t1, -1
		b ciclo2
		
imprimir: 	sb $zero, 0($t3)
		li $v0, 4
		la $a0, respuesta
		syscall
		
		li $v0, 10
		syscall