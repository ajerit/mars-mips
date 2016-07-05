.data
uno:	.word 720
dos:	.word 480
tres: 	.word 1000
.text
main:	lw $t0, uno
	lw $t1, dos
#	div.s $f0, $f1, $f2
#	l.s $f3, tres
#
#	mul.s $f0, $f0, $f3

	mul $t0, $t0, 1000
	div $t0, $t0, $t1