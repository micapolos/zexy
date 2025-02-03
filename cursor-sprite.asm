        ifndef  CursorSprite_asm
        define  CursorSprite_asm

        include cursor.asm
        include sprite.asm

        module  CursorSprite

; Input
;   hl - Cursor ptr
;   de - Sprite ptr
; Output
;   hl - advanced Cursor ptr
;   de - advanced Sprite ptr
Sync
        inc     hl              ; skip Cursor.blinkPeriod
        inc     hl              ; skip Cursor.blinkCounter
        ldi     b, (hl)         ; read Cursor.flags
        ldi     a, (hl)         ; read Cursor.x
        ldi     (de), a         ; write Sprite.attr0
        ldi     a, (hl)         ; read Cursor.y
        ldi     (de), a         ; write Sprite.attr1
        ld      a, (de)         ; read Sprite.attr2
        and     %11111110       ; clear x msb
        ld      c, a            ; store in c
        ld      a, b            ; retrieve xMsb from b
        and     Cursor.flag.xMsb
        or      c               ; combine with c
        ldi     (de), a         ; write Sprite.attr2
        ld      a, b            ; extract visible flag
        and     Cursor.flag.visible
        ld      b, a
        ld      a, (de)         ; read Sprite.attr3
        and     %01111111       ; mask-out Sprite visible flag
        or      b               ; combine with cursor visible flag
        ldi     (de), a         ; write Sprite.attr3
        inc     de              ; skip Sprite.attr4
        ret

; =========================================================
; Input
;   a - sprite index
LoadPattern
        ld      hl, pattern
        ld      bc, pattern.size
        jp      Sprite.LoadPattern

pattern
        dh      "0000000000000000"
        dh      "0000000000000000"
        dh      "0000000000000000"
        dh      "0000000000000000"
        dh      "0000000000000000"
        dh      "0000000000000000"
        dh      "0000000000000000"
        dh      "0000000000000000"
        dh      "1100000000000000"
        dh      "1100000000000000"
        dh      "1100000000000000"
        dh      "1100000000000000"
        dh      "1100000000000000"
        dh      "1100000000000000"
        dh      "1100000000000000"
        dh      "1100000000000000"
.size   equ     $ - pattern

        endmodule

        endif
