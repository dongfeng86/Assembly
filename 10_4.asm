assume cs:codesg
codesg segment
start:
	mov ax,6
	call ax
	inc ax
	mov bp,sp
	add ax,[bp]
	
	mov ax,4c00h
	int 21h
codesg ends
end start
