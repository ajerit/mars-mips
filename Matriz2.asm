.data
matriz:	.word 1, 4, 2, -1, 3, 8, 5, -4, 2
n:	.word 3
m:	.word 3

.text
	lw $s0, m
	lw $s1, n
	la $t0, matriz
	li $t2, 0
	li $t3, 0
	move $t1, $t0
	
ciclo:	beq $t3, $s1, fin
ciclo2:	move $t0, $t1
	beq $t2, $s0, finc2
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	addi $t2, $t2, 1
	addi $t0, $s0, 12
	b ciclo2

finc2:	li $t0, 0
	addi $t1, $t1, 4
	addi $t3, $t3, 1
	b ciclo	

fin:	li $v0, 10
	syscall

