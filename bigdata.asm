global 	_start:
section 	.data

section 	.text
_start:
	mov 	r8,	0x7FFFFFFFFFFFFFFF
	inc 	r8
	
	inc 	r8
exit:
	mov rax, 1
    	xor rbx, rbx
    	int 80h
