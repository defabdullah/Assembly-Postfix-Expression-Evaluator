jmp read_input                                           
read_input:
                                            
	MOV AH, 01h; to read character
	INT 21h
	CMP AL, 0dh ; check if it is enter
	JE stopreading
	MOV AH, 0 ; make the top half zero 
	push AX ; push AX to stack
	jmp readloop

exit:
	MOV AH, 04Ch
	MOV AL, 00
	INT 21h
