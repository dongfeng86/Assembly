assume cs:code,ss:stack

stack segment
	db 128 dup (0)
stack ends

code segment
	;安装int 7ch例程
	;将例程安装在0:200位置
start:
	mov ax,stack
	mov ss,ax
	
	mov ax,0
	mov es,ax
	mov di,0200h
	push cs
	pop ds
	mov si,offset setscreen
	mov cx,offset end_setscreen-offset setscreen
	cld 
	rep movsb
	
	;更改中断类型码7ch的中断向量
	mov ax,0
	mov ds,ax
	cli
	mov word ptr ds:[4*7ch],0200h
	mov word ptr ds:[4*7ch+2],0
	sti

	mov ax,4c00h
	int 21h

	;该例程可以实现以下功能：
	;0.清屏
	;1.设置前景色
	;2.设置背景色
	;3.向上滚动一行
	;参数：ah传递功能号；对于1，2号功能，al传递颜色值
	
	;特别提醒：自己在第一次做的时候没有加上org 200h这句指令。造成跳转不到正确的位置
	;这是因为table标号表示偏移地址。这个是安装程序，在运行安装程序的时候，他的地址
	;为0032，将table转移到7ch中断向量表的入口地址处时，它的值还是0032h,此时段地址就为
	;0h,所以执行call word ptr table[bx]就相当于执行，call word ptr cs:[0032]。
	;加上org 200h，该语句指定了org 200h后面的指令会被加载到偏移地址200h的位置。
	;我们移植org 200h后面的指令到0：200h的位置
	org 200h
setscreen:
		jmp short set
  table dw offset sub1,offset sub2,offset sub3,offset sub4
   set:	push bx
		
		cmp ah,3
		ja sret
		mov bl,ah
		mov bh,0
		add bx,bx
		
		call word ptr table[bx]
  sret:	pop bx
		iret
		
		
sub1:	push bx
		push cx
		push es
		mov bx,0b800h
		mov es,bx
		mov bx,0
		mov cx,2000
 subls:	mov byte ptr es:[bx],' '
		add bx,2
		loop subls
		
		pop es
		pop cx
		pop bx
		ret
		
sub2:	push bx
		push cx
		push es
		
		mov bx,0b800h
		mov es,bx
		mov bx,1
		mov cx,2000
  sub2s:and byte ptr es:[bx],11111000b
		or es:[bx],al
		add bx,2
		loop sub2s
		
		pop es
		pop cx
		pop bx
		ret
		
sub3:	push bx
		push cx
		push es
		mov cl,4
		shl al,cl
		mov bx,0b800h
		mov es,bx
		mov bx,1
		mov cx,2000
  sub3s:and byte ptr es:[bx],10001111b
		or es:[bx],al
		add bx,2
		loop sub3s
		pop es
		pop cx
		pop bx
		ret
		
sub4:	push cx
		push si
		push di
		push es
		push ds
		
		mov si,0b800h
		mov es,si
		mov ds,si
		mov si,160
		mov di,0
		cld
		mov cx,24
  sub4s:push cx
		mov cx,160
		rep movsb
		pop cx
		loop sub4s
		
		;最后一行清空
		mov cx,80
		mov si,0
 sub4s1:mov byte ptr [160*24+si],' '
		add si,2
		loop sub4s1
		
		pop ds
		pop es
		pop di
		pop si
		pop cx
		ret
			
end_setscreen:
		nop

code ends
end start




















