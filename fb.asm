segment .data
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
segment .bss

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
 	jb 	fcolor
 	mov 	rdi,	8
 	mov 	rdx, 	0
 	div 	rdi
 	mov 	rdi,	cvar1
 	add 	rax, 	'0'
 	stosb
 	mov 	rax,	rdx
 fcolor:
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

	%macro	write 	 2
	mov 	rax, 	4
        	mov 	rbx, 	1
        	mov 	rcx, 	%1
        	mov 	rdx, 	%2
        	int 	80h
    	%endmacro

    	%macro	write 	 3
    	push 	r10
    	mov 	r10, 	%3
	mov 	rax, 	4
        	mov 	rbx, 	1
        	mov 	rcx, 	%1
        	mov 	rdx, 	%2
        	int 	80h
        	pop 	r10
    	%endmacro

    ; 实现读系统调用
 	%macro read 2
        	mov 	rax, 	3
        	mov 	rbx, 	1
        	mov 	rcx, 	%1
        	mov 	rdx, 	%2
        	int 	80h
    	%endmacro


    ;mul 10
     	%macro multen 1
     	mov rax,%1
     	push r10
     	mov r10,10
     	mul r10
     	pop r10
   	%endmacro

    ;div 10
     %macro divten 1
     mov rax,%1  
     push rdx
     push r10
     mov r10,10    ;r10=10 
     mov rdx,0
     div r10
     pop r10
     pop rdx
   %endmacro


    	buff resb 64

 	temp: resb 2	;where we stored dig we will print

    ;counter1: resb 64
    ;counter2: resb 64

    result:resb 64
    input : resb 64
    num: resw 64

segment .text
  global _start
_start:






	
	;-----------------start reading---------------
	mov rax, 3
	mov rbx,1
	mov rcx, input
	mov rdx, 64
	int 80h

	mov rsi, input
	mov rdi,num
	push rdi
	mov r13," "
	push r13
readInput:
	;mov rax,rsi
	lodsb 
	cmp rax, 0xa    ; if rax holds a new line
	je    endMark
	
	cmp rax," "	;rax==" "
	je generate
	cmp rax, '0'    
	jb      readInput     	;rax<'0'
	cmp rax, '9'
	ja     readInput     		;rax>'9'
	sub rax,'0'
	push rax
	jmp readInput
endMark:
	mov r12,"e"
generate:
	mov rax," "
	;push rax
	mov r9,1
	mov r10,0 ;r10 stored the sum
construction:
	pop rax
	cmp rax ," "
	je exitCon
	mul r9
	add r10,rax
	multen r9
	mov r9,rax
	jmp construction
exitCon:
	pop rdi
	mov rax,r10
	
	stosw
	push 	rdi
	cmp r12,'e'
	je exitRead

	push rdi


	mov rax, " "
	push rax
	jmp readInput



exitRead:
	pop 	rdi
	mov 	rax, 	0
	stosw






	;-------------------start fb cal-------------------
	;mov rsi,0
	mov 	rsi, 	1    ;counter
	push 	rsi		;stack p1
	; push 	rsi		;yes, we have to push twice ,stack p2
	mov 	r15,	0
	mov 	r12,	1
	


	





loop:
	pop 	rsi		;stack r1
	;add r15,'0'
	mov 	rdx,	0	
	mov 	r13,	10
	mov rax,rsi
	div r13
	mov r13, rax
	add r13,'0'
	mov r14,rdx
	add r14,'0'



	mov [temp], r13
	;add byte [temp], '0'
	;add r15,byte [temp]

	;mov  [counter1] ,r15
	;add r15,rsi
	;write temp, 1;write count 
	mov [temp],r14
	;write temp,1

	;write newLine, 1

	;mov rcx,0
	;mov [buff],rcx
cal:	push r12	;save the f(n-1),stack p3
	add r12,r15	;get f(n)
	push r12	;save the f(n),stack p4
	add r12,'0'	;


	mov [buff], r12
	;write buff, 64
	;write newLine, 1
		
restored:
	pop 	r12		;stack r4
	pop 	r15		;stack r3



	; pop 	rsi		;stack r1
	add 	rsi, 	1
	push 	rsi		;stack p1
	
back:	

	cmp 	rsi, 	92
	je 	exit  		; if  rsi>=92,exit   
	mov 	r10,	rsi	; r10=rsi=counter
;-----------jude if we should printResult-------
	mov 	rsi, 	num

jude:	
	lodsw
	cmp 	rax,	0
	je 	loop
	cmp 	r10, 	rax
	je 	printResult
	jmp 	jude	

	
exit:
	mov 	rax ,1
	mov 	rbx ,0
	int 	80h





;---------------print the result-----------------
printResult:
	mov 	rbx,	0
	;mov rsi, array
	mov 	r10,	1

	;-------cmp r12 and r10
find:
	
	;LODSD
	cmp	 r12,	r10
	jna 	endoffind    ;r12<=r10

	; mov rax,10    ;rax=10
	; mul r10    ;rax=rax*r10
	; mov r10,rax    ;r10=rax
	multen 	r10
	mov 	r10,	rax
	jmp 	find

endoffind:
	je prepbd    ;r12=r10


	; r10 / 10
	divten 	r10
	mov 	r10,	rax
prepbd:
	mov 	rdx,	r12
pbd: 
	push 	r10

	mov 	rax,	rdx
	mov 	rdx,	0     ;must clear rdx
	div  	r10
	add 	rax,	'0'
	mov 	[temp],	rax

	push 	rdx
	; mov 	rdi,	cvarnum
	; lodsb
	writecolor 	temp
	pop 	rdx
	
	pop 	r10
	cmp 	r10,	1
	je 	numover
	push 	rdx
	divten 	r10   ; r10/10
	mov 	r10,	rax
	pop 	rdx  
	jmp 	pbd    ;r10>1
numover:
	push 	rsi
;----------change color var----------
	mov 	rsi, 	cvarnum
	lodsb
	inc 	rax
	mov 	rdi, 	cvarnum
	stosb
	pop 	rsi
	write 	newLine,	1
	
	jmp	loop
;--------------end of printResult------------