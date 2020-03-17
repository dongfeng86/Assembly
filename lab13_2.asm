assume cs:codesg

codesg segment
	start:
		;安装7ch中断例程
		mov ax,cs
		mov ds,ax
		mov si,offset sbegin
		mov cx,offset send - offset sbegin
		
		mov ax,0
		mov es,ax
		mov di,0200h
		
		cld
		rep movsb
		
		mov ax,4c00h;
		int 21h
		
		;更新中断向量表
		mov ax,0
		mov es,ax
		mov word ptr es:[7ch*4],0200h
		mov word ptr es:[7ch*4+2],0
		
		;完成loop指s令
		;(cx)=循环次数
		;(bx)=位移
	sbegin:
		push bp
		mov bp,sp
		dec cx
		jcxz ok1		
		add [bp+2],bx
		
	ok1:pop bp
		iret
   send:nop
		
codesg ends

end start