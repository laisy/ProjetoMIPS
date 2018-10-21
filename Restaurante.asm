.data
	#Menu Principal:
	titulo: .asciiz "Escolha uma op��o \n 1 - Clientes \n 2 - Pratos \n 3 - Funcionarios \n 4 - Mesa \n 5 - Pedidos \n"
	error: .asciiz "Dados inv�lidos!!!"
	
.text
Main:
#----------------------------------Menu Principal---------------------------------------------------------------------------------------------------
	la $t0, titulo 		#Carrega o menu
	jal escolha		#Fun��o para mostrar o menu e escolher a op��o
	addi $t1, $t1, 0	#Par�metro pra saber se a op��o escolhido � maior que 0
	addi $t2, $zero, 5	#Par�metro pra saber se a op��o escolhida � menor ou igual a 5
	jal verificacao		#Fun��o que verifica se a op��o escolhida � um n�mero entre 1 e 5 
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	j exit
	
#------------------------------Fun��o de sele��od e menu escolha(int escolhido) return escolhido---------------------------------------------------	
escolha: 	addi $v0, $zero, 51
		la $a0, ($t0)
	 	syscall
	 	jr $ra
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-----------------------------------------------Printf----------------------------------------------------------------------------------------------
printf:	add $v0, $zero, $t0
	syscall
	jr $ra
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#--------------------------------------Verifica se a op��o selecionada � inv�lida------------------------------------------------------------------------
verificacao:  	bgt $t1, $a1, dadosInvalidos
		bgt $a0, $t2, dadosInvalidos
		jr $ra
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#----------------------------------Erro: Op��o selecionada � inv�lida!!!----------------------------------------------------------------------------
dadosInvalidos: 	addi $a1, $zero, 2
			la $a0, error
			addi $t0, $zero, 55
			sub $t2, $t2, $t2
			jal printf
			j Main
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	
exit: nop
	
