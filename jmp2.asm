assume cs:code

data segment
	dd 12345578h         ;在后面加有标号的“：”的地址标号，
						 ;只能在代码段中使用，不能在其他段中使用。
data ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov bx,0
	mov [bx],bx
	mov [bx+2],cs
	jmp dword ptr ds:[0]    ;跳转指令
code ends
end start