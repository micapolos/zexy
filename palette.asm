        IFNDEF  PALETTE_LIB
        DEFINE  PALETTE_LIB

        MODULE  Palette

; Input:
;   HL - palette addr
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
;   HL - src text palette (2 arrays of 8 RGB_333 colors)
;   DE - dst palette (256 RGB_333 colors)
; Output:
;   HL - advanced
;   DE - advanced
InitText
        ld      c, 0
.outerLoop
        ld      b, 0
.innerLoop
        ld      a, b
        call    CopyColor

        ld      a, c
        call    CopyColor

        ld      a, b
        add     a, 8
        call    CopyColor

        ld      a, c
        add     a, 8
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
