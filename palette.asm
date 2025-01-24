        IFNDEF  PALETTE_LIB
        DEFINE  PALETTE_LIB

        MODULE  Palette

; Input:
;   HL - palette addr
;   B - count
; Output:
;   HL, BC, DE, AF - undefined
Load9Bit
.loop:
        ld      a, (hl)
        inc     hl
        nextreg $44, a

        ld      a, (hl)
        inc     hl
        nextreg $44, a

        djnz    .loop

        ret

; Input:
;   HL - src palette (8 DW colors)
;   DE - dst palette (256 DW colors)
; Output:
;   HL - advanced
;   DE - advanced
LoadText
        ld      c, 0
.outerLoop
        ld      b, 0
.innerLoop
        ld      a, c
        call    CopyColor

        ld      a, b
        call    CopyColor

        ld      a, b
        call    CopyColor

        ld      a, c
        call    CopyColor

        ld      a, b
        inc     a
        and     $07
        ld      b, a
        jp      nz, .innerLoop

        ld      a, c
        inc     a
        and     $07
        ld      c, a
        jp      nz, .outerLoop

        ret

; Input:
;   HL - src palette
;   DE - dst
;   A - color
; Output:
;   DE - advanced
CopyColor
        push    hl
        push    bc

        add     hl, a
        add     hl, a
        ldi
        ldi

        pop     bc
        pop     hl

        ret

        ENDMODULE

        ENDIF
