assume cs:code
code segment
	mov bx,0020h
	mov ds,bx
	mov bx,0h

	mov cx,64
             s: mov ds:[bx],bl
	inc bl
	loop s
	
	mov ax,4c00h
	int 21h
code ends
end