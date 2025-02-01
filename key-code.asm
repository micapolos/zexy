        ifndef  KeyCode_asm
        define  KeyCode_asm

        module  KeyCode

; MSB - line index
; LSB - key mask
b       equ     $0010
n       equ     $0008
m       equ     $0004
symb    equ     $0002
space   equ     $0001

h       equ     $0110
j       equ     $0108
k       equ     $0104
l       equ     $0102
enter   equ     $0101

y       equ     $0210
u       equ     $0208
i       equ     $0204
o       equ     $0202
p       equ     $0201

k6      equ     $0310
k7      equ     $0308
k8      equ     $0304
k9      equ     $0302
k0      equ     $0301

k5      equ     $0410
k4      equ     $0408
k3      equ     $0404
k2      equ     $0402
k1      equ     $0401

t       equ     $0510
r       equ     $0508
e       equ     $0504
w       equ     $0502
q       equ     $0501

g       equ     $0610
f       equ     $0608
d       equ     $0604
s       equ     $0602
a       equ     $0601

v       equ     $0710
c       equ     $0708
x       equ     $0704
z       equ     $0702
caps    equ     $0701

colon           equ     $0880
quotes          equ     $0840
comma           equ     $0820
dot             equ     $0810
up              equ     $0808
down            equ     $0804
left            equ     $0802
right           equ     $0801

delete          equ     $0880
edit            equ     $0840
break           equ     $0820
invVideo        equ     $0810
trueVideo       equ     $0808
graph           equ     $0804
capslock        equ     $0802
extend          equ     $0801

.ext

        endmodule

        endif
