.data
matriz:	.word 1, 4, 2, -1, 3, 8, 5, -4, 2
n:	.word 3
m:	.word 3

.text
	la $t0, matriz
	la $t1, matriz
	li $t2, 0
	li $t3, 0
	lw $t4, n
	lw $t5, m
	
ciclo:	beq $t2, $t5, ciclo2
	mul $t1, $t3, 4
	add $t1, $t1, $t0
	li $v0, 1
	lw $a0, 0($t1)
	syscall
	
	mul $t6, $t5, 4
	add $t0, $t0, $t6
	addi $t2, $t2, 1
	b ciclo

ciclo2:	beq $t3, $t4, fin
	addi $t3, $t3, 1
	la $t0, matriz
	b ciclo	
	
fin: 	li $v0, 10
	syscall
	 