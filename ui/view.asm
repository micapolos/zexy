        ifndef  UIView_asm
        define  UIView_asm

        include ui/frame.asm

        struct  UIViewClass
needsDrawProc   dw
drawProc        dw
        ends

        struct  UIView
class           UIViewClass
parent          dw
frame           UIFrame
flags           db
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
        ; Skip metadata
        dup     UIView - UIView.flags
        inc     hl
        edup

        ; Load flags
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

.propagateNeedsDraw
        dup     UIView
        inc     hl
        edup
        ret

; =========================================================
; Input
;   hl - UIView ptr
; Output
;   hl - advanced
Clean
        ; Skip metadata
        dup     UIView - UIView.flags
        inc     hl
        edup

        ; Load flags
        ld      a, (hl)

        ; Do nothing if already clean
        test    flag.dirty
        jp      z, .saveFlagsAndRet

        ; Clean dirty flag
        and     ~flag.dirty

        ; Save flags
        ldi     (hl), flags

        ; Redraw children
        break

.saveFlagsAndRet
        ldi     (hl), a
        ret

        endmodule

        endif
