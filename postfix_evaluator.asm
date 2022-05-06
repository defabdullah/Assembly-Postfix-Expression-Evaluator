jmp start   
temp dw 0h			;temporary byte for use last digit
newline dw 10, 13, "$"			; new line word
number db 5 dup 0h	; stores output string 5 bytes with $
count dw 0h    ;current output counter which stops at 4
operator_bool db 0h ; boolean which store is last element operator
just_var db 1h ; control input is just one element without space it set to 0 when see space
 
start:
	mov ax,0	 			; ax is accumulator register
	mov cx,0	 			; cx will hold the current integer
	mov dx,0	 			; dx will be using in operations
	jmp read_input

;take last 2 element and add them then push to stack
addition:
	mov operator_bool,1h ;set operator bool to true
	pop ax 
	pop dx  
	add ax,dx  
	push ax  
	mov ax,0
	jmp read_input ;continue to read

;take last 2 element multiply  them then push to stack
multiplication:
	mov operator_bool,1h ;set operator bool to true
	pop ax
	pop dx
	mul dx
	push ax 
	mov ax,0
	jmp read_input ;continue to read

;take last 2 element divide them then push to stack
division:
	mov operator_bool,1h ;set operator bool to true
	mov dx,0
	pop bx
	pop ax
	div bx
	push ax 
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
	je set_result
	
	cmp dl, '+' ; check plus sign
	je addition
	
	cmp dl, '*' ; check multiply sign
	je multiplication

	cmp dl, '/' ; check division sign
	je division

	cmp dl, 5eh ; check xor sign
	je bitwise_xor
	
	cmp dl, 7ch ; check or sign
	je bitwise_or
	
	cmp dl, 26h ; check and	sign
	je bitwise_and_starter

	mov operator_bool,0h ;set operator bool to zero
	cmp dl,58 ; check if digit is greater than "9" 
	jb digit_actual_value ; get digits numerical value from ascii value if it is in the range ("0","9")
	ja letter_actual_value;  get digits numerical value from ascii value if it is in the range ("A","F")

;add last digit actual value to current number
add_last_digit_or_letter:
	mov temp,dx ; last digit will be added
	mov cx,10h 
	mul cx ; digit shift to left
	add ax,temp ;add last digit
	mov cx,ax ;hold current value
	mov ax,0
	jmp read_input ;continue to read

;turn char to numeric value in hexadecimal format(if it is digit)
digit_actual_value:
	sub dx,'0' ; take actual value
	jmp add_last_digit_or_letter ;continue to add last digit actual value to current number

;turn char to numeric value in hexadecimal format(if it is letter)
letter_actual_value:
	sub dx,55d ; take actual value
	jmp add_last_digit_or_letter ;continue to add last digit actual value to current number

;control input is just variable without space and push current number in that case 
set_result:
	cmp just_var,0h
	je setup_string
	push cx

;set the empty 5 byte string with $ end
setup_string:
	pop ax
	mov bx,offset number+4 	; put a $ at end of buffer
	mov b[bx],"$"			; we will fill buffer from back
	dec bx
	jmp convert_hexadecimal

;when space is entered this label push all number to stack
number_finish:
	mov just_var,0h 
	cmp operator_bool,1h ;if last input then it doesn't push to stack 
	je read_input
	push cx ; push number to stack
	mov cx,0
	jmp read_input

;take last 2 element xor them then push to stack
bitwise_xor:
	mov operator_bool,1h ;set operator bool to true
	mov dx,0
	pop dx
	pop ax
	xor ax,dx
	push ax 
	mov ax,0
	jmp read_input ;continue to read

bitwise_and_starter:
	jmp bitwise_and

;take last 2 element or them then push to stack
bitwise_or:
	mov operator_bool,1h ;set operator bool to true
	mov dx,0
	pop dx
	pop ax
	or ax,dx
	push ax 
	mov ax,0
	jmp read_input ;continue to read

;take last 2 element and them then push to stack
bitwise_and:
	mov operator_bool,1h ;set operator bool to true
	mov dx,0
	pop dx
	pop ax
	and ax,dx
	push ax 
	mov ax,0
	jmp read_input ;continue to read

;get last character of string and turn ascii value of its char
convert_hexadecimal:
	mov dx,0
	mov cx,10h
	div cx
	cmp dx,10d ;check if digit is greater than 9 
	jb get_digit_ascii ;get digits ascii value from numerical value if it is in the range (0,9)
	jae get_letter_ascii 	;get digits ascii value from numerical value if it is in the range (A,F)

;add real ascii value to string and move iterator
assign_char_to_output:
	mov [bx],dl				; and move to buffer for output
	dec bx
	inc count
	cmp count,04h			; check if we have got all digits if it is not continue to take digit
	jnz convert_hexadecimal

;print newline character
print_newline:
	mov ah,09
	mov dx,offset newline		; print out a carriage return character
	int 21h

;print result(in bx register)
print_out:
	mov dx,bx				; give the address of string to dx
	inc dx					; we decremented once too many, go forward one
	mov ah,09
	int 21h
	
;exit program
exit:
	mov ah, 04ch
	mov al, 00
	int 21h

;get digits ascii value from numerical value if it is in the range (0,9)
get_digit_ascii:
	add dx,48d 
	jmp assign_char_to_output ;continue to create result string

;get digits ascii value from numerical value if it is in the range (A,F)
get_letter_ascii:
	add dx,55d 
	jmp assign_char_to_output ;continue to create result string