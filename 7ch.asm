assume cs:codesg

codesg segment
	start:
	;安装程序
		mov ax,cs
		mov ds,ax
		mov si,offset sbegin
		mov ax,0
		mov es,ax
		mov di,0200h
		mov cx,offset send - offset sbegin
		cld 
		rep movsb
		
	;更改中断向量表
		mov ax,0
		mov ds,ax
		mov word ptr ds:[4*7ch],0200h    ;注意，直接数寻址要加前缀
		mov word ptr ds:[4*7ch+2],0
		
		mov ax,4c00h
		int 21h		
	
	sbegin:	
		lp:	push bp
			mov bp,sp
			dec cx
			jcxz lpret
			add [bp+2],bx      ;注意，bp默认的段地址为ss
	 lpret:	pop bp
			iret
	  send:	nop

codesg ends
end start