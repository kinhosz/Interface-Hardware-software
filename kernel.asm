org 0x8600
jmp 0x0000:main

data:

	banco times 350 db 0
	input times 2 db 0
	;######### menu ############
	cadastrar db '1- Cadastrar conta:',13,10,0
	buscar db '2- Buscar conta:',13,10,0
	editarConta db '3- Editar conta:',13,10,0
	deletar db '4- Deletar conta:',13,10,0
	exite db 'qualquer outra coisa - sair',13,10,0
	;########## fim menu #############
	;##############warnings#################
	w_deletar db 'Digite o numero da conta entre 0 e 9',13,10,0 
	w_conta_deletada db 'Conta deletada com sucesso!',13,10,0
	
	;########################################
	




getchar:
  mov ah, 0x00
  int 16h
  ret


putchar:

	mov ah,0ah
	mov bl,4
	mov bh,0
	mov cx,1
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
  

cadastrar_conta:
	
	jmp voltei

buscar_conta:
	
	jmp voltei

editar_conta:
	
	jmp voltei

deletar_conta:

	mov si,w_deletar
	call prints

	call getchar
	mov ch,al
	mov cl,0	
	sub ch,48
	mov si,banco
	inc al

	.loop1:
		dec al
		cmp al,0
		je .edit
		mov cl,35
		.loop2:
			inc si
			dec cl
			cmp cl,0
			je .loop1
			jmp .loop2 
			
	.edit:
		mov al,48
		stosb
		
	mov si,w_conta_deletada
	call prints

	jmp voltei

loop_main:

	
	loop:

	mov si,cadastrar
	call prints
	mov si, buscar
	call prints
	mov si,editarConta
	call prints
	mov si,deletar
	call prints
	
	mov si,exit
	call prints
	
		
	;###### processa##################################
	call getchar
	cmp al , '1'
	je cadastrar_conta

	cmp al , '2'
	je buscar_conta

	cmp al , '3'
	je editar_conta

	cmp al , '4'
	je deletar_conta
	
	
	jmp exit

	voltei:
	jmp loop
	exit:
	ret

_init:

	mov ah,4fh
	mov al,02h
	mov bx,03h
	int 10h
	ret

main:


	xor ax,ax
	mov ds,ax
	mov es,ax

	call _init

	call loop_main

  
