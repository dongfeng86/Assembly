assume cs:code
code segment
	mov ax,0ffffh
	mov ds,ax
	mov ax,0020h
	mov ss,ax

	mov ax,0
	mov bx,0
	mov cx,12
             s: mov al,ds:[bx]
	mov ss:[bx],al
	inc bx
	loop s		

	mov ax,4c00h
	int 21h
code ends
end
