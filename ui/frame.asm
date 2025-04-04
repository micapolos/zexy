        ifndef  UIFrame_asm
        define  UIFrame_asm

        include ui/coord.asm
        include ui/size.asm
        include l2-320.asm

        struct  UIFrame
origin  UICoord
size    UISize
        ends

        module  UIFrame

; =========================================================
; Input
;   hl - UIFrame ptr
;   a - color
; Output
;   hl - advanced
Fill
        push    hl              ; push UIFrame ptr
        call    LoadRectFrame   ; Load frame into registers compatible with L2_320 call
        call    L2_320.FillRect
        pop     hl
        dup     UIFrame
        inc     hl
        edup
        ret

; =========================================================
; Input
;   hl - UIFrame ptr
;   a - color
; Output
;   hl - advanced
Stroke
        push    hl              ; push UIFrame ptr
        call    LoadRectFrame   ; Load frame into registers compatible with L2_320 call
        call    L2_320.DrawRect
        pop     hl
        dup     UIFrame
        inc     hl
        edup
        ret

; a - preserved
@LoadRectFrame
        ldi     de, (hl)
        push    de              ; push frame.coord.x

        ldi     de, (hl)
        push    de              ; push frame.coord.y

        ldi     de, (hl)
        push    de              ; push frame.size.width

        ldi     de, (hl)
        push    de              ; push frame.size.height

        pop     bc              ; bc = pop height
        ld      l, c            ; l = height MSB
        pop     bc              ; bc = pop width
        pop     de              ; de = pop y
        ld      h, e            ; h = offsetY MSB
        pop     de              ; bc = pop x

        ret

        endmodule

        endif
