.globl main

.data

	msg_digite_opcao:       .string "Digite a opção desejada: "
	msg_inserir_numero:  	 	.string "1 - Inserir na lista\n"
	msg_remover_por_indice: .string "2 - Remover usando indice\n"
	msg_remover_por_valor:  .string "3 - Remover usando valor\n"
	msg_listar_valores:     .string "4 - Listar valores\n"
	msg_lista_vazia_erro:   .string "\nLista vazia"
	msg_finalizar:					.string "5 - Finalizar programa\n"
	msg_sucesso: 						.string "Operação realizada com sucesso\n"
	msg_valor_posicao: 			.string "\nO valor digitado está na posição "   						
	msg_erro_opcao: 				.string "Opção inválida, digite uma opção válida\n"
	msg_digite_valor: 			.string "Digite o valor: "
	msg_erro_valor:					.string "Valor não existe\n"
	msg_digite_indice: 			.string "Digite o indice: "
	msg_erro_indice: 		   	.string "Indice não existe\n"
	msg_remove_sucesso: 		.string "Valor removido: "
	msg_remove_sucesso2: 		.string "Indice removido: "
	msg_valores_lista:			.string "\n\nValores na lista: "
	msg_total_adicionados:	.string "Total adicionados: "
	msg_total_removidos:	  .string "Total removidodos: "
	new_line:								.string "\n\n"
	space:									.string " "
	
	
	lista_qnt: .word 0 # quantidade  atual de valores na lista
	
	# usado quando encerrar o programa
	qnt_total_adicionados: .word 0
	qnt_total_removidos:   .word 0
	

.text

	main:
	
		jal quebra_linha
				
		# Usado para comparar a opção digitada no Menu
		addi t1, zero, 1
		addi t2, zero, 2
		addi t3, zero, 3
		addi t4, zero, 4
		addi t5, zero, 5
		
		# Menu
	
		# opção 1
		la a0, msg_inserir_numero
		li a7, 4
		ecall
	
		# opção 2
		la a0, msg_remover_por_indice
		li a7, 4
		ecall
	
		# opção 3
		la a0, msg_remover_por_valor
		li a7, 4
		ecall
	
		# opção 4	
		la a0, msg_listar_valores
		li a7, 4
		ecall
	
		# opção 5
		la a0, msg_finalizar
		li a7, 4
		ecall
	
		# messagem digita opcao
		la a0, msg_digite_opcao
		li a7, 4 								 # System call para imprimir na tela
		ecall
	
		li a7, 5								 # System call para ler do teclado
		ecall
		add a1, zero, a0 
	
		
		# Desvia para a opção selecionada
		beq a1, t1, insere
		beq a1, t2, remove_por_indice
		beq a1, t3, remove_por_valor
		beq a1, t4, lista_elementos
		beq a1, t5, encerra
		j menu_erro		# se chegar aqui, quer dizer que nenhuma opção válida foi digitada
	
		
	quebra_linha:   # sempre que precisar pular uma linha, chamar essa função e sempre chamar usnado jal
		
		la a0, new_line
		li a7, 4
		ecall		
		ret
	
				
