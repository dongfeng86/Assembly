assume cs:codesg
codesg segment
	mov ax,1023h
	mov bx,0456h
	add ax,bx
	add ax,ax
	
	mov ax,4c00h
	int 21h
codesg ends

end