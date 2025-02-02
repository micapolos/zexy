        ifndef  Key_asm
        define  Key_asm

        include key-code.asm

        module  Key

n0      equ     $00
n1      equ     $01
n2      equ     $02
n3      equ     $03
n4      equ     $04
n5      equ     $05
n6      equ     $06
n7      equ     $07
n8      equ     $08
n9      equ     $09

a       equ     $0a
b       equ     $0b
c       equ     $0c
d       equ     $0d
e       equ     $0e
f       equ     $0f
g       equ     $10
h       equ     $11
i       equ     $12
j       equ     $13
k       equ     $14
l       equ     $15
m       equ     $16
n       equ     $17
o       equ     $18
p       equ     $19
q       equ     $1a
r       equ     $1b
s       equ     $1c
t       equ     $1d
u       equ     $1e
v       equ     $1f
w       equ     $20
x       equ     $21
y       equ     $22
z       equ     $23

enter   equ     $24
space   equ     $25
caps    equ     $26
symb    equ     $27
left    equ     $28
right   equ     $29
up      equ     $2a
down    equ     $2b
dot     equ     $2c
comma   equ     $2d
quotes  equ     $2e
graph   equ     $2f
edit    equ     $30
inv     equ     $31
true    equ     $32
delete  equ     $33
break   equ     $34
colon   equ     $35
extend  equ     $36
capslck equ     $37

count   equ     $38

codes
.n0     dw      KeyCode.n0
.n1     dw      KeyCode.n1
.n2     dw      KeyCode.n2
.n3     dw      KeyCode.n3
.n4     dw      KeyCode.n4
.n5     dw      KeyCode.n5
.n6     dw      KeyCode.n6
.n7     dw      KeyCode.n7
.n8     dw      KeyCode.n8
.n9     dw      KeyCode.n9

.a      dw      KeyCode.a
.b      dw      KeyCode.b
.c      dw      KeyCode.c
.d      dw      KeyCode.d
.e      dw      KeyCode.e
.f      dw      KeyCode.f
.g      dw      KeyCode.g
.h      dw      KeyCode.h
.i      dw      KeyCode.i
.j      dw      KeyCode.j
.k      dw      KeyCode.k
.l      dw      KeyCode.l
.m      dw      KeyCode.m
.n      dw      KeyCode.n
.o      dw      KeyCode.o
.p      dw      KeyCode.p
.q      dw      KeyCode.q
.r      dw      KeyCode.r
.s      dw      KeyCode.s
.t      dw      KeyCode.t
.u      dw      KeyCode.u
.v      dw      KeyCode.v
.w      dw      KeyCode.w
.x      dw      KeyCode.x
.y      dw      KeyCode.y
.z      dw      KeyCode.z

.enter  dw      KeyCode.enter
.space  dw      KeyCode.space
.caps   dw      KeyCode.caps
.symb   dw      KeyCode.symb
.left   dw      KeyCode.left
.right  dw      KeyCode.right
.up     dw      KeyCode.up
.down   dw      KeyCode.down
.dot    dw      KeyCode.dot
.comma  dw      KeyCode.comma
.quotes dw      KeyCode.quotes
.graph  dw      KeyCode.graph
.edit   dw      KeyCode.edit
.inv    dw      KeyCode.invVideo
.true   dw      KeyCode.trueVideo
.delete dw      KeyCode.delete
.break  dw      KeyCode.break
.colon  dw      KeyCode.colon
.extend dw      KeyCode.extend
.capslk dw      KeyCode.capslock

; =========================================================
; Input
;   a - key
; Output
;   de - keycode
GetCode
        ld      hl, codes
        rlca
        add     hl, a
        ld      de, (hl)
        ret

        endmodule

        endif
