        ifndef  KeyWriter_asm
        define  KeyWriter_asm

        include char.asm
        include writer.asm
        include key-event.asm
        include key-modifier.asm

        struct  KeyWriter
; delay after first press
initialDelay            db      $00
; repeat delay
repeatDelay             db      $00
; bit 7: 1 = key pressed, 0 = no key pressed
; bit 6..0: pressed key
repeatKey               db      $00
; counter for delays
delayCounter            db      $00
        ends

        module  KeyWriter

; =========================================================
; Input
;   hl - KeyWriter ptr
;   de - repeat / delay
; Output
;   hl - advanced KeyWriter ptr
Init
        ldi     (hl), de        ; delay / repeat
        ldi     (hl), 0         ; repeat key
        ldi     (hl), 0         ; counter
        ret

; =========================================================
; Input
;   hl - KeyWriter ptr
;   ix - Writer ptr
; Output
;   hl - advanced KeyWriter ptr
Update
        ldi     de, (hl)        ; de = repeatDelay / initialDelay
        ldi     c, (hl)         ; c = repeatKey
        ld      b, (hl)         ; b = delayCounter

        ; return if no repeat key is pressed
        ld      a, c
        and     %10000000
        ret     z

        ret

; =========================================================
; Input
;   hl - KeyWriter ptr
;   de - KeyEvent
;   ix - Writer ptr
; Output
;   hl - advanced KeyWriter ptr
HandleKeyEvent
        ldi     bc, (hl)                ; bc = repeatDelay / initialDelay

        ld      a, d                    ; a = KeyModifier
        and     KeyEvent.keyDown        ; check for keyDown
        jp      nz, .keyDown
.keyUp
        ; compare with repeatKey
        ld      a, e
        cp      (hl)
        jp      nz, .keyUpCont          ; key current repeatKey if keyUp is different
        ld      (hl), 0                 ; reset repeatKey if keyUp is the same
.keyUpCont
        inc     hl
        inc     hl
        ret

.keyDown
        push    hl
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
        ; read key
        ld      a, e
        add     hl, a
        ld      a, (hl)
        or      a
        jp      z, .noChar

        push    bc
        push    de
        call    Writer.Char
        pop     de
        pop     bc

        pop     hl
        ld      a, e                    ; a = pressed key
        or      %10000000               ; keyRepeat pressed flag
        ldi     (hl), a                 ; repeatKey = a with repeat flag
        ldi     (hl), c                 ; delayCounter = initialDelay
        ret

.noChar
        pop     hl
        inc     hl
        inc     hl
        ret

; =========================================================
@noCapsKeyMap
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
@capsKeyMap
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
@symbKeyMap
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
