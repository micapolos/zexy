        ifndef  Sprite_asm
        define  Sprite_asm

        include reg.asm
        include port.asm

        struct  Sprite
attr0   db
attr1   db
attr2   db
attr3   db
attr4   db
        ends

        module  Sprite

; =========================================================
; Input
;   hl - Sprite ptr
; Output
;   hl - advanced Sprite ptr
;   sprite loaded into current sprite index, with auto-increment
Load
        ldi     a, (hl)
        nextreg Reg.SPR_ATTR_0, a
        ldi     a, (hl)
        nextreg Reg.SPR_ATTR_1, a
        ldi     a, (hl)
        nextreg Reg.SPR_ATTR_2, a
        ldi     a, (hl)
        nextreg Reg.SPR_ATTR_3, a
        ldi     a, (hl)
        nextreg Reg.SPR_ATTR_4_INC, a
        ret

; =========================================================
; Input
;   hl - src
;   bc - len
;   a - start sprite
LoadPattern
        ld      bc, Port.SPR_SEL
        out     (c), a
        ; fallback

; =========================================================
; Input
;   hl - src
;   bc - len
LoadPatternCurrent
        ld      (dmaProgram.src), hl
        ld      (dmaProgram.len), bc
        ld      hl, dmaProgram
        ld      b, dmaProgram.size
        ld      c, Port.DMA
        otir
        ret

dmaProgram
        db      %10000011
        db      %01111101
.src    dw      0
.len    dw      0
        db      %00010100
        db      %00101000
        db      %10101101
        dw      Port.SPR_PAT_LD
        db      %10000010
        db      %11001111
        db      %10000111
.size   equ     $ - dmaProgram

        endmodule

        endif
