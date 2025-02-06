        ifndef  UIView_asm
        define  UIView_asm

        include frame.asm

        struct  UIViewClass
needsDrawProc   dw
drawProc        dw
        ends

        struct  UIView
class   UIViewClass
parent  dw
frame   Frame
; bit 7: visible
; bit 6: needsDraw
; bit 5..0: unused, must be 0
flags   db
        ends

        module  UIView

; =========================================================
; Input
;   hl - UIView ptr
; Output
;   hl - advanced
NeedsDraw
        dup     UIView
        inc     hl
        edup
        ret

; =========================================================
; Input
;   hl - UIView ptr
; Output
;   hl - advanced
Draw
        dup     UIView
        inc     hl
        edup
        ret

        endmodule

        endif
