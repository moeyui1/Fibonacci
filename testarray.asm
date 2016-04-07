segment .data
	newLine	db  0xa
	newLine_length db $-newLine
array:	dd '1000','2','3','4',10000


segment .bss
    %macro write 2
        mov rax, 4
        mov rbx, 1
        mov rcx, %1
        mov rdx, %2
        int 80h
    %endmacro

    ; 实现读系统调用
    %macro read 2
        mov rax, 3
        mov rbx, 1
        mov rcx, %1
        mov rdx, %2
        int 80h
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


    segment .text
  global _start
_start:
            
            mov r10,1
	multen r10
        mov r10,rax
exit:
	mov rax ,1
	mov rbx,0
	int 80h
