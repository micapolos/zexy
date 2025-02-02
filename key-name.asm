        ifndef  KeyName_asm
        define  KeyName_asm

        module  KeyName

; =========================================================
; Input
;   a - key
; Output
;   a - char
GetChar
        ld      hl, charMap
        add     hl, a
        ld      a, (hl)
        ret

; =========================================================
; Input
;   a - key
; Output
;   hl - string ptr
GetString
        ld      hl, stringMap
        rlca
        add     hl, a
        ld      de, (hl)
        ex      hl, de
        ret

; =========================================================

charMap
.n0     db '0'
.n1     db '1'
.n2     db '2'
.n3     db '3'
.n4     db '4'
.n5     db '5'
.n6     db '6'
.n7     db '7'
.n8     db '8'
.n9     db '9'

.a      db 'A'
.b      db 'B'
.c      db 'C'
.d      db 'D'
.e      db 'E'
.f      db 'F'
.g      db 'G'
.h      db 'H'
.i      db 'I'
.j      db 'J'
.k      db 'K'
.l      db 'L'
.m      db 'M'
.n      db 'N'
.o      db 'O'
.p      db 'P'
.q      db 'Q'
.r      db 'R'
.s      db 'S'
.t      db 'T'
.u      db 'U'
.v      db 'V'
.w      db 'W'
.x      db 'X'
.y      db 'Y'
.z      db 'Z'

.enter  db '*'
.space  db '*'
.caps   db '*'
.symb   db '*'
.left   db '*'
.right  db '*'
.up     db '*'
.down   db '*'
.dot    db '.'
.comma  db ','
.quotes db '\"'
.graph  db '*'
.edit   db '*'
.inv    db '*'
.true   db '*'
.delete db '*'
.break  db '*'
.colon  db ';'
.extend db '*'
.capslk db '*'

; =========================================================

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
.caps   dz "Caps shift"
.symb   dz "Symbol shift"
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
.colon  dz ";"
.extend dz "Extend mode"
.capslk dz "Caps Lock"

; =========================================================

stringMap
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
.colon  dw      string.colon
.extend dw      string.extend
.capslk dw      string.capslk

        endmodule

        endif
