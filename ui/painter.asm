        ifndef  UIPainter_asm
        define  UIPainter_asm

        include l2-320.asm

        struct  UIPainter
offsetX         dw
offsetY         dw
clipWidth       dw
clipHeight      dw
color           db
        ends

        module  UIPainter

; =========================================================
; Input
;   hl - UIPainter ptr
; Output
;   hl - advanced
Fill
        push    hl              ; push UIPainter ptr

        ldi     de, (hl)
        push    de              ; push offsetX

        ldi     de, (hl)
        push    de              ; push offsetY

        ldi     de, (hl)
        push    de              ; push width

        ldi     de, (hl)
        push    de              ; push height

        ldi     a, (hl)

        pop     bc              ; bc = pop height
        ld      l, c            ; l = height MSB
        pop     bc              ; bc = pop width
        pop     de              ; de = pop offsetY
        ld      h, e            ; h = offsetY MSB
        pop     de              ; bc = pop offsetX

        call    L2_320.FillRect

        pop     hl
        dup     UIPainter
        inc     hl
        edup

        ret

        endmodule

        endif
