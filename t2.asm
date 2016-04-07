segment .data
	; Declare/store the information "Hello World!" 
	prompt db 'What is your name? '
	promptLength equ $-prompt ; = (current address) – (address of prompt)
	; do not change the order of the following three lines!
	helloMsg db 'Hello '
	helloMsgLength equ $-helloMsg
	endOfLine db '!',0xA
	; do not change the order of the previous three lines!
	endOfLineLength equ $-endOfLine

segment .bss
	name: resb 8
		
segment .text
	
	global _start
	
	_start:
	
		; Output that information 'What is your name? '
		mov rax, 4	; write…
		mov rbx, 1	; to the standard output (screen/console)…
		mov rcx, prompt	; the information at memory address prompt
		mov rdx, promptLength	; 19 bytes (characters) of that information
		int 80h	; invoke an interrupt
	
		; Accept input and store the user's name
		mov rax, 3	; read…
		mov rbx, 1	; from the standard input (keyboard/console)…
		mov rcx, name	; storing at memory location name…
		mov rdx, 8	; 8 bytes (characters) of that information
		int 80h
	
		; Output that information "Hello…"
		mov rax, 4        ; write…
		mov rbx, 1        ; to the standard output (screen/console)…
		mov rcx, helloMsg ; the information at helloMsg…
		mov rdx, helloMsgLength       ; 16 bytes (characters) of that information…
			          ; (but isn't helloMsg only 6 bytes?)
		int 80h
	

		mov rsi, name	; initialize the source index
	
	loopAgain:
		mov al, [esi]	; al is a 1 byte register
		cmp al, 0xA	; if al holds an ASCII new line…
		je exitLoop	; then jump to label exitLoop
		
		; if al does not hold an ASCII new line…
		mov rax, 4	; write…
		mov rbx, 1	; to standard output…
		mov rcx, rsi	; the information at address esi..
		mov rdx, 1	; 1 byte (character) of that information
		int 80h
		
		add rsi, 1	; you could also use the inc instruction
		
		cmp rsi, name+8 ; see if esi is pointing past the
		                ; end of the 8 reserved bytes
		jl loopAgain
		
	exitLoop:		; the label to which the je above jumps
		
		; Output that information "!",0xA
		mov rax, 4               ; write…
		mov rbx, 1               ; to the standard output (screen/console)…
		mov rcx, endOfLine       ; the information at helloMsg…
		mov rdx, endOfLineLength ; length of that information in bytes…
				; 	(but isn't helloMsg only 6 bytes?)
		int 80h





		; Exit
		mov rax, 1	; sys_exit
		mov rbx, 0	; exit status. 0 means "normal",
                                ; while 1 means "error"
				; see http://en.wikipedia.org/wiki/Exit_status
		int 80h
