        ifndef  UIVec_asm
        define  UIVec_asm

        include ../imath.asm

        struct  UIVec
x       dw
y       dw
        ends

; ---------------------------------------------------------
; Input
;   HL - lhs UIVec*
; Output
;   HL - advanced
        macro   UIVec_Zero
        IMath_Zero16
        endm

; ---------------------------------------------------------
; Input
;   HL - lhs UIVec*
; Output
;   HL - advanced
        macro   UIVec_Load x, y
        ld      bc, x
        call    IMath.LoadBC
        ld      bc, y
        call    IMath.LoadBC
        endm

        module  UIVec

; ---------------------------------------------------------
; Input
;   HL - lhs UIVec*
;   DE - rhs UIVec*
; Output
;   HL - advanced
;   DE - advanced
Load
        call    IMath.Load16
        jp      IMath.Load16

; ---------------------------------------------------------
; Input
;   HL - lhs UIVec*
;   DE - rhs UIVec*
; Output
;   HL - advanced
;   DE - advanced
Add
        call    IMath.Add16
        jp      IMath.Add16

        endmodule

        endif
