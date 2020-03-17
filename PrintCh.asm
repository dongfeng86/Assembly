assume cs:code,ss:stack,ds:data

data segment
	db 'welcome to masm!',0
data ends

stack segment
	db 32 dup(0)
stack ends

code segment
	start:
		mov dh,8
		mov dl,3
		mov cl,2
		mov ax,data
		mov ds,ax
		mov si,0
		call show_str
			
		mov ax,4c00h
		int 21h
		
		;作用：显示从ds:0开始的字符串，直到遇到0
		;dh:表示字符显式在哪一行
		;dl:表示字符显式在哪一列
		;cl:表示字符的颜色
		;ds:表示字符段地址，且偏移地址从0开始
	show_str:
		push es
		push ax
		push dx
		push bx
		push cx
		
		mov ax,0b800h
		mov es,ax   ;store the screen strorage section address in es
		
		mov al,160
		mov ah,0h
		mul dh		
		push ax     ;the ax store the row number
		
		mov al,2
		mov ah,0h
		mul dl
		mov bx,ax
		pop ax
		add bx,ax
		
		mov si,0
	  s:mov cl,ds:[si]
		mov ch,0h
		jcxz ok
		mov byte ptr es:[bx],cl
		pop cx
		mov byte ptr es:[bx].1,cl
		push cx
		inc si
		add bx,2h
		jmp short s
		
	 ok:pop cx
		pop bx
		pop dx
		pop ax
		pop es
		ret
code ends

end start