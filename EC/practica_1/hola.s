.section .data
msg: .string "¿hola,mundo!\n"
tam: .quad . - msg

.section .text 
main: .globl main
        call write
        call write
        call write
        call exit

write: mov $1, %rax #write
        mov $1, %rdi #stdout
        mov $msg, %rsi #texto
        mov tam, %rdx #tamaño
        syscall #llamada a write 
        ret

exit: mov $60, %rax #exit
        xor %rdi, %rdi 
        syscall
        ret
