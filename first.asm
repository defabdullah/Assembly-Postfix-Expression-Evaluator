jmp read_input    
temp dw 0
number_finish:
	mov ah, 0 ; make the top half zero 
	push cx ; push number to stack

read_input:
                                            
	mov ah, 01h; to read character
	int 21h
	mov dx,0 
	mov dl,al
	mov ax,cx ;cx hold current value 
	cmp dl,20h ;check space
	je number_finish
	cmp dl, 0dh ; check enter
	je exit
	cmp dl, '+' ; check enter
	je add_them
	cmp dl, '*' ; check enter
	je mult_them
	sub dx,'0' ; take actual value
	mov temp,dx ; last digit will be added
	mov cx,16 
	mul cx ; digit shift to left
	add ax,temp ;add last digit
	mov cx,ax ;hold current value
	mov ax,0
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
