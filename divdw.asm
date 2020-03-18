assume cs:codesg,ss:stack

stack segment
	dw 8 dup(0)
stack ends

codesg segment
	start:
		mov ax,4240h
		mov dx,0083h
		mov cx,0ah
		call divdw
		
		mov ax,4c00h
		int 21h		
	divdw:
		push bx
		push ax
		
		mov ax,dx
		mov dx,0h
		div cx
		;此时余数结果在DX中，商的结果在AX中
		mov bx,ax          ;将高位结果存储在bx中
		pop ax             ;将ax恢复为原来的低位数值，且dx中是余数
		div cx
		mov cx,dx          ;将cx保存为余数
		mov dx,bx          ;将高位运算结果保存在dx中
	
		pop bx
		ret
		
		
codesg ends
end start