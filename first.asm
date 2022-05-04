jmp start   
temp dw 0h
number db 5 dup 0h	; stores output string
count dw 0h
cr dw 10, 13, "$"


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
	je setup_string
	cmp dl, '+' ; check plus sign
	je add_them
	cmp dl, '*' ; check multiply sign
	je mult_them
	sub dx,'0' ; take actual value
	mov temp,dx ; last digit will be added
	mov cx,10h 
	mul cx ; digit shift to left
	add ax,temp ;add last digit
	mov cx,ax ;hold current value
	mov ax,0
	jmp read_input ;loop

start:
	mov cx,0	 			; cx will hold the current integer
	mov bl,0      			; bl will be used as counter
	jmp read_input

add_them:
	mov ah, 0 ;
	pop ax 
	pop dx  
	add ax,dx  
	push ax  ;take last 2 element and add them then push to stack
	mov ax,0
	jmp read_input ;continue to read

mult_them:
	mov ah, 0 ;
	pop ax
	pop dx
	mul dx
	push ax ;take last 2 element multiply  them then push to stack
	mov ax,0
	jmp read_input ;continue to read

setup_string:
	pop ax
	mov bx,offset number+4 	; put a $ at end of buffer
	mov b[bx],"$"			; we will fill buffer from back
	dec bx

convert_hexadecimal:
	mov dx,0
	mov cx,10h
	div cx					; divide ax (i.e. current number) by 10 to get the last digit
	add dx,48d  			; convert remainder (last digit) to its ASCII representation
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
