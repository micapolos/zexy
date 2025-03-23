        ifndef  IMath_asm
        define  IMath_asm

        macro   IMath_Zero8
        call    IMath.Zero8
        endm

        macro   IMath_Zero16
        call    IMath.Zero16
        endm

        macro   IMath_Load8 n
        ld      c, n
        call    IMath.LoadC
        endm

        macro   IMath_Load16 nm
        ld      bc, nm
        call    IMath.LoadBC
        endm

        module  IMath

; ---------------------------------------------------------
; Input
;   HL - lhs addr
; Output
;   HL - advanced
Zero8
        ld      (hl), 0
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - lhs addr
; Output
;   C - value
;   HL - advanced
ReadC
        ld      c, (hl)
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - addr
;   C - value
; Output
;   HL - advanced
LoadC
        ld      (hl), c
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - lhs addr
;   DE - rhs addr
; Output
;   HL, DE - advanced
Load8
        ld      a, (de)
        ld      (hl), a
        inc     de
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
AddC
        ld      a, (hl)
        add     c
        ld      (hl), a
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - addr
;   C - value
; Output
;   HL - advanced addr
AdcC
        ld      a, (hl)
        adc     c
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
        call    ReadC
        ex      de, hl
        jp      AddC

; ---------------------------------------------------------
; Input
;   HL - lhs addr
;   DE - rhs addr
; Output
;   HL - advanced addr
;   DE - advanced addr
Adc8
        ex      de, hl
        call    ReadC
        ex      de, hl
        jp      AdcC

; ---------------------------------------------------------
; Input
;   HL - lhs addr
; Output
;   HL - advanced
Zero16
        call    Zero8
        jp      Zero8

; ---------------------------------------------------------
; Input
;   HL - addr
; Output
;   HL - advanced addr
;   BC - read value
ReadBC
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
;   BC - loaded
LoadBC
        ld      (hl), c
        inc     hl
        ld      (hl), b
        inc     hl
        ret

; ---------------------------------------------------------
; Input
;   HL - lhs addr
;   DE - rhs addr
; Output
;   HL, DE - advanced addr
Load16
        ex      de, hl
        call    ReadBC
        ex      de, hl
        jp      LoadBC

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
AddBC
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
        call    LoadBC
        ex      de, hl
        jp      AddBC

        endmodule

        endif
