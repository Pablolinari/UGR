.section .data
num: .int 45
msg: .string "Hola"

main: .global main

write:
    mov $1, %rax
    mov $1, %rdi
    mov $num
