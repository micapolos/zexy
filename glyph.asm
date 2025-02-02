        ifndef  Glyph_asm
        define  Glyph_asm

        module  Glyph

; =========================================================
; Input
;   de - line addr
;   h - dst addr msb
;   c - width
;   .l - dst addr lsb
;   .val - value
Draw
.loop
        ld      a, (de)
        inc     de
.l+*    ld      l, 0            ; column
        ld      b, 8            ; bit counter
.lineLoop
        rlca
        jp      nc, .nextBit
.val+*  ld      (hl), 0         ; self-modified color
.nextBit
        inc     l
        djnz    .lineLoop

        inc     h
        dec     c
        jp      nz, .loop

        ret

        endmodule

        endif
