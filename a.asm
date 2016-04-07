section     .text
global      _start                              ;must be declared for linker (ld)

_start:                                         ;tell linker entry point


    mov rax ,5
    mov r8,1
    div r8
exit:
    mov rax,1
    mov rbx,0;
    int 80h