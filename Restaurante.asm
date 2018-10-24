.data
	#Menu Principal:
	titulo: .asciiz "Escolha uma op��o \n 1 - Clientes \n 2 - Pratos \n 3 - Funcionarios \n 4 - Mesa \n 5 - Pedidos \n"
	
	#Label: Exception: DadoInvalido
	error: .asciiz "Dados inv�lidos!!!"
	
	#Label: Exception: NomeGrande
	nomeGrandeErro: .asciiz "Nome muito grande!!"
	
	#SubMenus:
	opcaoCliente: .asciiz "Escolha uma op��o: \n 1 - Cadastrar um novo Cliente \n 2 - Remover um Cliente \n 3 - Atualizar informa��es de um cliente \n 4 - Visualizar informa��es de um cliente \n 5 - Fazer reserva para um cliente \n 6 - Retornar para o Menu Principal"
	opcaoCardapio: .asciiz "Escolha uma op��o: \n 1 - Adicionar novo prato ao card�pio \n 2 - Retirar um prato do card�pio \n 3 - Editar informa��es sobre um prato \n 4 - Vizualizar informa��es sobre um prato \n 5 - Visualizar Ranking de pratos mais vendidos \n 6 - Retornar para o Menu Principal"
	opcaoFuncionario: .asciiz "Escolha uma op��o: \n 1 - Contratar novo funcion�rio \n 2 - Demitir um funcion�rio \n 3 - Atualizar informa��es de um funcion�rio \n 4 - Visualizar informa��es de um funcion�rio \n 5 - Calcular folha de pagamento \n 6 - Retornar para o Menu Principal"
	opcaoMesa: .asciiz "Escolha uma op��o: \n 1 - Adicionar Mesa \n 2 - Retirar Mesa \n 3 - Mudar status da mesa \n 4 - Visualizar informa��es de uma Mesa \n 5 - Confirmar Reserva \n 6 - Limpar uma mesa \n 7 - Retornar para o Menu principal"
	opcaoPedido: .asciiz "Escolha uma op��o: \n 1 - Registrar um pedido \n 2 - Apagar(Cancelar) um pedido \n 3 - Refazer um pedido \n 4 - Visualizar um pedido \n 5 - Gerar lista de pedidos em determinado per�odo de tempo \n 6 - Calcular Lucro dos pedidos em determinado per�odo de tempo \n 7 - Completar pedido \n 8 - Retornar para o Menu Principal"
	#fim dos subMenus.
	
	#Parametros (labels de pedido):
	#Prato (Cadastro)
	digiteNomePrato: .asciiz "Digite o nome do Prato: "
	digitePrecoPrato: .asciiz "Digite o pre�o do Prato: "  
	
	#Parametros (Labels de armazenamento)
	#Prato (Cadastro)
	nomePrato: .space 20
	
	
.text
Main:
#----------------------------------Menu Principal---------------------------------------------------------------------------------------------------
	la $t0, titulo 		#Carrega o menu
	jal escolha		#Fun��o para mostrar o menu e escolher a op��o [ escolha(titulo) ]
	addi $t1, $t1, 0	#Par�metro pra saber se a op��o escolhido � maior que 0
	addi $t2, $zero, 5	#Par�metro pra saber se a op��o escolhida � menor ou igual a 5
	jal verificacao		#Fun��o que verifica se a op��o escolhida � um n�mero entre 1 e 5 [ verificacao(0, 5) ]
	j subMenu
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	j exit			#Fim da execu��o
	
