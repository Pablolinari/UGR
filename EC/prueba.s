.section .data
lista:
    .int 2,-2,0x10,3,-3

longlista:
    .int (.-lista)/4

resultado:
    .quad 0

formato:
    .asciz "suma = %ld (sign) = 0x%lx hex\n"

.section .text

main: .global main

xor %rcx,%rcx
inc %cl
inc %cl
shl %cl,%rcx
mov lista,%ebx
lea (%rbx,%rcx,2),%rdx

