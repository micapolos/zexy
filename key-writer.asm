        ifndef  KeyWriter_asm
        define  KeyWriter_asm

        include char.asm
        include writer.asm
        include key-event.asm

        module  KeyWriter

; =========================================================
; Input
;   ix - writer
;   de - KeyEvent
Put
        ld      a, d
        and     KeyEvent.keyDown
        ret     z

        ld      a, d
        and     KeyModifier.symbolShift
        jp      nz, .symb
.noSymb
        ld      a, d
        and     KeyModifier.capsShift
        jp      nz, .caps
.noCaps
        ld      hl, noCapsKeyMap
        jp      .lookup
.caps
        ld      hl, capsKeyMap
        jp      .lookup
.symb
        ld      hl, symbKeyMap
        jp      .lookup
.lookup
        ld      a, e
        add     hl, a
        ld      a, (hl)
        or      a
        ret     z               ; don't write char 0
        jp      Writer.Char

; =========================================================
noCapsKeyMap
        db      '0', '1', '2', '3', '4'
        db      '5', '6', '7', '8', '9'

        db      'a', 'b', 'c', 'd', 'e'
        db      'f', 'g', 'h', 'i', 'j'
        db      'k', 'l', 'm', 'n', 'o'
        db      'p', 'q', 'r', 's', 't'
        db      'u', 'v', 'w', 'x', 'y'
        db      'z'

.enter          db      Char.newLine
.space          db      Char.space
.caps           db      0
.symb           db      0
.left           db      0
.right          db      0
.up             db      0
.down           db      0
.dot            db      '.'
.comma          db      ','
.quotes         db      Char.quotes
.graph          db      0
.edit           db      0
.inv            db      0
.true           db      0
.delete         db      Char.backSpace
.break          db      0
.colon          db      ';'
.extend         db      0
.capslck        db      0

; =========================================================
capsKeyMap
        db      Char.backSpace, 0, 0, 0, 0
        db      0, 0, 0, 0, 0

        db      'A', 'B', 'C', 'D', 'E'
        db      'F', 'G', 'H', 'I', 'J'
        db      'K', 'L', 'M', 'N', 'O'
        db      'P', 'Q', 'R', 'S', 'T'
        db      'U', 'V', 'W', 'X', 'Y'
        db      'Z'

.enter          db      Char.newLine
.space          db      Char.space
.caps           db      0
.symb           db      0
.left           db      0
.right          db      0
.up             db      0
.down           db      0
.dot            db      '.'
.comma          db      ','
.quotes         db      Char.quotes
.graph          db      0
.edit           db      0
.inv            db      0
.true           db      0
.delete         db      Char.backSpace
.break          db      0
.colon          db      ';'
.extend         db      0
.capslck        db      0

; =========================================================
symbKeyMap
        db      '_', '!', '@', '#', '$'
        db      '%', '&', Char.quote, '(', ')'

        db      '~', '*', '?', '\', 0
        db      '{', '}', '^', 0, '-'
        db      '+', '=', '.', ',', ';'
        db      Char.quotes, 0, '<', '|', '>'
        db      ']', '/', 0, 0, '['
        db      ':'

.enter          db      Char.newLine
.space          db      Char.space
.caps           db      0
.symb           db      0
.left           db      0
.right          db      0
.up             db      0
.down           db      0
.dot            db      '.'
.comma          db      ','
.quotes         db      Char.quotes
.graph          db      0
.edit           db      0
.inv            db      0
.true           db      0
.delete         db      Char.backSpace
.break          db      0
.colon          db      ';'
.extend         db      0
.capslck        db      0

        endmodule

        endif
