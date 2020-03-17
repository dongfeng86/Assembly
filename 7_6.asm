assume cs:codesg,ds:datasg

datasg segment
	db '1.file          '
	db '2.edit          '
	db '3.search        '
	db '4.view          '
	db '5.options       '
	db '6.help          '
datasg ends

codesg segment
start:	mov ax, datasg
	mov ds,ax
	
              	mov cx,6
	mov di,0
              s:mov al,2[di]
	and al,11011111b
	mov 2[di],al
	add di,16
	loop s
	
	mov ax,4c00h
	int 21h
codesg ends
end start