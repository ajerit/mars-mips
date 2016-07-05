.data 
	lista: .word -1, 5, 100, 3, -2, 15
	n: .word 6
	resultado: .asciiz "El maximo es: "
	
.text
	main:	lw $s1, n
		la $s3, lista
		lw $s0, 0($s3)
		li $s2, 1
		
	seguir: bge $s2, $s1, finmax
		add $s3, $s3, 4
		lw $t1, 0($s3)
		ble $t1, $s0, nomax
		move $s0, $t1
	nomax:	add $s2, $s2, 1
		b seguir
	finmax:	li $v0, 4
		la $a0, resultado
		syscall
		
		li $v0, 1
		move $a0, $s0
		syscall
		
		li $v0, 10
		syscall