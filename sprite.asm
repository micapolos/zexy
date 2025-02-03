        ifndef  Sprite_asm
        define  Sprite_asm

        include reg.asm
        include port.asm
        include dma.asm

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
;   a - start sprite
;   hl - attr data ptr
;   bc - attr data length
LoadAttrs
        ld      bc, Port.SPR_SEL
        out     (c), a
        ; fallthrough

; =========================================================
; Input
;   hl - attr data ptr
;   bc - attr data length
LoadAttrsCont
        ld      de, Port.SPR_ATTR_UPLD
        jp      Dma.CopyToPort

; =========================================================
; Input
;   a - start sprite
;   hl - pattern data ptr
;   bc - pattern data length
LoadPatterns
        ld      bc, Port.SPR_SEL
        out     (c), a
        ; fallback

; =========================================================
; Input
;   hl - src
;   bc - len
LoadPatternsCont
        ld      de, Port.SPR_PAT_UPLD
        jp      Dma.CopyToPort

        endmodule

        endif
