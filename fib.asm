# Calcular el numero de fibonacci
# Adolfo Jeritson. 12-10523
 
.data 
msj:	.asciiz "Inserte numero para calcular fibonacci\n> "

.text
# Registros 
# a0 se guarda num a calcular, pero no se usa despues
# v0 recibe el resultado despues de llamada
main:	li $v0, 4
	la $a0, msj
	syscall 

	li $v0, 5
	syscall
	move $a0, $v0
	
	# Ni a0 ni v0 actuales se necesitan despues, 
	# por convencion no hay que preservar nada
	# antes de la llamada
	jal fib
	
	move $a0, $v0 
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

# Funcion fib
# Calcula el numero de fibonacci de forma recursiva
# Parametros: a0 numero a calcular
# Devuelve:   v0 numero de fibonacci
# Registros:  t0 temporal de recursion
cero:	li $v0, 0
	jr $ra
	
uno:	li $v0, 1
	jr $ra
	
fib:	beqz $a0, cero
	beq $a0, 1, uno
	
	######################################
	# Convencion inicio
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addu $fp, $sp, 8
	######################################
	
	######################################
	# Preservamos a0 antes de la llamada
	subu $sp, $sp, 4
	sw $a0, 4($sp)
	######################################
	# Primera llamada recursiva fib(n-1)
	addi $a0, $a0, -1
	jal fib
	######################################
	# Recuperamos a0 despues de la llamada
	lw $a0, 4($sp)
	addu $sp, $sp, 4
	######################################
	
	######################################
	# Por convencion preservo v0 antes de la prox llamada.
	subu $sp, $sp, 4 
	sw $v0, 4($sp)
	######################################
	# Segunda llamada recursiva fib(n-2)
	addi $a0, $a0, -2
	jal fib
	######################################
	# No recuperamos nada despues de la llamada
	# Ya que no se necesitan despues
	######################################
	
	# Calculo de la suma fib(n-1)+fib(n-2)
	lw $t0, 4($sp)
	addu $sp, $sp, 4
	add $v0, $v0, $t0
	
	#####################################
	# Convencion fin
	lw $fp, 8($sp)
	lw $ra, 4($sp)
	addu $sp, $sp, 8 
	#####################################
	
	jr $ra