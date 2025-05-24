        ifndef  Math_asm
        define  Math_asm

        module  Math

; Input
;   a - input
;   b - wrap value (exclusive)
; Output
;   a = a + 1, if (a >= b): a -= b
IncAWrapE
        inc     a
        cp      e
        ret     c
        sub     e
        ret

; Input
;   hl - input
;   de - wrap value (exclusive)
; Output
;   hl = hl + 1, if (hl >= de): hl -= de
IncHLWrapDE
        inc     hl
        scf
        ccf
        sbc     hl, de
        ret     nc
        add     hl, de
        ret

; =========================================================
; hl = hl and rr
; af = corrupt
; =========================================================
and_hl_rr       macro   rr
        ld      a, l
        and     high rr
        ld      l, a
        ld      a, h
        and     low rr
        ld      h, a
        endm


        endmodule

        endif
