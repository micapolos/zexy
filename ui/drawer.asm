        ifndef  UIDrawer_asm
        define  UIDrawer_asm

        include ../l2-320.asm
        include image.asm
        include frame.asm

        module  UIDrawer

frame   UIFrame
color   db      0
image   UIImage

; =========================================================
Fill
        ld      hl, frame
        ldi     bc, (hl)        ; push x
        push    bc
        ldi     bc, (hl)        ; push y
        push    bc
        ldi     bc, (hl)        ; bc = width
        ldi     de, (hl)        ; height
        ld      l, e            ; l = height
        pop     de
        ld      h, e            ; h = y
        pop     de              ; pop x
        jp      L2_320.FillRect

        endmodule

        endif
