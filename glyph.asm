        ifndef  Glyph_asm
        define  Glyph_asm

        module  Glyph

; =========================================================
; Input
;   de - src line addr
;   hl - dst addr
;   bc - color / width
Draw
        ld      a, l
        ld      (.l), a
        ld      a, b
        ld      (.b), a
.loop
        ld      a, (de)
        inc     de
.l+*    ld      l, 0            ; self-modified offset
        ld      b, 8            ; bit counter
.lineLoop
        rlca
        jp      nc, .nextBit
.b+*    ld      (hl), 0         ; self-modified color
.nextBit
        inc     l
        djnz    .lineLoop

        inc     h
        dec     c
        jp      nz, .loop

        ret

        endmodule

        endif