#------------------------------Fun��o de sele��od e menu escolha(string texto) return int escolhido---------------------------------------------------	
escolha: 	addi $v0, $zero, 51	#Configurando a syscall para lan�ar tela de escolha
		la $a0, ($t0)		#Carregando o "texto" da tela de escolha
	 	syscall			#Syscall da tela
	 	jr $ra			#Fim da fun��o
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-----------------------------------------------Printf		[void printf(String texto)]	----------------------------------------------------------------------------------------------
printf:	add $v0, $zero, $t0	#Escolha do tipo de tela do printf	
	syscall			#Chamada da tela
	jr $ra			#Fim da fun��o
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#--------------------------------------Verifica se a op��o selecionada � inv�lida [ verificacao(int inicio, int fim, int escolhido) return void]------------------------------------------------------------------------
verificacao:  	bgt $t1, $a1, dadosInvalidos 	#Verifica se o usuario fez um op��o v�lida (N�o enviou nada, apertou cancelar ou mandou um n�o inteiro)
		bgt $a0, $t2, dadosInvalidos	#Verifica se a op��o escolhida est� dentro do n�mero m�ximo de escolhas possivel (a0 > t2? se sim erro)
		bgt $t1, $a0 dadosInvalidos	#Verifica se a op��o escolida est� dentro do n�mero minimo de escolhas possivel (t1 > a0? se sim ent�o erro)
		sub $t2, $t2, $t2		#Colocando t2 para ter o valor 0 novamente
		jr $ra				#Caso tudo esteja ok, o programa continua funcionando
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#------------------------------------Verifica se a string colocada est� correta--------------------------------------------------------------------
verificacaoString:	beq $a1, 0, ok			#Se $a1 for 0, retorna pro fluxo do c�digo
			bgt $a1, 4, nomeGrande		#Se $a1 for 4, lan�a exception NomeGrande
			beq $a1, 2, dadosInvalidos	#Se $a1 for 2, lan�a exception DadosInvalidos
			beq $a1, 3, dadosInvalidos	#Se $a1 for 2, lan�a exception DadosInvalidos
			jr $ra				#Se tudo estiver ok, volta pro fluxo do c�digo

#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#----------------------------------Erro: Op��o selecionada � inv�lida!!!----------------------------------------------------------------------------
dadosInvalidos: 	addi $a1, $zero, 2		#Escolhendo tela de erro
			la $a0, error			#Carregando a label que diz o erro
			addi $t0, $zero, 55		#Escolhendo a tela de mensagens
			sub $t2, $t2, $t2		#Colocando t2 para ter o valor 0 novamente
			jal printf			#Chamando o print [ printf( error) ]
			j Main				#Fim do tratamento da exce��o
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#---------------------------------------------Erro: Nome muito grande!!!--------------------------------------------------------------------------
nomeGrande:		addi $a1, $zero, 2		#Escolhendo tela de erro
			la $a0, nomeGrandeErro		#Carregando a label que diz o erro
			addi $t0, $zero, 55		#Escolhendo a tela de mensagens
			sub $t2, $t2, $t2		#Colocando t2 para ter o valor 0 novamente
			jal printf			#Chamando o print [ printf( error) ]
			j Main				#Fim do tratamento da exce��o
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#--------------------------------Verificar menu escolhido (verifica qual foi a escolha de sub menu) ------------------------------------------------
subMenu:	beq $a0, 1, menuCliente		#Menu do cliente foi escolhido
		beq $a0, 2, menuPrato		#Menu do card�pio foi escolhido
		beq $a0, 3, menuFuncionario	#Menu do funcion�rio foi escolhido
		beq $a0, 4, menuMesa		#Menu das mesas foi escolhido
		beq $a0, 5, menuPedidos		#Menu dos pedidos foi escolhido

