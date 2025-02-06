        ifndef  UIPainter_asm
        define  UIPainter_asm

        include l2-320.asm
        include frame.asm
        include struct.asm

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
        ; TODO: Should we re-order `color` and `frame` fields to optimize call sequence?
        push    hl              ; push UIPainter ptr
        StructSkip UIFrame      ; skip frame
        ld      a, (hl)         ; a = color
        pop     hl              ; hl = restore UIPainter ptr
        call    UIFrame.Fill    ; fill frame
        inc     hl              ; skip color
        ret

; =========================================================
; Input
;   hl - UIPainter ptr
; Output
;   hl - advanced
Stroke
        ; TODO: Should we re-order `color` and `frame` fields to optimize call sequence?
        push    hl              ; push UIPainter ptr
        StructSkip UIFrame      ; skip frame
        ld      a, (hl)         ; a = color
        pop     hl              ; hl = restore UIPainter ptr
        call    UIFrame.Stroke  ; stroke frame
        inc     hl              ; skip color
        ret

        endmodule

        endif
