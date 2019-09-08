org 0x7E00
jmp 0x0000:main

data:

	banco times 400 db 0
	input times 2 db 0
	;######### menu ############
	cadastrar db '3 - cadastrar conta',13,10,0
	buscar db '4 - Buscar conta:',13,10,0
	editarConta db '5 - Editar conta:',13,10,0
	deletar db '6 - Deletar conta:',13,10,0
	exite db 'qualquer outra coisa - sair',13,10,0
	conta_nao_existe db 'Esta conta nao esta cadastrada',13,10,0
	;########## fim menu #############
	;##############warnings#################
	w_deletar db 'Digite o numero da conta entre 0 e 9',13,10,0 
	w_conta_deletada db 'Conta deletada com sucesso!',13,10,0
	fim_banco db 'Banco Fechado, ate mais!',13,10,0
	endl db ' ',13,10,0
	bankisfull db 'Nao eh possivel adicionar mais uma conta, banco esta cheio!',13,10,0
	digiteNomeUser db 'Digite o nome do usuario:',13,10,0
	string times 30 db 0 ; string para ler entrada de dados
	addSuccessfull db 'Conta adicionada. Numero da conta:',13,10,0
	digiteCpf db 'Digite o cpf (sem tracos):',13,10,0	
	nomeUser db  'Nome: ',0 ; sem o endl intencionalmente
	cpfUser db 'CPF: ',0 ; sem o endl intencionalmente
	contaEncontrada db 'Conta Encontrada',13,10,0
	contaNaoCadastrada db 'Conta Nao Encontrada.',13,10,0
	contaEditada db 'Alteracoes realizadas com sucesso.',13,10,0
	space db '                                               ',13,10,0
	;########################################
	




getchar:
  mov ah, 0x00
  int 16h
  ret


putchar:
	mov ah,0x0e
	int 10h
	ret
	
prints:             ; mov si, string
  .loop:
    lodsb           ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret

clear: ; essa funcao limpa a tela e posiciona o cursor na posicao (0,0)

	mov cx,30
	.for:
		dec cx
		cmp cx,0
		je .fimloop
		mov si,endl
		call prints
		jmp .for
		.fimloop:
	
		mov ah,02h
		mov dh,0
		mov dl,0
		int 10h
	
	ret

check: ; retorna flag no ah caso exista
	  ; bx com o offset

	.for:
		mov si,banco ; si = offset
		add si,bx ; bx = pos no array
		lodsb
		dec si
		cmp al,0
		je .achei ; achei uma posicao disponivel
		add bx,35
		cmp bx,350
		je .fim
		jmp .for
	.achei:	
		mov ah,1 ; seta register de validade
		mov di,banco ; di = offset
		add di,bx ; bx = pos
		mov al,1 ; ocupa aquela conta
		stosb
		
	.fim:

	ret

gets: ; leitor de string
	 ; obs.: se voce errar a string, o problema eh seu
	mov al,0
	.for:
		call getchar ; le caractere
		stosb
		cmp al,13
		je .fim
		call putchar ; printa a letra
		jmp .for
	.fim:
	dec di
	mov al,0
	stosb
	mov si,endl
	call prints		
	ret

armz: ; armazenando na memoria a string recebida na posicao bx

	mov di,banco
	mov si,string
	add di,bx ; di -> posicao que irei escrever, si -> posicao que irei ler

	.for:
		lodsb
		stosb
		cmp al,0
		je .fim
		jmp .for
	.fim:

	ret
		

cadastrar_conta: 
	call clear

	; existe espaco para mais uma conta ?
	mov ah,0
	mov bx,0
	call check
	cmp ah,0
	je .naopossuiespaco ; nao ha espaco, entao nao sera possivel adicionar

	 ; possui espaco
		mov si,digiteNomeUser ;
		call prints
		mov di,string
		call gets ; ler nome do usuario
		inc bx  ; bx indica em qual posicao no vetorzao colocar a string
		call armz ; armazenando na memoria
		mov si,digiteCpf ; mensagem para printar cpf
		call prints
		mov di,string
		call gets ; lendo cpf (sem tracos)
		mov cx,20
		add bx,cx 
		call armz ; armazenando cpf na memoria
		call clear
		mov si,addSuccessfull ; printa mensagem de sucesso
		call prints
		; descobrindo o numero da conta
		mov dx,0
		mov ax,bx
		mov bx,35
		div bx
		mov bl,48
		add al,bl
		call putchar ; printa numero da conta
		mov si,endl
		call prints
		mov si,endl
		call prints		

	jmp .fim
	
	.naopossuiespaco: ; informando ao usuario que nao ha espaco
		call clear
		mov si,bankisfull 
	 	call prints	
		mov si,endl
		call prints
	
	.fim:

	jmp voltei

