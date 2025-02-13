        ifndef  UIDrawer_asm
        define  UIDrawer_asm

        include ../struct.asm
        include ../l2-320.asm

; =========================================================
; Input
;   hl - UIFrame ptr
UIDrawer

        module  UIDrawer

; color
color   db      0

; =========================================================
; Input
;   hl - UIFrame ptr
;   a - color
Fill
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

.size   equ     6

; =========================================================
; Output
;   hl - Fill ptr
InitFill
        ldi     (hl), %00111010         ; ld a, (color)
        ldi     (hl), low color
        ldi     (hl), high color
        ldi     (hl), %11000011         ; jp Fill
        ldi     (hl), low Fill
        ldi     (hl), high Fill
        ret

        endmodule

        endif
