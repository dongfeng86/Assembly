assume cs:codeseg,ds:data,es:table

data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	;以上是表示9年的9个字符串
	dd 16,22,382,1356,2390,8000,16000,24486,50065
	;以上是表示9年公司总收入的9个dword型数据
	dw 3,7,9,13,28,38,130,220,476
	;以上表示9年公司雇员人数的9个word型数据
data ends

table segment
	db 9 dup ('year summ ne ?? ')
table ends

codeseg segmentd 
start:
	mov ax,data
	mov ds,ax
	
	mov ax,table
	mov es,ax

	;copy the data of year
	mov bx,0
	mov cx,9
	mov si,0
 s0:mov ax,ds:[si]
	mov word ptr es:[bx].0,ax
	add si,2h
	mov ax,ds:[si]
	mov word ptr es:[bx].2,ax
	add bx,10h
	add si,2h	
	loop s0

	;copy the summary
	mov bx,0
	mov cx,9
	mov si,0
	mov di,5
 s1:mov ax,ds:24h[si]
	mov word ptr es:[bx].0[di],ax
	add si,2h
	mov ax,ds:24h[si]
	mov word ptr es:[bx].2[di],ax
	add bx,10h
	add si,2h
	loop s1

	;copy the employee number 
	mov bx,0
	mov cx,9
	mov si,0
	mov di,10
 s2:mov ax,ds:48h[si]
	mov word ptr es:[bx][di],ax
	add si,2h
	add bx,10h
	loop s2

	;average salary
	mov bx,0
	mov cx,9   
 s3:mov ax,es:[bx].5
	mov dx,es:[bx].7
	div word ptr es:[bx].0ah
	mov es:[bx].0dh,ax
	add bx,10h
	loop s3
	
	mov ax,4c00h
	int 21h
codeseg ends
end start