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
.opaque         equ     %00100000
.dirty          equ     %01000000

; =========================================================
; Input
;   hl - UIView ptr
; Output
;   hl - advanced
NeedsDraw
        dup     UIView - UIView.flags
        inc     hl
        edup
        ld      a, (hl)

        ; Do nothing if not visible
        test    flag.visible
        jp      z, .saveFlagsAndRet

        ; Do nothing if already dirty
        test    flag.dirty
        jp      nz, .saveFlagsAndRet

        ; Set dirty flag
        or      flag.dirty

        ; Save flags
        ldi     (hl), flags

        ; Propagate dirty if not opaque.
        test    flag.opaque
        ret     z
        jp      PropagateNeedsDraw

.saveFlagsAndRet
        ldi     (hl), a
        ret

@PropagateNeedsDraw
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
