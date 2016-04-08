global 	_start:
section 	.data
	overData: 	dq 	0x7FFFFFFFFFFFFFFF
	staticover:	dq 	0x7FFFFFFFFFFFFFFF
	counter:	dq 	1
	counter1: 	dq 	0
    	counter2: 	dq 	0
    	counter2_o:	dq	1
	newLine	db  	0xa
	newLine_length equ 	$-newLine

	;'[1,37mtext'
	testnum: 	db 	"5"
	cvarnum:	db	1

	setcolor :	db 	1Bh, '['
	cvar1:		db	'0'
			db	';3'
	cvar2:		db 	'1'
			db	'm'
	num_p:		db	'0'  
    	len 		equ 	$ - setcolor
section .bss


	%macro	writecolor 	 1
	push 	rdx
    	push 	rdi
    	push 	rsi	
    	mov 	rsi,	%1
    	; lodsb
    	; add 	rax,	'0'
    	mov 	rdi, 	num_p
    	; stosb
    	movsb

 ;--------change color----------
 	mov 	rsi,	cvarnum
 	lodsb
 	cmp 	rax,	7
 	jb 	fcolor%1
 	mov 	rdi,	8
 	mov 	rdx, 	0
 	div 	rdi
 	mov 	rdi,	cvar1
 	add 	rax, 	'0'
 	stosb
 	mov 	rax,	rdx
 fcolor%1:
 	mov 	rdi,	cvar2
 	add 	rax, 	'0'
 	stosb
 ;--------write---------
	mov 	rax, 	4
        	mov 	rbx, 	1
        	mov 	rcx, 	setcolor
        	mov 	rdx, 	len
        	int 	80h
        	pop 	rsi
        	pop 	rdi
        	pop 	rdx
    	%endmacro


   	 ; 实现读系统调用
 	%macro read 2
        	mov 	rax, 	3
        	mov 	rbx, 	1
        	mov 	rcx, 	%1
        	mov 	rdx, 	%2
        	int 	80h
    	%endmacro

	%macro	write 	 2
	mov 	rax, 	4
        	mov 	rbx, 	1
        	mov 	rcx, 	%1
        	mov 	rdx, 	%2
        	int 	80h
    	%endmacro

    	    ;mul 10
     	%macro multen 1
     	mov 	rax,	%1
     	push	r10
     	mov	r10,	10
     	mul 	r10
     	pop	r10
   	%endmacro

    ;div 10
     	%macro divten 1
     	mov 	rax,	%1  
     	push 	rdx
     	push 	r10
     	mov 	r10,	10    ;r10=10 
     	mov 	rdx,	0
     	div 	r10
     	pop 	r10
     	pop 	rdx
   	%endmacro

	temp: 	resq 	1	;where we stored dig we will print	
    	fibnum1: 	resq 	1
    	fibnum2: 	resq 	1
    	fibnum2_o: 	resq 	1
    	result:	resb 	64
    	input : 	resb 	64
    	num: 	resw 	64

section 	.text
_start:
;-----------------start reading---------------
	mov 	rax,	3
	mov 	rbx,	1
	mov 	rcx, 	input
	mov 	rdx, 	64
	int 	80h

	mov 	rsi, 	input
	mov 	rdi,	num
	push 	rdi
	mov 	r13,	" "
	push 	r13
readInput:
	;mov rax,rsi
	lodsb 
	cmp 	rax,	0xa    ; if rax holds a new line
	je    	endMark
	
	cmp 	rax,	" "	;rax==" "
	je 	generate
	cmp 	rax, 	'0'    
	jb      	readInput     	;rax<'0'
	cmp 	rax, 	'9'
	ja     	readInput     		;rax>'9'
	sub 	rax,	'0'
	push 	rax
	jmp 	readInput
endMark:
	mov 	r12,	"e"
generate:
	mov 	rax,	" "
	;push rax
	mov 	r9,	1
	mov 	r10,	0 ;r10 stored the sum
construction:
	pop 	rax
	cmp 	rax ,	" "
	je 	exitCon
	mul 	r9
	add 	r10,	rax
	multen 	r9
	mov 	r9,	rax
	jmp 	construction
