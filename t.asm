section .data
    prompt_str db 'Enter you name',0xa
    ;$ 是地址游标, 记录当前指令地址
    STR_SIZE equ $ - prompt_str ;
    greet_str db 'hello',0xa
    ; equ 表达式赋值给变量的指令
    GSTR_SIZE equ $ - greet_str

; block storage segment -- 未初始化内存
; BSS 部分中保留的内存在程序启动时初始化为零
; BSS 部分中的对象只有一个名称和大小, 没有值
; BSS 部分中声明的变量并不实际占用空间
section .bss
    ; resb 在 BSS 节中分配字节 (byte-8)
    ; resw 在 BSS 节分配字 (word-16)
    ; resd 在 BSS 节分配双字 (dword-32)
    buff resb 64 ; 保留 64 字节在内存中

    ; 实现写系统调用
    ; 2 是参数个数
    ; %1 代表第一个参数
    ; %2 代表第二个参数 ...
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
section .text
    global _start
    _start:
        write prompt_str, STR_SIZE
        read buff, 64
        ; 在 rax 中读返回值长度
        push rax
        ; 打印 hello
        write greet_str, GSTR_SIZE
        pop rdx
        ; rdx = 长度通过 read 返回
    _exit:
        mov rax, 1
        mov rbx, 8
        int 80h
