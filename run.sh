set -e
sjasmplus --lst --zxnext main.asm
cspect main.nex
