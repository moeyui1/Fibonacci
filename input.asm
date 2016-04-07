section .bss
	input : resb 64

	num: resw 64
	    ;mul 10
     %macro multen 1
     mov rax,%1
     push r10
     mov r10,10
     mul r10
     pop r10
   %endmacro

       %macro write 2
        mov rax, 4
        mov rbx, 1
        mov rcx, %1
        mov rdx, %2
        int 80h
    %endmacro
section .text
	  global _start
_start:
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
	cmp r12,'e'
	je exitRead

	push rdi


	mov rax, " "
	push rax
	jmp readInput



exitRead:
	


exit:
	mov rax,1
	mov rbx,0
	int    80h