assume cs:codesg,ds:data

data segment
	db 8,11,8,1,8,5,63,38
data ends

codesg segment
	start:
		mov ax,data
		mov ds,ax
		mov ax,0       ;ax用来保存大于8的个数
		mov si,0       ;si为data的数据指针
		
		mov cx,8
	  s:cmp byte ptr [si],8
		jna below
		inc ax
	below:
		inc si
		loop s
		
		mov ax,4c00h
		int 21h		
codesg ends
end start