

#!/bin/bash

gcc -g -no-pie $1 -o yo

gdb "yo" -ex "b main"  -ex "layout regs" -ex "run"


