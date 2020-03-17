assume cs:codesg,ss:stack,ds:data

data segment
	db '1975',0,'1976',0,'1977',0,'1978',0,'1979',0,'1980',0,'1981',0,'1982',0,'1983',0
	;以上是表示9年的9个字符串
	dd 16,22,382,1356,2390,8000,16000,24486,50065
	;以上是表示9年公司总收入的9个dword型数据
	dw 3,7,9,13,28,38,130,220,476
	;以上表示9年公司雇员人数的9个word型数据
data ends

convertData segment
	db 30h dup (0)
convertData ends

stack segment
	db 30h dup (0)
stack ends

codesg segment
start:
	;清理屏幕
	mov bx,0
	mov cx,4000
	mov ax,0b800h
	mov es,ax
	s10:mov byte ptr es:[bx],0
		inc bx
		loop s10
	
	mov ax,data
	mov ds,ax            ;ds段寄存器保存数据地址信息
	
	mov ax,stack
	mov ss,ax            ;ss栈寄存器保存栈段的地址信息
	mov sp,30h           ;sp为栈底+1的地址
	
	;在屏幕上显式年份信息
	mov cx,9
	mov dh,3
	mov si,0
	 s0:push cx
		mov dl,0
		mov cx,2
		call show_str
		add si,5
		inc dh
		pop cx
		loop s0
	
	;在屏幕上显示收入信息
	;将收入dword型数据依次取到ax和dx中
	mov bx,0
	mov di,3                   ;di用于保存文字显示的行数
	mov cx,9
	s5:	push cx                 ;一定记住，如果循环中有pop的寄存器，必须在循环伊始就把寄存器push进去
		mov ax,ds:45[bx]        ;将dword型数据放入到ax和dx中，返回的字符串首地址为si
		add bx,2
		mov dx,ds:45[bx]
		mov si,0
		push ds
		
		push ax
		mov ax,convertData
		mov ds,ax                ;将ds变为转换后的字符串的段地址
		pop ax
		call dtoc                ;调用dtoc段，将转换后的字符串存储在段convertData中
		
		mov ax,di
		mov dh,al
		mov dl,10                ;显示在第dh行,dl列
		mov cl,2
		call show_str            ;调用show_str段，显示字符串
		
		add bx,2
		inc di
		
		pop ds
		pop cx
		loop s5
	
	;在屏幕上显示人数信息
	;将人数word型数据放入ax中，dx置为0
	mov bx,0
	mov di,3
	mov cx,9
	s6:	push cx
		mov ax,ds:51h[bx]
		mov dx,0
		mov si,0
		
		push ds
		push ax
		mov ax,convertData
		mov ds,ax                ;将ds变为转换后的字符串的段地址
		pop ax
		call dtoc                ;调用dtoc段，将转换后的字符串存储在段convertData中
		
		mov ax,di
		mov dh,al
		mov dl,30                ;显示在第dh行,dl列
		mov cl,2
		call show_str            ;调用show_str段，显示字符串
		
		add bx,2
		inc di
		
		pop ds
		pop cx
		loop s6
		
		
	;在屏幕上显示人均收入信息
	mov cx,9
	mov di,3
	mov bx,0
	mov bp,0
	 s8:push cx
		mov ax,ds:45[bx]
		mov dx,ds:45[bx+2]
		mov cx,ds:51h[bp]
		call divdw                ;进行不会溢出的除法
		
		push ds
		push ax
		mov ax,convertData
		mov ds,ax
		pop ax
		mov si,0
		call dtoc                 ;将数字转换为ascii字符,保存在convertData中
		
		mov ax,di
		mov dh,al
		mov dl,45
		mov ch,0
		mov cl,2
		mov si,0
		call show_str             ;
		
		inc di
		add bp,2
		add bx,4
		pop ds
		pop cx
		loop s8
		
	mov ax,4c00h
	int 21h
	
	;作用：显示从ds:[si]开始的字符串，直到遇到0
	;dh:表示字符显式在哪一行
	;dl:表示字符显式在哪一列
	;cl:表示字符的颜色
	;ds:表示字符段地址，且偏移地址从0开始
	;si:表示字符串在ds的偏移地址
	show_str:
		push si	
		push es
		push ax
		push dx
		push bx
		push cx
		
		mov ax,0b800h
		mov es,ax   ;store the screen strorage section address in es
		
		mov al,160
		mov ah,0h
		mul dh		
		push ax     ;the ax store the row number
		
		mov al,2
		mov ah,0h
		mul dl
		mov bx,ax
		pop ax
		add bx,ax        ;bx存储着字符在段es的偏移地址
		
		 s1:mov cl,ds:[si]
			mov ch,0h
			jcxz ok1
			mov byte ptr es:[bx],cl
			pop cx
			mov byte ptr es:[bx].1,cl
			push cx
			inc si
			add bx,2h
			jmp short s1
			
		    ok1:pop cx
				pop bx
				pop dx
				pop ax
				pop es
				pop si
	ret
		
	;作用：将dword型数据转换为ascii码，放置于ds:si处
	;ax:存储需要转换的低16位
	;dx:存储需要转换的高16位
	;ds:si指向转换后的字符串的首地址
	dtoc:
		push ax
		push bx
		push cx
		push dx
		push si
			
		 s2:mov cx,0ah
			call divdw        ;将ax和dx中的数据除以10
			push cx           ;将余数压入栈中
			inc si
			;以下判断ax,dx是否均为0
			mov cx,ax
			or cx,dx
			jcxz ok2          ;如果ax和dx均为0，跳转至ok1处
			jmp short s2      ;否则，跳转至s0继续循环
		
		ok2:mov cx,si
			mov si,0
			mov ax,0
		 s3:pop ax            ;将余数赋给ax,加上039h后写入ds:[si]中
			add ax,030h
			mov byte ptr ds:[si],al
			inc si
			loop s3
			
			mov byte ptr ds:[si],0   ;在字符串的末尾加上0
				 
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
	ret
	
	;功能：该函数进行不会产出溢出的除法计算，
	;被除数是dword型，除数是word型，结果为dword型
	;参数：
	;(ax)=dword型数据的低16位
	;(dx)=dword型数据的高16位
	;(cx)=除数
	;返回：
	;(ax)=结果的低16位
	;(dx)=结果的高16位
	;(cx)=余数
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