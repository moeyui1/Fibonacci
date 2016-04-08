
global _start

section .data
;'[1,37mtext'
                
	testnum: 	dq 	0x7FFFFFFFFFFFFFFF
	cvarnum:	db	1

	setcolor :	db 	1Bh, '['
	cvar1:		db	'0'
			db	';3'
	cvar2:		db 	'1'
			db	'm'
	num_p:		db	'0'  
    	len 		equ 	$ - setcolor

section .bss
	%macro	write 	 1
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
 	inc 	rax
 	sub 	rax, 	'0'
 	mov 	rdi,	cvarnum
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



section .text
_start:
	; mov 	rax,	'12'
	; mov 	rdi,	num_p
	; stosq
	; mov rax, 4
 ;    	mov rbx, 1
 ;    	mov rcx, setcolor
 ;    	mov rdx, len
 ;    	int 	80h
 ; 	mov 	r10,	11
 ; 	push 	r10
 ; debug:	
 ; 	write 	testnum
 ; 	pop 	r10
 ; 	sub 	r10,	1
 ; 	cmp 	r10,	0
 ; 	push 	r10
 ; 	jne 	debug

            mov  r10,   	-100
            mov r11,	2
            add 	r10,	r11

exit:
	mov rax, 1
    	xor rbx, rbx
    	int 80h
