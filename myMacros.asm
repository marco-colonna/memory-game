;macros start
	prtStr macro x
		mov dx,offset x ;set dx to address where msg string starts
		mov ah,09h ;set high order byte of ax to 9 (DOS API for writing a string)
		int 21h ;interrupt the program to go to the DOS API
	endm
	
	prtCh macro y
		mov dl,y
		mov ah,02h ;set high byte of ax to 2 (DOS API operation to write an ascii character)
		int 21h
	endm

	exit macro
		mov ah,4ch ;set high byte of ax to 4c (terminate and return to DOS)
		int 21h
	endm
	
	cls macro
		mov ax,02h ;set the ax register to 2 (BIOS clear screen operation)
		int 10h ;BIOS interrupt
	endm
	
	scrColor macro color 
		mov ah,06h ;set high byte of ax to 6 (BIOS scroll up screen operation)
		mov al,0 ;set low byte to 0 (BIOS scroll entire screen)
		mov bh,color ;set the high byte of bx to two digit hex value stored in color
		mov cx,0 ;set cx to 0 (ch to top row and cl to left column)
		mov dx,184fh ;set dx to size of screen
		int 10h
	endm
;macros end