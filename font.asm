        ifndef  Font_asm
        define  Font_asm

        module  Font

; =========================================================
; Input
;   hl - font ptr
;   de - string ptr
;   fc - carry from previous char
; Output
;   bc - width
;   de - advanced string ptr
;   fc - carry to the next char
GetStringWidth
        ld      bc, 0   ; resetWidth
.readNextChar
        push    af      ; push carry from previous char
        ldi     a, (de)
        or      a
        jp      z, .noMoreChars

        push    bc
        push    de
        push    hl
        call    GetCharWidth
        pop     hl
        pop     de
        pop     bc

        jp      z, .noGlyph
.hasGlyph
        add     bc, a
        pop     af      ; pop carry from previous char
        jp      nc, .noSpacing
        inc     bc      ; add spacing
.noSpacing
        scf             ; set carry after current char
        jp      .readNextChar
.noGlyph
        pop     af      ; pop carry from previous char
        jp      .readNextChar
.noMoreChars
        pop     af      ; pop carry from previous char
        ret

; =========================================================
; Input
;   hl - font ptr
;   a - char
; Output
;   a - width
;   fz - no glyph
GetCharWidth
        call    GetGlyph
        ret     z
        jp      GetGlyphWidth

; =========================================================
; Input
;   hl - glyph ptr
; Output
;   hl - glyph data
;   a - width
GetGlyphWidth
        ldi      a, (hl)
        ret

; =========================================================
; Input
;   hl - font ptr
;   a - char
; Output
;   hl = glyph ptr
;   fz = no glyph
GetGlyph
        rlca
        add     hl, a
        ldi     de, (hl)
        ex      de, hl
        ld      a, h
        or      l
        ret

        endmodule

        endif
