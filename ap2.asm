
org 0x7c00
jmp 0x0000:main
string db 'AP2 de IHS' , 13 , 0


putchar:
  mov ah, 0x0e
  int 10h
  ret
prints:       
      ; mov si, string

  .loop:
    lodsb           ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret
rotina:
    push ds 
    mov ax , 0 
    mov ds , ax 
    mov di , 100h
    mov word[di] , prints
    mov word[di+2] , 0
    pop ds 


main:
  mov si , string
  mov bx , si
  mov cx , 10
  call rotina 
int 40h
times 510-($-$$) db 0
dw 0xaa55