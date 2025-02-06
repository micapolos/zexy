        ifndef  UIPainter_asm
        define  UIPainter_asm

        include l2-320.asm
        include frame.asm

        struct  UIPainter
frame           UIFrame
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
        push    de              ; push frame.coord.x

        ldi     de, (hl)
        push    de              ; push frame.coord.y

        ldi     de, (hl)
        push    de              ; push frame.size.width

        ldi     de, (hl)
        push    de              ; push frame.size.height

        ldi     a, (hl)         ; a = color

        pop     bc              ; bc = pop height
        ld      l, c            ; l = height MSB
        pop     bc              ; bc = pop width
        pop     de              ; de = pop y
        ld      h, e            ; h = offsetY MSB
        pop     de              ; bc = pop x

        call    L2_320.FillRect

        pop     hl
        dup     UIPainter
        inc     hl
        edup

        ret

        endmodule

        endif