#======================================================================================================================
	
	insere:    
		
		# FALTA FAZER:
		# MOSTRAR EM QUAL POSIÇÃO O VALOR FOI INSERIDO ( falta consertar pra quando ordenar )
		
		# menssagem para inserir o valor
		la a0, msg_digite_valor
		li a7, 4
		ecall
	
		# lê do teclado o valor a ser adicionado
		li a7, 5		
		ecall
		
		# usado ao finalizar o programa, para mostrar a quantidade total de valores adicionados
		la	 a1, qnt_total_adicionados  # carrega endereço
		lw	 t0, (a1) 									# obtém valor
		addi t2, t0, 1                  # incrementa 1
		sw   t2, (a1)										# salva o novo valor
		
		la	a1, lista_qnt	 # carrega endereço      
		lw	s1, (a1)  		 # obtém valor
		
		add  s3, zero, sp  # endereço a. usado para refazer os apontamentos quando mudar os valores
		addi sp, sp, -4    # aloca valor
		add  s4, zero, sp  # endereço b. usado para refazer os apontamentos quando mudar os valores
		add  t5, zero, s4  # salva o endereço anterior pra ajudar no apontamento do começo da lista
		
		bgt  s1, zero, segue # só vai guardar o endereço do começo da lista na 1ª vez
		add  s0, zero, sp    # salva endereço do começo da lista ( não mudar JAMAIS o valor em s0 )
										
		segue:
			sw	 a0, (sp)		  # valor digitado na posição n
			add  t2, zero, sp # carrega o edereço do valor digitado
			addi sp, sp, -4	  # aloca endereço	
			addi t2, t2, -8   # endereço da próxima posição
			sw   t2, (sp)     # salva o endereço do valor digitado
			
			addi s1, s1, 1    # incrementa qnt valores na lista
			sw   s1, (a1)     # salva			
			
			# refaz os apontamentos
			add  sp, zero, s3  # 
			sw   s4, (sp)
			add  sp, zero, s4
			addi sp, sp, -4

			add  s5, zero, zero # usado para mostrar em qual posição o valor foi inserido
		
		 	addi t2, zero, 2 	# if lista_size >= 1 ? j main : continue
		 	blt  s1, t2, mostra_posicao  # 2 porque a comparação tem que ser qnt_valor_lista + 1							

		ordena:
			
			# faz os apontamentos
			addi t0, zero, 1    # controla o loop_ordena
			add  sp, zero, s0   # começo da lista
			
			loop_ordena:   
			
				# valor A
				bgt  t0, s1, exit_loop_ordena 	# para o loop quando chegar ao final da lista 
				lw   t1, (sp)      # carrega valor da posição n
				addi sp, sp, -4    # aponta para o endereço
				lw   t2, (sp)      # carrega endereço do próximo valor
				add  sp, zero, t2  # proximo valor de acordo com o endereço ( chega no valor B)
			
				# Valor B
				lw   t3, (sp)    # carrega valor
				addi sp, sp, -4  # aponta para o endereço
				lw   t4, (sp)    # carrega endereço do próximo valor				
								
				beq t4, zero, volta # se o endereço for 0 é (null) = ultimo valor
				j continua
				
				volta:
					addi sp, sp, 8			
					
					mostra_posicao:
						
						la a0, msg_valor_posicao
						li a7, 4
						ecall 
	
						add a0, zero, s5   
						li a7, 1	         # mostra valor								
						ecall

					j main
				
				continua:
					blt  t3, t1, troca  # se b < a, refaz apontamento
					add  sp, zero, t2   # proximo valor de acordo com o endereço
					add  t5, zero, t2   # guarda o valor do último endereço comparado ( usado quando for fazer a troca )
					addi t0, t0, 1      # incrementa loop
					addi s5, s5, 1      # incrementa posicao valor adicionado 
		
			j loop_ordena
			
			troca:
							
				addi sp, sp, 4   # aponta valor
				add sp, zero, t5 # endereço A
				lw  s3, (sp)     # savla endereço A aux
				sw  t3, (sp)     # reencreve valor A como o endereço de B
				add sp, zero, t2 # endereço B
				sw  s3, (sp)     # reescreve valor B com o endereço de A
				
				addi t5, t5, 8    # ajusta o que foi mudado com a troca
				add  sp, zero, t5 # endereço A. volta para o valor trocado para continuar comprando de onde o loop parou

				j loop_ordena     # tem que voltar pro loop pra testar com os outros valores
				
			exit_loop_ordena:			
				addi sp, sp, -4
				j mostra_posicao
				

