assume cs:codesg,ds:data

data segment
	db "$# Beginner's all - purpose Symbolic instruction $ Code.",0
data ends

codesg segment
	start:
		mov ax,data
		mov ds,ax
		mov si,0
		call letterc
		
		mov ax,4c00h
		int 21h
		
		;名称：letterc
		;功能：将以0结尾的字符串中的小写字母转成大写字母
		;参数：ds:si指向字符串的首地址
	letterc:
		push cx
		push si
		
	  s:mov ch,0h
		mov cl,[si]
		jcxz ok1
		cmp cl,61h
		jb outr
		cmp cl,7ah
		ja outr
		sub cl,20h
		mov [si],cl
		
   outr:inc si
		loop s
		
	ok1:pop si
		pop cx
		
		ret
codesg ends
end start