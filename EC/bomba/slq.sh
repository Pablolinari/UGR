#!/bin/bash

gcc $1  -o "mibomba" -no-pie

gdb ./mibomba -ex "layout asm" -ex "layout regs" -ex "b main" -ex "run" -ex "set write on" -ex "set { char } 0x40130d=0xeb" -ex "set { char } 0x401323=0xeb" -ex "set { char } 0x401323=0xeb" -ex "set { char } 0x401323=0xeb" -ex "set { char } 0x401323=0xeb"


