assume cs:codesg

codesg segment
	start:
		;安装int 7ch中断例程
		mov ax,cs
		mov ds,ax
		mov si,offset rbegin
		mov ax,0
		mov es,ax
		mov di,0200h
		mov cx,offset rend-offset rbegin
		cld
		rep movsb
	
		;重新设置向量表
		mov ax,0
		mov es,ax
		mov word ptr es:[7ch*4+0],0200h
		mov word ptr es:[7ch*4+2],0
		
		mov ax,4c00h
		int 21h		
		
		;(dh)=行号
		;(dl)=列号
		;(cl)=颜色
		;ds:si指向字符串首地址
	rbegin:
		push ax
		push es
		push di

		
		mov ax,0b800h
		mov es,ax
		mov al,160
		mul dh
		push ax          ;保存一下ax的值
		mov al,2
		mul dl
		pop di           ;将保存的ax弹出
		add di,ax 
		
	rs: push cx
		mov cl,[si]
		mov ch,0
		jcxz rok
		mov es:[di],cl
		pop cx
		mov es:[di+1],cl
		inc si
		add di,2
		jmp short rs
		
	rok:pop cx
		pop di
		pop es
		pop ax
		
		iret             ;iret相当于pop ip pop cs popf
	
	rend:nop
codesg ends

end start