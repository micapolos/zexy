        ifndef  Glyph_asm
        define  Glyph_asm

        module  Glyph

; =========================================================
; Input
;   de - glyph addr
;   h - row base addr
;   .x - x coord
;   .h - height
;   .w - width
;   .v - value
Draw
.h+*    ld      c, 0            ; row counter
.loop
        ld      a, (de)
        inc     de
.x+*    ld      l, 0            ; column
.w+*    ld      b, 0            ; bit counter
.lineLoop
        rlca
        jp      nc, .nextBit
.v+*    ld      (hl), 0         ; self-modified color
.nextBit
        inc     l
        djnz    .lineLoop

        inc     h
        dec     c
        jp      nz, .loop

        ret

        endmodule

        endif
