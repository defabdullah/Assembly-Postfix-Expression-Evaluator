jmp start   
temp dw 0h
cr     dw 10, 13, "$"			; carriage return, line feed
number db 5 dup 0h	; stores output string
count dw 0h
operator_bool db 0h ; store last element is operator

start:
	mov cx,0	 			; cx will hold the current integer
	mov bl,0      			; bl will be used as counter
	jmp read_input

add_them:
	mov operator_bool,1h
	pop ax 
	pop dx  
	add ax,dx  
	push ax  ;take last 2 element and add them then push to stack
	mov ax,0
	jmp read_input ;continue to read

mult_them:
	mov operator_bool,1h
	pop ax
	pop dx
	mul dx
	push ax ;take last 2 element multiply  them then push to stack
	mov ax,0
	jmp read_input ;continue to read

div_them:
	mov operator_bool,1h
	mov dx,0
	pop bx
	pop ax
	div bx
	push ax ;take last 2 element divide them then push to stack
	mov ax,0
	jmp read_input ;continue to read

read_input:			
	mov ah, 01h; to read character
	int 21h
	mov dx,0 
	mov dl,al
	mov ax,cx ;cx hold current value 

	cmp dl,20h ;check space
	je number_finish
	
	cmp dl, 0dh ; check enter
	je setup_string
	
	cmp dl, '+' ; check plus sign
	je add_them
	
	cmp dl, '*' ; check multiply sign
	je mult_them

	cmp dl, '/' ; check division sign
	je div_them

	cmp dl, 5eh ; check xor sign
	je bitwise_xor
	
	cmp dl, 7ch ; check or sign
	je bitwise_or
	
	cmp dl, 26h ; check and	sign
	je bitwise_and_help
	
	mov operator_bool,0h

	cmp dl,58 ; check if digit is greater than "9" 
	jb substract_zero ; get digits numerical value from ascii value if it is in the range ("0","9")
	ja substract_a ;  get digits numerical value from ascii value if it is in the range ("A","F")

read_input_second:
	mov temp,dx ; last digit will be added
	mov cx,10h 
	mul cx ; digit shift to left
	add ax,temp ;add last digit
	mov cx,ax ;hold current value
	mov ax,0
	jmp read_input ;loop

substract_zero:

	sub dx,'0' ; take actual value
	jmp read_input_second 

substract_a:
	sub dx,55d ; take actual value
	jmp read_input_second

setup_string:
	pop ax
	mov bx,offset number+4 	; put a $ at end of buffer
	mov b[bx],"$"			; we will fill buffer from back
	dec bx
	jmp convert_hexadecimal
	
number_finish:
	mov ah, 0 ; make the top half zero
	cmp operator_bool,1h
	je read_input
	push cx ; push number to stack
	mov cx,0
	jmp read_input
bitwise_xor:
	mov operator_bool,1h
	mov dx,0
	pop bx
	pop ax
	xor ax,bx
	push ax ;take last 2 element xor them then push to stack
	mov ax,0
	jmp read_input ;continue to read

bitwise_and_help:
	jmp bitwise_and

bitwise_or:
	mov operator_bool,1h
	mov dx,0
	pop bx
	pop ax
	or ax,bx
	push ax ;take last 2 element or them then push to stack
	mov ax,0
	jmp read_input ;continue to read

bitwise_and:
	mov operator_bool,1h
	mov dx,0
	pop bx
	pop ax
	and ax,bx
	push ax ;take last 2 element and them then push to stack
	mov ax,0
	jmp read_input ;continue to read

convert_hexadecimal:
	mov dx,0
	mov cx,10h
	div cx
	cmp dx,10d ;check if digit is greater than 9 
	jb add_zero ;get digits ascii value from numerical value if it is in the range (0,9)
	jae add_a 	;get digits ascii value from numerical value if it is in the range (A,F)

convert_hexadecimal_second_part:
	mov [bx],dl				; and move to buffer for output
	dec bx
	inc count
	cmp count,04h			; check if we have got all digits
	jnz convert_hexadecimal

print_cr:
	mov ah,09
	mov dx,offset cr		; print out a carriage return character
	int 21h

print_out:
	mov dx,bx				; give the address of string to dx
	inc dx					; we decremented once too many, go forward one
	mov ah,09
	int 21h

exit:
	mov ah, 04ch
	mov al, 00
	int 21h

add_zero:
	add dx,48d ;get digits ascii value from numerical value if it is in the range (0,9)
	jmp convert_hexadecimal_second_part

add_a:
	add dx,55d ;get digits ascii value from numerical value if it is in the range (A,F)
	jmp convert_hexadecimal_second_part