assume cs:code

stack segment
	db 128 dup (0)
stack ends

code segment
	start:
		;指定栈的ss和sp值
		mov ax,stack
		mov ss,ax
		mov sp,128
		
		;复制int 9 例程到0：204当中
		mov ax,0
		mov es,ax
		mov di,204h
		
		push cs
		pop ds
		mov si, offset int9start
		mov cx,offset int9end - offset int9start
		cld                 ;递增模式
		rep movsb
		
		;更改中断类型号为9的中断向量
		;先将原来的9号中断类型码向量保存在0:[200h]当中
		push es:[9*4]
		pop es:[200h]
		push es:[9*4+2]
		pop es:[202h]
		
		;更改中断类型号为9的中断向量
		cli
		mov word ptr es:[9*4],204h
		mov word ptr es:[9*4+2],0
		sti
		
		mov ax,4c00h
		int 21h
		
		;该中断例程功能：按下某个键后，除非不再松开，否则，满屏显示该键
	int9start:
		push ax
		push si
		push cx
		push es
		push bx
		
		;取出端口中的字母
		in al,60h
		pushf
		;执行原来的int 9 中断过程
		mov bx,0
		push bx
		pop es
		call dword ptr es:[200h]
		
		cmp al,1eh+80h
		jne ok1
		;显示满屏幕的A
		mov si,0
		mov bx,0b800h
		mov es,bx
		mov cx,2000
	s1:	mov byte ptr es:[si],'A'
		mov byte ptr es:[si+1],2
		add si,2
		loop s1
		
	ok1:
		pop bx
		pop es
		pop cx
		pop si
		pop ax
		iret
	int9end:
		nop
		
code ends
end start