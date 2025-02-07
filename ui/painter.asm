        ifndef  UIPainter_asm
        define  UIPainter_asm

        include l2-320.asm
        include ui/frame.asm
        include struct.asm
        include ui/alignment.asm

        struct  UIPainter
frame           UIFrame
color           db
        ends

        module  UIPainter

; =========================================================
; Input
;   hl - UIFrame ptr
;   de - x
;   bc - y
;   a - UIAlignment
; Output
;   hl - advanced
Point
        break
        push      bc            ; push y
        test      UIAlignment.right
        jp        z, .left
.right
        StructInc 2             ; skip x, (hl) = UIPainter.frame.y
        push      hl
        StructInc 2             ; (hl) = UIPainter.frame.width
        StructLd  bc            ; bc = width
        ld        hl, bc        ; hl = width
        scf                     ; set carry
        sbc       hl, de        ; hl = width - x - 1
        ex        de, hl        ; de = right aligned x
        pop       hl            ; (hl) = UIPainter.frame..y
        jp        .vertical
.left
        StructLdi de            ; de = left aligned x, (hl) = UIPainter.frame.y
.vertical
        ; (hl) = UIPainter.frame.y
        pop       bc            ; bc = y
        push      de            ; push aligned x
        test      UIAlignment.bottom
        jp        z, .top
.bottom
        ; (hl) = UIPainter.frame.y
        StructInc 2             ; skip y, (hl) = UIPainter.frame.width
        StructInc 2             ; skip width, (hl) = UIPainter.frame.height
        StructLdi de            ; de = height, (hl) = UIPainter.color
        push      hl
        ld        hl, de        ; hl = height
        scf                     ; set carry
        sbc       hl, bc        ; hl = height - y - 1
        ld        bc, hl        ; bc = bottom aligned y
        pop       hl            ; (hl) = UIPainter.color
        jp        .color
.top
        ; (hl) = UIPainter.frame.y
        StructLdi bc            ; bc = top aligned y, (hl) = UIPainter.frame.height
        StructInc 2             ; (hl) = UIPainter.color
.color
        ; (hl) = UIPainter.color
        StructLdi a             ; a = color, (hl) = advanced
        pop     de              ; de = aligned x
        push    hl
        ld      l, c            ; l = aligned y MSB
        break
        call    L2_320.PutPixel
        pop     hl              ; (hl) = UIPainter.color
        ret

; =========================================================
; Input
;   hl - UIPainter ptr
; Output
;   hl - advanced
Fill
        ; TODO: Should we re-order `color` and `frame` fields to optimize call sequence?
        push    hl              ; push UIPainter ptr
        StructInc UIFrame      ; skip frame
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
        StructInc UIFrame      ; skip frame
        ld      a, (hl)         ; a = color
        pop     hl              ; hl = restore UIPainter ptr
        call    UIFrame.Stroke  ; stroke frame
        inc     hl              ; skip color
        ret

        endmodule

        endif
