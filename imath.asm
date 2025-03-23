        ifndef  IMath_asm
        define  IMath_asm

        module  IMath

        macro   IMath_Skip8
        inc     hl
        endm

        macro   IMath_Skip16
        inc     hl
        inc     hl
        endm

; ---------------------------------------------------------
; Input
;   HL - addr
; Output
;   HL - advanced addr
;   C - loaded
Load8
        ld      c, (hl)
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - addr
; Output
;   HL - advanced addr
Inc8
        inc     (hl)
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - addr
; Output
;   HL - advanced addr
Dec8
        dec     (hl)
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - addr
;   C - value
; Output
;   HL - advanced addr
AddConst8
        ld      a, (hl)
        add     c
        ld      (hl), a
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - lhs addr
;   DE - rhs addr
; Output
;   HL - advanced addr
;   DE - advanced addr
Add8
        ex      de, hl
        call    Load8
        ex      de, hl
        jp      AddConst8

; ---------------------------------------------------------
; Input
;   HL - addr
; Output
;   HL - advanced addr
;   BC - loaded
Load16
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - addr
; Output
;   HL - advanced addr
Inc16
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        dec     hl
        inc     bc
        ld      (hl), c
        inc     hl
        ld      (hl), b
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - addr
; Output
;   HL - advanced addr
Dec16
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        dec     hl
        dec     bc
        ld      (hl), c
        inc     hl
        ld      (hl), b
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - addr
;   BC - operand
; Output
;   HL - advanced addr
;   AF - corrupted
AddConst16
        ld      a, (hl)
        add     a, c
        ld      (hl), a
        inc     hl
        ld      a, (hl)
        adc     a, b
        ld      (hl), a
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - lhs addr
;   DE - rhs addr
; Output
;   HL - advanced addr
;   DE - advanced addr
Add16
        ex      de, hl
        call    Load16
        ex      de, hl
        jp      AddConst16

        endmodule

        endif