#======================================================================================================================

		remove_por_indice:
			
			# menssagem para inserir o indice
			la a0, msg_digite_indice
			li a7, 4
			ecall
	
			# pega o valor digitado
			li a7, 5
			ecall
			add t3, zero, a0
		
			la	a1, lista_qnt	 # carrega endereço      
			lw	s1, (a1)  		 # obtém valor
						
			beq s1, zero, lista_vazia_erro      # se não existir nenhum elemento para ser deletado
			bgt t3, s1,   valor_nao_econtrado2	# se indice for > qnt_tamanaho_lista erro
			blt t3, zero, valor_nao_econtrado2  # se indice for < 0 erro
		
			# se não, deleta valor
			addi s3, zero, 0   # indice 
			addi t0, zero, 0   # controla o loop_ordena
			add  sp, zero, s0  # começo da lista	
			
			loop_deleta_por_indice:
				
				beq  s1, t0, exit_loop_deleta_por_indice # percorre a lista até o final
				
				lw  t1, (sp)              # carrega valor da posição n
				add s5, zero, t1          # usando para mostrar qual foi o valor excluido
				beq t3, s3, deleta_valor2 # if indice_digitado == indice_posição_n
				j segue_procurando_valor2
				
				
				deleta_valor2:
					addi s9, zero, 1  # flag
					
					add  t6, zero, sp # endereço do valor removido
					sw   zero, (sp)   # seta o valor 0
					addi sp, sp, -4   # endereço que o valor a ser exlucido aponta
					lw   t4, (sp)     # carrega endereço
					sw   zero, (sp)   # seta o endereço 0
					
					add  sp, zero, t5  # vai para o endereço anterior ao valor excluido
					sw   t4, (sp)      # salva o endreço no valor anterior ou valor excluido
					
					
					# menssagem valor excluido
				  la a0, msg_remove_sucesso
				  li a7, 4
		  		ecall 
		  
		  		# mostra o valor do indice deletado
		  		add a0, zero, s5
		  		li  a7, 1
		  		ecall
		  		
		  	  # atualiza a quantidade de valores na lista
  				la   a0, lista_qnt	# endereço dos valores na lista		
					lw   t0, (a0)       # carrega o valor que é a quantidade de valores na lista
					add  t1, zero, t0   # salva o valor antes de mudar poruqe vai ser preciso no final
		  		addi t0, t0, -1     # decrementa 1
		  		sw   t0, (a0)       # salva o novo valor
		  
		 			# atualiza a quantidade total de valores deletados
		  		la   a0, qnt_total_removidos
		  		lw   t0, (a0)
		  		addi t0, t0, 1
					sw   t0, (a0)     # salva o novo valor
		  		
		  		j main
		  		
				
				segue_procurando_valor2:
					addi sp, sp, -4    # aponta para o endereço
					lw   t2, (sp)      # carrega endereço do próximo valor
					add  t5, zero, sp  # guarda o endereço anterior, para ser ligado caso o próximo valor seja deletado
					add  sp, zero, t2  # proximo valor de acordo com o endereço 					
				
					addi t0, t0, 1     # incrementa loop
					addi s3, s3, 1     # incrementa indice
				
			j loop_deleta_por_indice
				
			exit_loop_deleta_por_indice:
			
				beq s9, zero, valor_nao_econtrado2
				j segue_final2
				
				valor_nao_econtrado2:
					la a0, msg_erro_indice
					li a7, 4
					ecall
			
				segue_final2:
					addi sp, sp, 4    # garante que vai está na posição correta ao sair do loop
					j main																												
   
				
