        ifndef  KeyScanner_asm
        define  KeyScanner_asm

        struct  KeyScanner
keyEventCallback        dw
        ends

        module  KeyScanner

; =========================================================
; Input
;   hl - KeyScanner ptr
;   de - KeyEvent callback, where
;     Input
;       de - KeyEvent
Init
        ldi     (hl), de
        ret

; =========================================================
; Input
;   hl - KeyScanner ptr
Update
        ldi     de, (hl)
        push    hl
        ex      de, hl
        calli   hl
        pop     hl
        ret

        endmodule

        endif
