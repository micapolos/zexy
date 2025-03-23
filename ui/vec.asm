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
        macro   UIVec_Load x, y
        ld      bc, x
        call    IMath.LoadBC
        ld      bc, y
        call    IMath.LoadBC
        endm

        module  UIVec

; ---------------------------------------------------------
; Input
;   HL - UIVec*
; Output
;   HL - advanced
Zero
        call    IMath.Zero16
        jp      IMath.Zero16

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
;   HL - UIVec end addr
; Output
;   HL - UIVec start addr
Push
        call    IMath.Push16
        jp      IMath.Push16

; ---------------------------------------------------------
; Input
;   HL - UIVec start addr
; Output
;   HL - UIVec end addr
Pop
        call    IMath.Pop16
        jp      IMath.Pop16

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