exitCon:
	pop 	rdi
	mov 	rax,	r10
	
	stosw
	push 	rdi
	cmp 	r12,	'e'
	je 	exitRead

	push 	rdi


	mov 	rax,	 " "
	push 	rax
	jmp 	readInput

exitRead:
	pop 	rdi
	mov 	rax, 	0
	stosw


;----------------start fb cal-------------------
	; mov 	rsi, 	1    ;counter
	; push 	rsi		;stack p1
	mov 	qword[fibnum1],	0

	mov 	qword[fibnum2],	1
	
	jmp	calLong 
		
exit:
	mov 	rax, 	1
    	xor 	rbx, 	rbx
    	int 	80h


calLong:
	;----------init overdata-----------------
	mov 	rax,	qword[staticover]
	mov 	qword[overData],	rax
	;----------move to reg------------------
	mov 	rcx,	qword[counter2]	;backup fb2
	mov 	qword[counter2_o],	rcx	;backup fb2
	mov 	rcx, 	qword[fibnum1]
	mov 	rbx, 	qword[fibnum2]
	mov 	qword[fibnum2_o],	rbx	;backup fb2

	;----------print f(1)--------------
	; cmp 	qword[counter],		1
	; jne 	notfone
	; writecolor	fibnum2
	; write 	newLine,	newLine_length
	
notfone:
	mov 	r10,	rbx

	;-----------if the result is overFlow--------
	; mov 	qword[fibnum1],	rbx
	add 	rbx,	rcx
	cmp 	rbx,	qword[staticover]
	jb 	backover

;----------handleoverflow---------
handleoverflow:
	mov 	rbx,	r10
	inc 	qword[counter2]	
	sub 	rbx,	qword[staticover]
	; mov 	qword[fibnum1],	rbx
	add 	rbx,	rcx
	
backover:
	mov 	qword[fibnum2],	rbx
	mov 	rax,	qword[fibnum2]
	mov 	qword[result],	rax
	;---------change fb1------------------
	mov 	rax,	qword[fibnum2_o]
	mov 	qword[fibnum1],	rax
	mov 	rax,	qword[counter2_o]
	mov 	rbx,	qword[counter1]
	add 	qword[counter2],	rbx
	mov 	qword[counter1],	rax

	mov 	rax,	'e'
	push 	rax		;a sign of end
	cmp 	qword[counter2],	0
	jne 	notclear
	mov 	qword[overData],	0

notclear:

	add 	qword[counter],		1

	mov 	rsi,	qword[counter]

back:	
	cmp 	rsi, 	500
	je 	exit  		; if  rsi>=92,exit   
	mov 	r10,	rsi	; r10=rsi=counter
;-----------jude if we should printResult-------
	mov 	rsi, 	num

jude:	
	lodsw
	cmp 	rax,	0
	je 	calLong
	cmp 	r10, 	rax
	jne 	jude
		

;------------division--------------
divi:
	mov 	rax, 	qword[overData]
	mov 	rbx,	10
	mov 	rdx, 	0
	div 	rbx
	mov 	qword[overData], 	rax
	push 	rdx		;save remaider

	
	;----------handle it---------
	mov 	rax,	qword[result]
	mov 	r8,	10
	mov 	rdx,	0
	div 	r8
	mov 	qword[result],	rax



	
	;------handle rdx-------
	pop 	rax
	mov 	r8,	rdx
	mul 	qword[counter2]
	add 	rax,	r8
	mov 	r8,	10
	mov 	rdx,	0
	div 	r8
SaveRemainder:
	push 	rdx		;save remaider
	add 	qword[result],	rax
		
	cmp 	qword[overData],	0
	jne 	divi

	cmp 	qword[result],	0
	jne 	divi

;---------------printFb------------
printfb:
	pop 	qword[temp]
	cmp 	qword[temp],	'e'
	je 	afterPrint
	add 	qword[temp],	'0'
	writecolor temp
	jmp 	printfb
afterPrint:
	write 	newLine,	newLine_length
	inc 	qword[cvarnum]
	jmp 	calLong
