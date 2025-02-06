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
flags   db
        ends

        module  UIView

flag
.visible        equ     %10000000
.needsDraw      equ     %10000000

; =========================================================
; Input
;   hl - UIView ptr
; Output
;   hl - advanced
NeedsDraw
        dup     UIView - UIView.flags
        inc     hl
        edup
        ldi     a, (hl)
        or      flag.needsDraw
        ; TODO: Propagate to parent
        ret

; =========================================================
; Input
;   hl - UIView ptr
; Output
;   hl - advanced
Draw
        break
        dup     UIView
        inc     hl
        edup
        ret

        endmodule

        endif