#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#--------------------------------------------------Menu Clientes------------------------------------------------------------------------------------
menuCliente: 	la $t0, opcaoCliente	#Carrega o menu do cliente
		jal escolha		#Fun��o para mostrar o menu e escolher a op��es [ escolha(opcaoCliente) ]
		addi $t1, $t1, 0	#Par�metro pra saber se a op��o escolhido � maior que 0
		addi $t2, $zero, 6	#Par�metro pra saber se a op��o escolhida � menor ou igual a 6
		jal verificacao		#Fun��o que verifica se a op��o escolhida � um n�mero entre 1 e 6 [ verificacao(0, 6) ]
		j Main			#Fim das opera��es com o cliente(s)
		
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#--------------------------------------------------Menu Pratos (C�rdapio)------------------------------------------------------------------------------------
menuPrato: 	la $t0, opcaoCardapio	#Carrega o menu dos pratos
		jal escolha		#Fun��o para mostrar o menu e escolher a op��es [ escolha(opcaoCardapio) ]
		addi $t1, $t1, 0	#Par�metro pra saber se a op��o escolhido � maior que 0
		addi $t2, $zero, 6	#Par�metro pra saber se a op��o escolhida � menor ou igual a 6
		jal verificacao		#Fun��o que verifica se a op��o escolhida � um n�mero entre 1 e 6 [ verificacao(0, 6) ]
		add $t3, $t3, $a0	#Adicionando a op��o escolhida para um registrador temporario
		jal acaoPrato		#Chamando a fun��o de verifica��o de escolha
		j Main			#Fim das opera��es com o cardapio
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#--------------------------------------------------Menu Funcionario------------------------------------------------------------------------------------
menuFuncionario: 	la $t0, opcaoFuncionario	#Carrega o menu do funcionario
			jal escolha			#Fun��o para mostrar o menu e escolher a op��es [ escolha(opcaoFuncionario) ]
			addi $t1, $t1, 0		#Par�metro pra saber se a op��o escolhido � maior que 0
			addi $t2, $zero, 6		#Par�metro pra saber se a op��o escolhida � menor ou igual a 6
			jal verificacao			#Fun��o que verifica se a op��o escolhida � um n�mero entre 1 e 6 [ verificacao(0, 6) ]
			j Main				#Fim das opera��es com o funcionario(s)
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#--------------------------------------------------Menu Mesas------------------------------------------------------------------------------------
menuMesa: 	la $t0, opcaoMesa	#Carrega o menu das mesas
		jal escolha		#Fun��o para mostrar o menu e escolher a op��es [ escolha(opcaoMesa) ]
		addi $t1, $t1, 0	#Par�metro pra saber se a op��o escolhido � maior que 0
		addi $t2, $zero, 7	#Par�metro pra saber se a op��o escolhida � menor ou igual a 7
		jal verificacao		#Fun��o que verifica se a op��o escolhida � um n�mero entre 1 e 7 [ verificacao(0, 7) ]
		j Main			#Fim das opera��es com as mesas
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#--------------------------------------------------Menu Pedidos------------------------------------------------------------------------------------
menuPedidos: 	la $t0, opcaoPedido	#Carrega o menu de Pedidos
		jal escolha		#Fun��o para mostrar o menu e escolher as op��es [ escolha(opcaoPedido) ]
		addi $t1, $t1, 0	#Par�metro pra saber se a op��o escolhido � maior que 0
		addi $t2, $zero, 8	#Par�metro pra saber se a op��o escolhida � menor ou igual a 8
		jal verificacao		#Fun��o que verifica se a op��o escolhida � um n�mero entre 1 e 8 [ verificacao(0, 8) ]
		j Main			#Fim das opera��es com os Pedidos
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-------------------------------------------------Chamar janela de string--------------------------------------------------------------------------
chamarJanelaString: 	addi $v0, $zero, 54
			la $a0, ($t2)
			la $a1, ($t3)
			add $a2, $zero, $t4
			syscall
			jr $ra

#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-------------------------------------------------Cadastrar Prato----------------------------------------------------------------------------------
acaoPrato:	beq $t3, 1, funcaoCadastrarPrato	#Chamada da fun��o de cadastro de prato escolhida
		beq $t3, 2, funcaoRemoverPrato		#Chamada da funcao de remo��o de pratos escolhida
		beq $t3, 3, funcaoEditarPrato		#Chamada da fun��o de edi��o de pratos escolhida
		beq $t3, 4, funcaoVisualizarPrato	#Chamada da fun��o de uso/visualiza��o de pratos escolhida
		beq $t3, 5, funcaoRankingPratos        #Chamada da fun��o de ranking de Pratos escolhida
		beq $t3, 6, retornaMain			#Retornar para menu principal escolhido
			
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


#-------------------------------------------------Cadastrar Prato----------------------------------------------------------------------------------
funcaoCadastrarPrato: 	la $t2, digiteNomePrato
			la $t3, nomePrato
			addi $t4, $zero, 10
			jal chamarJanelaString
			jal verificacaoString
			la $a0, digitePrecoPrato
			addi $v0, $zero, 53
			syscall
			bgt $a1, 0, dadosInvalidos
			j exit
			
			
			
			
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-------------------------------------------------Remover Prato----------------------------------------------------------------------------------
funcaoRemoverPrato: 
			
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-------------------------------------------------Editar Prato----------------------------------------------------------------------------------
funcaoEditarPrato: 
			
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-------------------------------------------------Visualizar Prato----------------------------------------------------------------------------------
funcaoVisualizarPrato: 
			
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-------------------------------------------------Ranking Pratos----------------------------------------------------------------------------------
funcaoRankingPratos: 
			
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#-------------------------------------------------Voltar pro main menu----------------------------------------------------------------------------------
retornaMain: 
			
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

ok: jr $ra

exit: nop
	
