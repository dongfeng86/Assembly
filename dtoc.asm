assume cs:code,ss:stack

data segment
	db 128 dup(0)
data ends

stack segment
	dw 128 dup(0)
stack ends


code segment
	start:
		mov ax,data
		mov ds,ax
		
		mov ax,24675
		mov bx,data
		mov si,0
		
		call dtoc
		
		mov dh,12
		mov dl,10
		mov cl,3
		call show_str
		
		mov ax,4c00h
		int 21h
		
		;作用：将word型数据转换为ascii码，放置于ds:0处
		;ax:存储需要转换的数字
	dtoc:
		push ax
		push bx
		push cx
		push dx
		push si
		
			mov si,0
			mov dx,0
			mov bx,0ah
		 s0:div bx
			push dx             ;将余数压入栈中
			inc si
			mov cx,ax           ;将商放到cx中
			jcxz ok1            ;如果商为0,跳转到ok处
			mov dx,0            ;将dx清0
			jmp short s0
			
		ok1:mov cx,si
			mov si,0
			mov ax,0
		 s1:pop ax
			add ax,030h
			mov byte ptr [si],al
			inc si
			loop s1
	 
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
	ret
		
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
		 s4:mov cl,ds:[si]
			mov ch,0h
			jcxz ok2
			mov byte ptr es:[bx],cl
			pop cx
			mov byte ptr es:[bx].1,cl
			push cx
			inc si
			add bx,2h
			jmp short s4
			
		ok2:pop cx
			pop bx
			pop dx
			pop ax
			pop es
	ret
		
code ends
end start