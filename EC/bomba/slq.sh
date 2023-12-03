#!/bin/bash

gcc $1  -o "mibomba" -no-pie

gdb ./mibomba -e "layout asm" -e "layout regs" -e "b main" -e "run" -e "set write on" -e "set { char } 0x40130d=0xeb" -e "set { char } 0x401323=0xeb" -e "set { char } 0x401323=0xeb" -e "set { char } 0x401323=0xeb" -e"set { char } 0x401323=0xeb"



