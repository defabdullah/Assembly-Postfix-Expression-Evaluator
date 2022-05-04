jmp read_input    
temp dw 0
number_finish:
	mov ah, 0 ; make the top half zero 
	push cx ; push number to stack

read_input:
                                            
	mov ah, 01h; to read character
	int 21h
	mov dx,0
	mov dl,al ; dx reads input
	mov ax,cx ;cx hold current value 
	cmp al,20h ;check space
	je number_finish
	cmp al, 0dh ; check enter
	je exit
	cmp al, '+' ; check enter
	je add_them
	cmp al, '*' ; check enter
	je mult_them
	sub dx,'0' ; take actual value
	mov temp,dx ; last digit will be added
	mov cx,16 
	mul cx ; digit shift to left
	add ax,temp ;add last digit
	mov cx,ax ;hold current value
	jmp read_input ;loop

add_them:
	mov ah, 0 ;
	pop ax 
	pop dx  
	add ax,dx  
	push ax  ;take last 2 element and add them then push to stack
	jmp read_input ;continue to read

mult_them:
	mov ah, 0 ;
	pop ax
	pop dx
	mul dx
	push ax ;take last 2 element multiply  them then push to stack
	jmp read_input ;continue to read

exit:
	mov ah, 04ch
	mov al, 00
	int 21h
