        ifndef  Keymap_asm
        define  Keymap_asm

        module  Keymap

normal
.digits
        db '0', '1', '2', '3', '4',
        db '5', '6', '7', '8', '9',
.letters
        db 'a', 'b', 'c', 'd', 'e'
        db 'f', 'g', 'h', 'i', 'j'
        db 'k', 'l', 'm', 'n', 'o'
        db 'p', 'q', 'r', 's', 't'
        db 'u', 'v', 'w', 'x', 'y'
        db 'z'
.enter  db '\n'
.space  db ' '
.caps   db 0
.symb   db 0
.left   db 0
.right  db 0
.up     db 0
.down   db 0
.dot    db '.'
.comma  db ','
.quotes db $22
.graph  db 0
.edit   db 0
.inv    db 0
.true   db 0
.delete db 0
.break  db 0
.extend db 0
.capslk db 0
.symb   db 0
        assert $ - default = Key.count

caps
.digits
        db '0', '1', '2', '3', '4',
        db '5', '6', '7', '8', '9',
.letters
        db 'A', 'B', 'C', 'D', 'E'
        db 'F', 'G', 'H', 'I', 'J'
        db 'K', 'L', 'M', 'N', 'O'
        db 'P', 'Q', 'R', 'S', 'T'
        db 'U', 'V', 'W', 'X', 'Y'
        db 'Z'
.enter  db '\n'
.space  db ' '
.caps   db 0
.symb   db 0
.left   db 0
.right  db 0
.up     db 0
.down   db 0
.dot    db '.'
.comma  db ','
.quotes db $22
.graph  db 0
.edit   db 0
.inv    db 0
.true   db 0
.delete db 0
.break  db 0
.extend db 0
.capslk db 0
.symb   db 0
        assert $ - caps = Key.count

; Input
;   a - key
; Output
;   a - char
GetChar


        endmodule

        endif
