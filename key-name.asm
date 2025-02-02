        ifndef  KeyName_asm
        define  KeyName_asm

        module  KeyName

; Input
;   a - key
; Output
;   hl - string ptr
String
        ld      hl, map
        rlca
        add     hl, a
        ld      de, (hl)
        ex      hl, de
        ret

string
.n0     dz "0"
.n1     dz "1"
.n2     dz "2"
.n3     dz "3"
.n4     dz "4"
.n5     dz "5"
.n6     dz "6"
.n7     dz "7"
.n8     dz "8"
.n9     dz "9"

.a      dz "A"
.b      dz "B"
.c      dz "C"
.d      dz "D"
.e      dz "E"
.f      dz "F"
.g      dz "G"
.h      dz "H"
.i      dz "I"
.j      dz "J"
.k      dz "K"
.l      dz "L"
.m      dz "M"
.n      dz "N"
.o      dz "O"
.p      dz "P"
.q      dz "Q"
.r      dz "R"
.s      dz "S"
.t      dz "T"
.u      dz "U"
.v      dz "V"
.w      dz "W"
.x      dz "X"
.y      dz "Y"
.z      dz "Z"

.enter  dz "Enter"
.space  dz "Space"
.caps   dz "Caps"
.symb   dz "Symb"
.left   dz "Left"
.right  dz "Right"
.up     dz "Up"
.down   dz "Down"
.dot    dz "."
.comma  dz ","
.quotes dz "\""
.graph  dz "Graph"
.edit   dz "Edit"
.inv    dz "Inv Video"
.true   dz "True Video"
.delete dz "Delete"
.break  dz "Break"
.extend dz "Extend"
.capslk dz "Caps Lock"

map
.n0     dw      string.n0
.n1     dw      string.n1
.n2     dw      string.n2
.n3     dw      string.n3
.n4     dw      string.n4
.n5     dw      string.n5
.n6     dw      string.n6
.n7     dw      string.n7
.n8     dw      string.n8
.n9     dw      string.n9

.a      dw      string.a
.b      dw      string.b
.c      dw      string.c
.d      dw      string.d
.e      dw      string.e
.f      dw      string.f
.g      dw      string.g
.h      dw      string.h
.i      dw      string.i
.j      dw      string.j
.k      dw      string.k
.l      dw      string.l
.m      dw      string.m
.n      dw      string.n
.o      dw      string.o
.p      dw      string.p
.q      dw      string.q
.r      dw      string.r
.s      dw      string.s
.t      dw      string.t
.u      dw      string.u
.v      dw      string.v
.w      dw      string.w
.x      dw      string.x
.y      dw      string.y
.z      dw      string.z

.enter  dw      string.enter
.space  dw      string.space
.caps   dw      string.caps
.symb   dw      string.symb
.left   dw      string.left
.right  dw      string.right
.up     dw      string.up
.down   dw      string.down
.dot    dw      string.dot
.comma  dw      string.comma
.quotes dw      string.quotes
.graph  dw      string.graph
.edit   dw      string.edit
.inv    dw      string.inv
.true   dw      string.true
.delete dw      string.delete
.break  dw      string.break
.extend dw      string.extend
.capslk dw      string.capslk

        endmodule

        endif
