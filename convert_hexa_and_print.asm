jmp setup_string   
count dw 0h
number db 5 dup 0h	; stores output string
deb dw 1111d

setup_string:
	mov ax,deb
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

printout:
	mov dx,bx				; give the address of string to dx
	inc dx					; we decremented once too many, go forward one
	mov ah,09
	int 21h
exit:
	mov ah, 04ch
	mov al, 00
	int 21h
