assume cs:code

code segment
	start:
		mov al,10
		mov ah,0
		mov dl,al
		mov dh,0
		mov cl,3
		shl ax,cl
		add ax,dx
		add ax,dx
		
		mov ax,4c00h
		int 21h
code ends
end start