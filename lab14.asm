assume cs:codesg,ds:data

data segment
	db 30 dup (0)
data ends

codesg segment
	start:
		mov ax,data
		mov ds,ax
		
		;获取年月日信息
		mov si,0
		mov cx,3
		mov di,9
	s:	push cx
	
		mov ax,di
		out 70h,al
		in al,71h
		
		;将年份信息的十位放入到ah中，个位放入到al中
		mov ah,al
		mov cl,4
		shr ah,cl
		and al,00001111b
		
		add ah,30h
		add al,30h
		
		mov [si],ah
		mov [si+1],al
		pop cx
		cmp cx,1
		je ok1		
		mov byte ptr [si+2],'/'
		
	ok1:add si,3
		dec di
		loop s
		
		;获取时分秒信息
		inc si
		mov cx,3
		mov di,4
	s1:	push cx
	
		mov ax,di
		out 70h,al
		in al,71h
		
		;将时信息的十位放入到ah中，个位放入到al中
		mov ah,al
		mov cl,4
		shr ah,cl
		and al,00001111b
		
		add ah,30h
		add al,30h
		
		mov [si],ah
		mov [si+1],al
		
		pop cx
		cmp cx,1
		je ok2
		mov byte ptr [si+2],':'
		
	ok2:add si,3
		sub di,2
		loop s1
	
		;增加一个结束符
		inc si
		mov byte ptr [si],'$'
		
		;显示data中的数据
		mov dx,0
		mov ah,9
		int 21h
		
		mov ax,4c00h
		int 21h
codesg ends
end start