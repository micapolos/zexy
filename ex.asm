        ifndef  Ex_asm
        define  Ex_asm

; =========================================================
; ex bc, bc'
        macro   exb
        push    bc
        exx
        push    bc
        exx
        pop     bc
        exx
        pop     bc
        exx
        endm

; =========================================================
; ex de, de'
        macro   exd
        push    de
        exx
        push    de
        exx
        pop     de
        exx
        pop     de
        exx
        endm

; =========================================================
; ex hl, hl'
        macro   exh
        push    hl
        exx
        push    hl
        exx
        pop     hl
        exx
        pop     hl
        exx
        endm

        endif
