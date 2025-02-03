        ifndef  Glyph_asm
        define  Glyph_asm

        module  Glyph

; =========================================================
; Input
;   de - src line addr
;   hl - dst addr MSB
;   bc - bit 1 value / row count
Draw
        ld      a, l
        ld      (DrawFast.l), a
        ; fall-through

; =========================================================
; Input
;   de - src line addr
;   h - dst addr MSB
;   .l - dst addr LSB
;   bc - bit 1 value / row count
DrawFast
.loop
        ld      a, (de)
        inc     de
.bit7
.l+*    ld      l, 0            ; self-modified code
        rlca
        jp      nc, .bit6
        ld      (hl), b
.bit6
        inc     l
        rlca
        jp      nc, .bit5
        ld      (hl), b
.bit5
        inc     l
        rlca
        jp      nc, .bit4
        ld      (hl), b
.bit4
        inc     l
        rlca
        jp      nc, .bit3
        ld      (hl), b
.bit3
        inc     l
        rlca
        jp      nc, .bit2
        ld      (hl), b
.bit2
        inc     l
        rlca
        jp      nc, .bit1
        ld      (hl), b
.bit1
        inc     l
        rlca
        jp      nc, .bit0
        ld      (hl), b
.bit0
        inc     l
        rlca
        jp      nc, .nextLine
        ld      (hl), b
.nextLine
        inc     h
        dec     c
        jp      nz, .loop

        ret

        endmodule

        endif
