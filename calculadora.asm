# Feito na IDE MARS v4.5

.data
	s_plus: .asciiz " + " 		# .asciiz coloca null no final para indicar que acabou a cadei de chaves
	s_menus: .asciiz  " - "		# sinal de menos
	s_division: .asciiz " / "	# sinal de divizão
	s_multiplication: .asciiz " x " # sinal de nultplicação
	s_equals: .asciiz " = "		# sinal de igual
	pular_linha: .asciiz "\n"	# pula linha
	
	menu_text: .asciiz "Selecione oque deseja (1)Mais (2)Menos (3)Div (4)Mult - (0)Encerrar: "
	pedido: .asciiz "Escolha um valor real: "
.text
	j menu # j = jump, salta para o menu
	
menu:
	la $a0, pular_linha
	li $v0, 4 # printa uma string
	syscall
	
	la $a0, menu_text
	li $v0, 4 # printa uma string
	syscall
	
	li $v0, 5 # lê um inteiro
	syscall
	move $t0, $v0
	
	li $t1, 1 # carrega o valor 1 no registrador t1
	beq $t1, $t0, plus # caso o valor que foi lido no input seja 1, vai saltar pra plus
	li $t1 2 # carrega o valor 2 no registrador t1
	beq $t1, $t0, menus # caso o valor que foi lido no input seja 2, vai saltar pra menus
	li $t1 3 # carrega o valor 3 no registrador t1
	beq $t1, $t0, division # caso o valor que foi lido no input seja 3, vai saltar pra division
	li $t1 4 # carrega o valor 4 no registrador t1
	beq $t1, $t0, multiplication # caso o valor que foi lido no input seja 4, vai saltar pra multiplication 
	li $t1, 0 # carrega o valor 0 no registrador t1
	beq $t1, $t0, end  # caso o valor que foi lido no input seja 0, vai saltar pra end
	
leitor:
	# valores double utilizam 2 registradores por conta da precisão
	
	# f0 f1 ficaram com a leitura
	
	# f4 fica um dos operandos
	# f2 f3 fica outro dos operandos
	
	# f6 f7 ficam salvo nossos resultados

	la $a0, pedido
	li $v0, 4 # printa uma string
	syscall
	
	li $v0, 7 # lê um double
	syscall
	mov.d $f4, $f0
	
	la $a0, pedido
	li $v0, 4 # printa uma string
	syscall
	
	li $v0, 7 # lê um double
	syscall
	mov.d $f2, $f0
	jr $ra # salta pra label que está com o endereço salvo no registrador ra

impressor:
	li $v0, 3 # imprime um double contido em f12
	mov.d $f12, $f2
	syscall
	
	li $v0, 4 # carrega uma string ja armazenada no a0 anteriormente nas labels
	syscall
	
	li $v0, 3 # imprime um operando, passando ele de f4 para f12
	mov.d $f12, $f4
	syscall
	
	la $a0, s_equals #imprime o sinal de igual
	li $v0, 4 # imprime uma string
	syscall
	
	li $v0, 3 # imprime nosso resultado double, passando ele de f6 para f12
	mov.d $f12, $f6
	syscall
	jr $ra
	
plus:
	jal leitor # salta pra label leitor e guarda o endereço da label soma no registrador ra
	add.d $f6, $f4, $f2 # nao sera perdido nenhum valor, esta salvo como valor fisico no processador, não existel tal abstração
	# guarda no registrador f6 o valor da soma dos registradores f4 e f2
	mov.d $f12, $f6 # f12 f13 ficaram com a impressão
	# move o resultado que está em f6 para o f12 (o registrador que a syscall printa o valor para doubles)
	la $a0, s_plus # chama o sinal de mais
	jal impressor # vai ir e voltar na label impressor
	j menu # apos o termino da operação retorna ao menu ate que seja digitado 0
	
menus:
	jal leitor # salta pra label leitor e guarda o endereço da label soma no registrador ra
	sub.d $f6, $f4, $f2 # nao sera perdido nenhum valor, esta salvo como valor fisico no processador, não existel tal abstração
	# guarda no registrador f6 o valor da subtração dos registradores f4 e f2	
	mov.d $f12, $f6 # f12 f13 ficaram com a impressão
	# move o resultado que está em f6 para o f12 (o registrador que a syscall printa o valor para doubles)
	la $a0, s_menus # chama o sinal de menos
	jal impressor # vai ir e voltar na label impressor	
	j menu # apos o termino da operação retorna ao menu ate que seja digitado 0
	
division:
	jal leitor # salta pra label leitor e guarda o endereço da label soma no registrador ra
	div.d $f6, $f4, $f2 # nao sera perdido nenhum valor, esta salvo como valor fisico no processador, não existel tal abstração
	# guarda no registrador f6 o valor da divisão dos registradores f4 e f2	
	mov.d $f12, $f6 # f12 f13 ficaram com a impressão
	# move o resultado que está em f6 para o f12 (o registrador que a syscall printa o valor para doubles)
	la $a0, s_division # chama o sinal de divisão
	jal impressor # vai ir e voltar na label impressor
	j menu # apos o termino da operação retorna ao menu ate que seja digitado 0
	
multiplication:
	jal leitor # salta pra label leitor e guarda o endereço da label soma no registrador ra
	mul.d $f6, $f4, $f2 # nao sera perdido nenhum valor, esta salvo como valor fisico no processador, não existel tal abstração
	# guarda no registrador f6 o valor da multiplicação dos registradores f4 e f2	
	mov.d $f12, $f6 # f12 f13 ficaram com a impressão
	# move o resultado que está em f6 para o f12 (o registrador que a syscall printa o valor para doubles)
	la $a0, s_multiplication # chama o sinal de multiplicação
	jal impressor # vai ir e voltar na label impressor
	j menu # apos o termino da operação retorna ao menu ate que seja digitado 0
	
end:
	li $v0, 10 # carrega o valor syscall que encerra a execução
	syscall
	