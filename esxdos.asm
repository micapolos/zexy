        ifndef  esxDOS_asm
        define  esxDOS_asm

        module  EsxDOS

getSetDrv       equ     $89
getCwd          equ     $a8
open            equ     $9a
close           equ     $9b
read            equ     $9d
openDir         equ     $a3
readDir         equ     $a4
p3dos           equ     $94

        endmodule

        endif
