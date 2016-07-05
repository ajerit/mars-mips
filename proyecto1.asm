###################################################################
# Organizacion del Computador. Abril - Julio 2016. USB 		  #
# Adolfo Jeritson. 12-10523					  #
# Proyecto 1							  #	
#								  #
# Reprodutor de melodias. La melodia se lee en un archivo donde	  #
# se ecuentra en formato MIDI. Se guarda en memoria y se puede    #
# reproducir, transportar o cambiar tempo. Al transportar, se     #
# reproduce una vez modificada y luego regresa a la melodia       #
# original. El tempo por defecto es 120 y al modificarlo se       #
# mantiene en reproducciones sucesivas.				  #
# 					 			  #
# Ultima modificacion: 14/5/2016 				  #
#								  #
###################################################################
.data
	init:		.asciiz "Por favor, escriba el nombre del archivo\n>> "
	menu:		.asciiz "### MENU ### \n// 1 - REPRODUCIR\n// 2 - TRANSPORTAR\n// 3 - CAMBIAR TEMPO\n// 0 - SALIR\n>> "
	msjtrans:	.asciiz "Inserte numero de tonos a transportar\n>> "
	msjtempo:	.asciiz "Inserte nuevo tempo\n>> "
	error:		.asciiz "Error. Opcion no valida. Intende de nuevo.\n"
	exit:		.asciiz "Saliendo del programa.\n"
	file_errormsj:	.asciiz "Error al abrir el archivo.\n"
	read_errormsj: 	.asciiz "Error al leer el archivo.\n"
	saltos:		.word salir, repr, transp, mtempo		# Manejo del menu con arreglo
	valores:	.word 9, 11, 0, 2, 4, 5, 7, 9			# Grados MIDI desde octava -1
	tempo:		.word 480					# Default 4 * 120
	.align 2
	input:		.space 32 					# Espacio para el nombre del archivo
	file: 		.space 32
	buffer:		.space 512					# Espacio para leer archivo
	melodia:	.space 512					# Espacio para guardar la melodia	
	
.text
.globl main
main:	li $v0, 4
	la $a0, init
	syscall

#####################################
	# Lectura del archivo #
#####################################

	# Pedimos nombre del archivo al usuario
	li $v0, 8
	la $a0, input
	la $a1, 64
	syscall
	
	# Eliminar el \n al final del string
	li $t0, 0
	la $t1, input
ciclo:	lb $t2, 0($t1)
	
	beq $t2, 10, abrir
	sb $t2, file($t0)
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	b ciclo
	
	# Abrir el archivo
abrir:	li $v0, 13
	la $a0, file
	li $a1, 0 			# Lectura
	li $a2, 0 			# Ignorar modo
	syscall
	move $s0, $v0 			# Mover file descriptor
	bltz $s0, file_error
	
	# Lectura
	li $v0, 14
	move $a0, $s0 
	la $a1, buffer
	li $a2, 512 			# Max caracteres a leer
	syscall
	
	bltz $s0, read_error
	
	# Cerrar el archivo
	li   $v0, 16      		
  	move $a0, $s0     
 	syscall            
	
#####################################
	# Procesamiento del archivo #
#####################################
#a0 caracter/numero ya convertido
#t0 direccion del buffer con el contenido del archivo
#t1 byte leido actual
#t2 10 para la conversion
#t3 contador para moverme en el espacio reservado final
#t4 caracter transformado a nota midi
	
	li $a0, 0
	la $t0, buffer
	li $t2, 10
	li $t3, 0
	
seguir:	lb $t1, 0($t0)			# Cargo el primer byte del buffer
	
	beq $t1, 10, slinea		# Si hay salto de linea (10) o espacio (32) guardo en una palabra lo que tengo
	beq $t1, 32, slinea	
	beq $t1, 0, mloop		# Si es nulo, llegue al final del archivo
	bge $t1, 0x61, caract  		# Si es una nota (a-g) la transformo
	
	mul $a0, $a0, $t2		# Conversion ascii to int
	subi $t1, $t1, 0x30
	add $a0, $a0, $t1
	addi $t0, $t0, 1
	b seguir
	
slinea:	addi $t0, $t0, 1       		# Si encontramos un salto de linea, guardamos todo en una palabra
	sw $a0, melodia($t3)
	addi $t3, $t3, 4
	li $a0, 0	
	b seguir			# Continuamos con la siguiente linea

caract: addi $t0, $t0, 1
	subi $t1, $t1, 0x61		# Resto 0x61 para tenerlo en base a 0, 1...
	sll $t1, $t1, 2		
	lw $t4, valores($t1)		# Cargo el valor correspondiente a la nota
	sw $t4, melodia($t3)		# Guardo el valor en memoria
	addi $t3, $t3, 4
	b seguir
	
#########################################
	# Menu principal #
#########################################
mloop:	li $v0, 4
	la $a0, menu
	syscall
	
	li $v0, 5
	syscall
	move $a0, $v0
	
	bge $a0, 4, merror
	
	sll $a0, $a0, 2
	lw $t0, saltos($a0)
	jr $t0

#########################################
	# Reproducir melodia #
#########################################
	
repr:	li $v0, 33			
	li $t0, 0 			# Desplazamiento para leer el buffer
	lw $t1, melodia($t0)		# Cargar numero de notas
	li $t2, 0			# Contador para numero de notas
	li $a3, 127			# Volumen
	addi $t0, $t0, 4
	lw $a2, melodia($t0)		# Cargar Instrumento
	
rloop:	beq $t1, $t2, fin		# Si leimos todas las notas, terminamos
	addi $t0, $t0, 4
	lw $a0, melodia($t0)		# Cargar el grado
	
	addi $t0, $t0, 4	
	lw $s1, melodia($t0)		# Cargar la octava
	
	addi $s1, $s1, 1		# Calculo de la altura
	mul $s1, $s1, 12
	add $a0, $a0, $s1
	
	add $a0, $a0, $s7		# Suma el valor si hubo transporte de tonos
	
	addi $t0, $t0, 4	
	lw $a1, melodia($t0)		# Cargar valor de duracion
	lw $s2, tempo
	mul $a1, $a1, 1000 		# Calculo de la duracion
	div $a1, $a1, $s2	

	
	syscall
	addi $t2, $t2, 1		# Actualizar contador de notas
	j rloop
	
fin:	li $s7, 0			# Reiniciar si hubo un transporte de notas
	j mloop

#########################################
	# Transportar melodia #
#########################################
transp:	li $v0, 4
	la $a0, msjtrans
	syscall
	
	li $v0, 5
	syscall
	
	move $s7, $v0			# Guardamos valor a transportar en registro
		
	j mloop
	
#########################################
	# Modificar Tempo #
#########################################
mtempo:	li $v0, 4
	la $a0, msjtempo
	syscall
	
	li $v0, 5
	syscall

	sll $v0, $v0, 2			# Modificar tempo
	sw $v0, tempo
	
	j mloop

#########################################
	# Salir del programa #
#########################################
salir:	li $v0, 4
	la $a0, exit
	syscall
	
	li $v0, 10
	syscall

#########################################
	# Mensajes de error #
#########################################

# Error al abrir
file_error:
	li $v0, 4
	la $a0, file_errormsj
	syscall
	j salir

# Error de lectura	
read_error: 
	li $v0, 4
	la $a0, read_errormsj
	syscall
	j salir

# Error de opcion menu
merror:	li $v0, 4
	la $a0, error
	syscall
	j mloop
