;Marco Colonna
;CSC 267 Final Project
;Concentration (Memory Game)

.model SMALL
.stack 100h
.data
	;represents the face of each card
	board dw 1,4,3,15,2,14,1,5,6,15,14,3,5,4,2,6
	;represents whether to display the face of the card
	;0 -> hide, 1 -> display
	found dw 16 dup (0)
	;stores guesses
	guess1 dw ?
	guess2 dw ?
	;stores number of matches
	matches dw 0
	;stores number of turns
	turns dw 0
	;messages to print
	welcome db 10,13,'Welcome to Concentration!',10,13,'$'
	help1 db 10,13,'This is a memory game in which you guess two cards.','$'
	help2 db 10,13,'If the faces of the cards match, you win the pair','$'
	help3 db 10,13,'and they remain face up. Dont waste a turn!',10,13,'$'
	continue db 10,13,'Enter any number to CONTINUE: ','$'
	prompt db 10,13,'Guess a card: ','$'
	invalid db 10,13,'Invalid input. Please try again.',10,13,'$'
	match db 10,13,'Match! :)',10,13,'$'
	nomatch db 10,13,'No match. :(',10,13,'$'
	reply db 10,13,'Enter 0 to QUIT. Enter any other number to CONTINUE: ','$'
	quit db 10,13,'Thanks for playing!',10,13,'$'
	win db 10,13,'Congratulations! Well done!',10,13,'$'
	prtTurns db 10,13,'Number of turns: ','$'
	newline db 10,13,'$'
.code
	extrn indec: proc
	extrn outdec: proc
	include myMacros.asm

MAIN proc
	mov ax,@data
	mov ds,ax
	call INTRO
M1:
	call PRINTBOARD
	call GUESS
	mov guess1,ax
	call PRINTBOARD
	call GUESS
	mov guess2,ax
	call PRINTBOARD
	call CHECK
	;game won once 8 matches are made
	cmp matches,8
	jne M1
	call WON
	exit ;call exit macro
MAIN endp

;print welcome screen and instructions
INTRO proc
	cls ;call cls macro
	scrColor 1eh ;call scrColor macro passing 1eh
	prtStr welcome ;call prtStr macro passing welcome
	prtStr help1 ;call prtStr macro passing help1
	prtStr help2 ;call prtStr macro passing help2
	prtStr help3 ;call prtStr macro passing help3
	prtStr continue ;call prtStr macro passing continue
	call indec ;input from user
	ret
INTRO endp

;print the board with hidden and displayed cards
PRINTBOARD proc
	cls ;call cls macro
	scrColor 1eh ;call scrColor macro passing 1eh
	prtStr newline ;call prtStr macro passing newline
	mov cx,0
	lea si,board ;si = board array
	lea di,found ;di = found array
P1:
	inc cx
	;check whether to hide or display card using found
	mov ax,[di]
	cmp ax,0
	je P2
	mov ax,[si]
	prtCh al ;call prtCh macro passing value from board array (display)
	jmp P3
P2:	
	prtCh 254 ;call prtCh macro passing value for square (hide)
P3:
	prtCh 32 ;call prtCh macro passing value for blank space
	add si,2
	add di,2
	;print a new line every 4 characters
	mov al,cl
	mov bl,4
	div bl
	cmp ah,0
	jne P4
	prtStr newline ;call prtStr macro passing newline
P4:
	;only print 16 characters
	cmp cx,16
	jl P1
	ret
PRINTBOARD endp

;receive a valid guess from the user
GUESS proc
	lea di,found ;di = found array
	jmp G2
G1:
	prtStr invalid ;call prtStr macro passing invalid
G2:
	prtStr prompt ;call prtStr macro passing prompt
	call indec ;input from user
	;checking for invalid input (out of bounds)
	cmp ax,1
	jl G1
	cmp ax,16
	jg G1
	;subtract one and double entered value for addressing purposes
	sub ax,1
	mov bx,2
	mul bx
	;checking for invalid input (already matched or chosen)
	add di,ax
	mov bx,[di]
	sub di,ax ;revert addition in case it is invalid
	cmp bx,0
	jne G1
	;set found to 1 to display the card
	add di,ax
	mov bx,1
	mov [di],bx
	ret
GUESS endp

;check the user guesses for a matching pair
CHECK proc
	lea si,board ;si = board array
	;translating addresses in the guess variables to respective data in board array
	mov ax,guess1
	add si,ax
	mov bx,[si]
	sub si,ax
	mov ax,guess2
	add si,ax
	mov ax,[si]
	;compare board data
	cmp ax,bx
	je C1
	jne C2
C1: ;match
	prtStr match ;call prtStr macro passing match
	inc turns
	inc matches
	;skip pause once game is won
	cmp matches,8
	jne C3
	ret
C2: ;no match
	prtStr nomatch ;call prtStr macro passing nomatch
	inc turns
	;set found to 0 to hide the cards
	lea di,found
	mov ax,guess1
	add di,ax
	mov bx,0
	mov [di],bx
	sub di,ax
	mov ax,guess2
	add di,ax
	mov bx,0
	mov [di],bx
C3: ;pause before starting next turn
	prtStr reply ;call prtStr macro passing reply
	call indec ;input from user
	cmp ax,0
	jne C4
	prtStr quit ;call prtStr macro passing quit
	exit ;call exit macro
C4:
	ret
CHECK endp

;print win screen and number of turns
WON proc
	prtStr win ;call prtStr macro passing win
	prtStr prtTurns ;call prtStr macro passing prtTurns
	mov ax,turns
	call outdec ;print number of turns
	prtStr newline ;call prtStr macro passing newline
	ret
WON endp

end main