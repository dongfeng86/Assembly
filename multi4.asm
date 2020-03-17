assume cs:code
code segment
	mov ax,0fffh
	mov ds,ax
	mov ax,0
	mov dx,0
	
	mov bx,0
	mov cx,12
            s:	mov dl,[bx]
	add ax,dx
	inc bx
	loop s

	mov ax,4c00h
	int 21h
code ends
end