#======================================================================================================================

		remove_por_valor:  				
			
			# menssagem para inserir o valor
			la a0, msg_digite_valor
			li a7, 4
			ecall
	
			# pega o valor digitado
			li a7, 5
			ecall
			add t3, zero, a0
			
			la	a1, lista_qnt	 # carrega endereço      
			lw	s1, (a1)  		 # obtém valor
						
			beq s1, zero, lista_vazia_erro   # se não existir nenhum elemento para ser deletado
			add s9, zero, zero   # flag para dizer se o valor foi encontrado ou não
			
			# se não, deleta valor
			addi s3, zero, 0   # indice 
			addi t0, zero, 0   # controla o loop_ordena
			add  sp, zero, s0  # começo da lista
			
			loop_deleta_por_valor:
				
				beq  s1, t0, exit_loop_deleta_por_valor # percorre a lista até o final
				
				lw  t1, (sp)             # carrega valor da posição n
				beq t3, t1, deleta_valor # if valor_digitado == valor_posição_n
				j segue_procurando_valor
				
				deleta_valor:
					addi s9, zero, 1  # flag
					
					add  t6, zero, sp # endereço do valor removido
					sw   zero, (sp)   # seta o valor 0
					addi sp, sp, -4   # endereço que o valor a ser exlucido aponta
					lw   t4, (sp)     # carrega endereço
					sw   zero, (sp)   # seta o endereço 0
					
					add  sp, zero, t5  # vai para o endereço anterior ao valor excluido
					sw   t4, (sp)      # salva o endreço no valor anterior ou valor excluido
					
					
					# menssagem indice do valor excluido
				  la a0, msg_remove_sucesso2
				  li a7, 4
		  		ecall 
		  
		  		# mostra o indice deletado
		  		add a0, zero, s3
		  		li  a7, 1
		  		ecall
		  		
		  	  # atualiza a quantidade de valores na lista
  				la   a0, lista_qnt	# endereço dos valores na lista		
					lw   t0, (a0)       # carrega o valor que é a quantidade de valores na lista
					add  t1, zero, t0   # salva o valor antes de mudar poruqe vai ser preciso no final
		  		addi t0, t0, -1     # decrementa 1
		  		sw   t0, (a0)       # salva o novo valor
		  
		 			# atualiza a quantidade total de valores deletados
		  		la   a0, qnt_total_removidos
		  		lw   t0, (a0)
		  		addi t0, t0, 1
					sw   t0, (a0)     # salva o novo valor
		  		
		  		j main
		  		
				
				segue_procurando_valor:
					addi sp, sp, -4    # aponta para o endereço
					lw   t2, (sp)      # carrega endereço do próximo valor
					add  t5, zero, sp  # guarda o endereço anterior, para ser ligado caso o próximo valor seja deletado
					add  sp, zero, t2  # proximo valor de acordo com o endereço 					
				
					addi t0, t0, 1     # incrementa loop
					addi s3, s3, 1     # incrementa indice
				
			j loop_deleta_por_valor
				
			exit_loop_deleta_por_valor:
			
				beq s9, zero, valor_nao_econtrado
				j segue_final
				
				valor_nao_econtrado:
					la a0, msg_erro_valor
					li a7, 4
					ecall
			
				segue_final:
					addi sp, sp, 4    # garante que vai está na posição correta ao sair do loop
					j main
			
#======================================================================================================================

		lista_elementos:    
			
			# menssagem de listar os valores
			la a0, msg_valores_lista
			li a7, 4
			ecall 
			
			la	a1, lista_qnt	 # carrega endereço      
			lw	s1, (a1)  		 # obtém valor
	
			beq s1, zero, lista_vazia_erro   # se não existir nenhum elemento para ser listado
			
			
			# se não lista valores
			addi t0, zero, 0   # controla o loop_ordena
			add  sp, zero, s0  # começo da lista
			
			loop_lista_valores:
				
				beq  s1, t0, exit_loop_lista_valores # percorre a lista até o final
				
				lw  a0, (sp)  # carrega valor da posição n
				li  a7, 1     # faz a chamada para mostrar um valor inteiro
				ecall    	    # mostra o valor
				
				# coloca um espaço em branco entre os valores
		  	la a0, space
		  	li a7, 4
		  	ecall 
				
				addi sp, sp, -4    # aponta para o endereço
				lw   t1, (sp)      # carrega endereço do próximo valor
				add  sp, zero, t1  # proximo valor de acordo com o endereço 
				
				addi t0, t0, 1     # incrementa loop
				
			j loop_lista_valores
				
			exit_loop_lista_valores:
				addi sp, sp, 4    # garente que vai está na posição correta ao sair do loop
				j main
			
#======================================================================================================================		
			
	lista_vazia_erro:
		la a0, msg_lista_vazia_erro
		li a7, 4
		ecall
		j main

#======================================================================================================================

	menu_erro:
		la a0, msg_erro_opcao
		li a7, 4 		# System call para imprimir string na tela
		ecall
		j main
		
#======================================================================================================================
	
	encerra:
		jal quebra_linha
		
		# Mostra total de valores adicionados
		la a0, msg_total_adicionados
		li a7, 4
		ecall 
	
		la a2, qnt_total_adicionados  # carrega endereço 		
		lw a0, 0(a2)                  # carrega a quantidade atual
		li a7, 1					            # mostra valor
		ecall
	
		jal quebra_linha
	
		# Mostra total de valores removidos
		la a0, msg_total_removidos 	
		li a7, 4
		ecall 
	
		la a2, qnt_total_removidos  # carrega endereço 		
		lw a0, 0(a2)                # carrega a quantidade atual
		li a7, 1					          # mostra valor
		ecall
		
		jal quebra_linha