buscar_conta:
	call clear

	mov si,w_deletar
	call prints
	mov si,endl
	call prints

	call getchar
	call putchar
	sub al,48
	mov cl,al
	mov si,endl
	call prints
	mov si,endl
	call prints
	mov bx,0 ; bx = pos

	; find conta
	mov si,banco
	inc cl
	.for: ; move si para o num da conta
		dec cl
		cmp cl,0
		je .edit
		add si,35
		add bx,35
		jmp .for
	.edit:
		lodsb
		cmp al,0
		je .if

	; se chegou aqui, entao a conta existe
	mov si,contaEncontrada ; 
	call prints
	mov si,endl
	call prints
	mov si,endl
	call prints
	mov si,nomeUser ; nome do dono da conta
	call prints
	mov si,banco
	add si,bx
	inc si
	call prints
	mov si,endl
	call prints
	mov si,cpfUser ; cpf do usuario
	call prints
	mov si,banco
	add si,21
	call prints
	mov si,endl
	call prints
	mov si,endl
	call prints
	jmp .else

	.if:
	mov si,contaNaoCadastrada ; informa que a conta nao foi cadastrada
	call prints
	mov si,endl
	call prints
	mov si,endl
	call prints
	.else:
	
	jmp voltei

editar_conta:
	call clear
	
	mov si,w_deletar ; printf(Digite numero da conta)
	call prints
	mov si,endl
	call prints

	call getchar
	call putchar
	sub al,48
	mov cl,al
	mov si,endl
	call prints
	mov si,endl
	call prints
	mov bx,0 ; bx = pos

	; find conta
	mov si,banco
	inc cl
	.for: ; move si para o num da conta
		dec cl
		cmp cl,0
		je .edit
		add si,35
		add bx,35
		jmp .for
	.edit:
		lodsb
		cmp al,0
		je .if

	; se chegou aqui, entao a conta existe
	mov si,contaEncontrada ; 
	call prints
	mov si,endl
	call prints

	mov si,digiteNomeUser ;
	call prints
	mov di,string
	call gets ; ler nome do usuario
	inc bx  ; bx indica em qual posicao no vetorzao colocar a string
	call armz ; armazenando na memoria
	mov si,digiteCpf ; mensagem para printar cpf
	call prints
	mov di,string
	call gets ; lendo cpf (sem tracos)
	mov cx,20
	add bx,cx 
	call armz ; armazenando cpf na memoria
	call clear
	mov si,contaEditada ; printa mensagem de sucesso
	call prints
	mov si,endl
	call prints
	jmp .else

	.if:
	mov si,contaNaoCadastrada ; informa que a conta nao foi cadastrada
	call prints
	mov si,endl
	call prints
	mov si,endl
	call prints
	.else:
	
	jmp voltei

deletar_conta:
	mov si,endl
	call prints
	
	mov si,w_deletar ; informe o numero da conta
	call prints
	mov si,endl
	call prints

	call getchar
	mov ch,al
	mov cl,0	
	sub ch,48
	mov si,banco
	mov di,banco
	inc ch
	; ch -> conta a ser deletada

	.loop1:
		dec ch
		cmp ch,0
		je .edit
		add si,35
		add si,banco
		jmp .loop1
			
	.edit:
		lodsb
		mov ah,al
		push ax
		mov al,0
		
		stosb

	call clear
	pop ax
	cmp ah,0
	je .if
	mov si,w_conta_deletada ; se a contra existir, deleta a conta
	call prints
	jmp .else
	.if:
		mov si, conta_nao_existe ; se a conta nao existir, nao deleta a conta
		call prints
	.else:
		mov si,endl
		call prints
		mov si,endl
		call prints

	jmp voltei

loop_main:

	
	loop:
	;######### MENU ###################
	mov si,cadastrar
	call prints
	mov si, buscar
	call prints
	mov si,editarConta
	call prints
	mov si,deletar
	call prints	
	mov si,exite
	call prints
		
	;###### processa##################################
	call getchar
	push ax
	call putchar
	mov si,endl
	call prints
	pop ax

	cmp al,'3'
	je cadastrar_conta

	cmp al,'4'
	je buscar_conta

	cmp al,'5'
	je editar_conta

	cmp al,'6'
	je deletar_conta
	
	jmp exit

	mov si,endl
	call prints
	voltei:
	jmp loop
	exit:
	ret

main:

	xor ax,ax
	mov ds,ax
	mov es,ax


	call loop_main  ; loop infinito que roda o banco
	mov si,fim_banco ; mensagem de despedida
	call prints
	;jmp finish

finish:

	mov ah,4ch
	int 21h ; encerrando o codigo
; one 1
; two 2
  
