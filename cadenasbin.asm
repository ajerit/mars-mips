# Imprimir cadenas de largo n de 0 y 1
# Adolfo Jeritson

.data
msj:	.asciiz "Inserte el largo de las cadenas\n> "
s: 	.asciiz ""

.text
	li $v0, 4
	la $a0, msj
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $v0
	la $a1, s 
	jal cBin
	
	li $v0, 10
	syscall

# a0 tiene el n
# a1 tiene dir del string
base: 	# Concatenar lo que tengo (dir de copia s guardado en $a1)
	# con 0 e imprimir, luego concat con 1 e imprimir
	jr $ra

cBin:	beq $a0, 1, base

	######################################
	# Convencion inicio
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addu $fp, $sp, 8
	######################################
	
	# Primera llamada recursiva
	subu $sp, $sp, 8
	sw $a1, 8($sp)
	sw $a0, 4($sp)
	
	# Copia1 de s
	li $v0, 9
	li $a0, 1
	move $a1, $v0
	
	lw $t1, 8($sp)
ciclo1:	lb $t0, 0($t1)
	beqz $t0, fin1
	sb $t0, 0($a1)
	addi $t1, $t1, 1
	addi $a1, $a1, 1
	
	b ciclo1
	
fin1:	lw $a0, ($sp)
	subi $a0, $a0, 1
	
	jal cBin
	
	# Copia2 de s
	li $v0, 9
	li $a0, 1
	move $a1, $v0
	
	lw $t1, 8($sp)
ciclo2:	lb $t0, 0($t1)
	beqz $t0, fin2
	sb $t0, 0($a1)
	addi $t1, $t1, 1
	addi $a1, $a1, 1
	
	b ciclo2	
	
fin2:	lw $a0, ($sp)
	subi $a0, $a0, 1
	jal cBin
	
	#####################################
	# Convencion fin
	lw $fp, 8($sp)
	lw $ra, 4($sp)
	addu $sp, $sp, 8 
	#####################################
	
	jr $ra

	