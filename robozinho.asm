.data
n1: .asciiz "\n"

.text
li $s0, 0x000000ff	#azul
li $s1, 0x00ff6600	#laranja 	
li $s2, 0x00ff33ff	#rosa
li $s3, 0x00ffffff 	#branco
li $s4, 0	#contador
li $s6, 0	#linhas
li $s7, 0	#colunas
li $t6, 0 

move $s5, $gp
mapa:
	move $gp,$s5
	cima:
		sw $s0, 0($gp)
		addi $gp,$gp,4
		addi $s7,$s7,1
		bne $s7,16,cima	 
	
	li $s7,0
	esquerda:
		addi $s6,$s6,1
		sw $s0,0($gp)
		addi $gp,$gp,64
		bne $s6,15,esquerda
	
	addi $gp,$gp,-60
	baixo:
		addi $s7,$s7,1
		sw $s0,0($gp)
		addi $gp,$gp,4
		bne $s7,15,baixo
	
	addi $gp,$gp,-4
	direita:
		addi $s6,$s6,-1
		addi $gp,$gp,-64
		sw $s0,0($gp)
		bne $s6,0,direita
	
	addi $gp,$gp,448
	li $v0,42
	li $a1,12
	syscall
	add $a0,$a0,1
	move $t0,$a0
	addi $t1, $t0, 1
	
	divisoria:
		addi $gp,$gp,-4
		addi $s7,$s7,-1
		beq $s7,$t0,divisoria
		beq $s7,$t1,divisoria
		sw $s0,0($gp)
		bne $s7,0,divisoria

move $gp,$s5
moveis:
	lw $t1,0($gp)
	addi $gp,$gp,4
	beq $t1,$s0,moveis
	
	li $v0,42
	li $a1,30
	syscall
	add $a0,$a0,1
	move $t0,$a0
	bne $t0,30,moveis
	
	sw $s1,-4($gp)
	ble $gp,0x10008400,moveis
	
move $gp,$s5

contar:
	lw $t1,0($gp)
	addi $gp,$gp,4
	beq $t1,$s0,contar
	beq $t1,$s1,contar
	addi $s4,$s4,1
	ble $gp,0x10008400,contar
	
addi $s4,$s4,-2

robo:
	move $gp,$s5
	li $v0, 42
	li $a1, 255
	syscall

	move $t0, $a0
	mul $t0, $t0, 4
	add $gp, $gp, $t0
	
	lw $t1,0($gp)
	
	bge $gp,0x10008400,robo
	beq $t1,$s0,robo
	beq $t1,$s1,robo
	sw $s2,0($gp)
	
mover:
	ble $s4,0,fim
	li $v0,42
	li $a1,8
	syscall
	add $a0,$a0,1
	move $t2,$a0
	
	beq $t2,1,norte
	beq $t2,2,nordeste
	beq $t2,3,leste
	beq $t2,4,sudeste
	beq $t2,5,sul
	beq $t2,6,sudoeste
	beq $t2,7,oeste
	beq $t2,8,noroeste
	
	norte:
		move $t3,$gp
		addi $t3,$t3,-64
		lw $t1,0($t3)
		beq $t1,$s0,mover
		beq $t1,$s1,mover
		move $gp,$t3
		beq $t1,$s3,printaN
		addi $s4,$s4,-1
		printaN:
		sw $s2,0($gp)
		sw $s3,64($gp)
		j norte
		
	nordeste:
		move $t3,$gp
		addi $t3,$t3,-60
		lw $t1,0($t3)
		beq $t1,$s0,mover
		beq $t1,$s1,mover
		move $gp,$t3
		beq $t1,$s3,printaNE
		addi $s4,$s4,-1
		printaNE:
		sw $s2,0($gp)
		sw $s3,60($gp)
		j nordeste
		
	leste:
		move $t3,$gp
		addi $t3,$t3,4
		lw $t1,0($t3)
		beq $t1,$s0,mover
		beq $t1,$s1,mover
		move $gp,$t3
		beq $t1,$s3,printaE
		addi $s4,$s4,-1
		printaE:
		sw $s2,0($gp)
		sw $s3,-4($gp)
		j leste
		
	sudeste:
		move $t3,$gp
		addi $t3,$t3,68
		lw $t1,0($t3)
		beq $t1,$s0,mover
		beq $t1,$s1,mover
		move $gp,$t3
		beq $t1,$s3,printaSE
		addi $s4,$s4,-1
		printaSE:
		sw $s2,0($gp)
		sw $s3,-68($gp)
		j sudeste
		
	sul:
		move $t3,$gp
		addi $t3,$t3,64
		lw $t1,0($t3)
		beq $t1,$s0,mover
		beq $t1,$s1,mover
		move $gp,$t3
		beq $t1,$s3,printaS
		addi $s4,$s4,-1
		printaS:
		sw $s2,0($gp)
		sw $s3,-64($gp)
		j sul
		
	sudoeste:
		move $t3,$gp
		addi $t3,$t3,60
		lw $t1,0($t3)
		beq $t1,$s0,mover
		beq $t1,$s1,mover
		move $gp,$t3
		beq $t1,$s3,printaSW
		addi $s4,$s4,-1
		printaSW:
		sw $s2,0($gp)
		sw $s3,-60($gp)
		j sudoeste
		
	oeste:
		move $t3,$gp
		addi $t3,$t3,-4
		lw $t1,0($t3)
		beq $t1,$s0,mover
		beq $t1,$s1,mover
		move $gp,$t3
		beq $t1,$s3,printaW
		addi $s4,$s4,-1
		printaW:
		sw $s2,0($gp)
		sw $s3,4($gp)
		j oeste
		
	noroeste:
		move $t3,$gp
		addi $t3,$t3,-68
		lw $t1,0($t3)
		beq $t1,$s0,mover
		beq $t1,$s1,mover
		move $gp,$t3
		beq $t1,$s3,printaNW
		addi $s4,$s4,-1
		printaNW:
		sw $s2,0($gp)
		sw $s3,68($gp)
		j noroeste

fim:
	move $gp,$s5
	aux:
	li $t7, 0x00000000
	#li $v0,10
	sw $t7,0($gp)
	addi $gp,$gp,4
	ble $gp,0x10008400,aux
	addi $t6, $t6, 1
	li $v0, 1
	move $a0, $t6
	syscall
	li $v0, 4
	la $a0, n1
	syscall 
	j mapa