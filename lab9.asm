assume cs:codesg,ds:data,ss:stack
data segment
	db 'w',02,'e',02,'l',02,'c',02,'o',02,'m',02,'e',02,' ',02,'t',02,'o',02,' ',02,'m',02,'a',02,'s',02,'m',02,'!',02
	db 'w',28h,'e',28h,'l',28h,'c',28h,'o',28h,'m',28h,'e',28h,' ',28h,'t',28h,'o',28h,' ',28h,'m',28h,'a',28h,'s',28h,'m',28h,'!',28h
	db 'w',0f1h,'e',0f1h,'l',0f1h,'c',0f1h,'o',0f1h,'m',0f1h,'e',0f1h,' ',0f1h,'t',0f1h,'o',0f1h,' ',0f1h,'m',0f1h,'a',0f1h,'s',0f1h,'m',0f1h,'!',0f1h
	db 'w',79h,'e',79h,'l',79h,'c',79h,'o',79h,'m',79h,'e',79h,' ',79h,'t',79h,'o',79h,' ',79h,'m',79h,'a',79h,'s',79h,'m',79h,'!',79h
data ends

stack segment
	dw 0,1,2,3,4,5,6,7,8
stack ends

codesg segment
start:
	mov ax,data
	mov ds,ax
	
	mov ax,0b800h
	mov es,ax
	
	mov si,0
	mov cx,4
	mov bx,0a0h
  s:push cx
  
		mov di,0
		mov dx,0
		mov cx,32
	 s1:mov dl,[si]
		mov es:[bx][di],dl
		inc si
		inc di
		loop s1
	
	pop cx
	add bx,0a0h
	loop s
	
	mov ax,4c00h
	int 21h
codesg ends
end start