section .text
	mov rbp,  55
	mov rsp ,  55
	mov r8  ,55
	mov r9 ,55
	mov r10,  55
	mov r11 ,55
	mov r12  ,55

	mov r13 ,55

	mov r14  ,55
	mov r15 ,55



	mov rax, 4
        mov rbx, 1
        mov rcx,str
        mov rdx, 5
        int 80h

  exit:      mov rax,0
        mov rbx,1
        int 80h


       section .data
       str: db 'hello'