assume cs:codesg,ds:data

data segment
	db 1,2,3,4,5,6,7,8,9,10,11,12
data ends

codesg segment
	start:
		mov ax,data
		mov ds,ax
		
		mov bx,0
		mov dx,0
		mov cx,12
	  s:mov al,[bx]
		cmp al,2
		jb outran
		cmp al,8
		ja outran
		inc dx
 outran:inc bx
		loop s
		
		mov ax,4c00h
		int 21h
codesg ends
end start