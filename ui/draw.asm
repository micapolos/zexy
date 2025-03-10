        ifndef  UIDraw_asm
        define  UIDraw_asm

        include ../l2-320.asm
        include pattern.asm
        include frame.asm

        module  UIDraw

; Base framebuffer bank
baseBank        db      18

; Draw frame
frame           UIFrame

; Color for point, fill and text
color           db      0

; Pattern for drawing
pattern         UIPattern

; Text font
font            dw      0

; =========================================================
@LoadBank
        ld      hl, (baseBank)
        ld      (L2_320.baseBank8), hl
        ret

; =========================================================
; Output
;   de - x
;   l - y
@LoadFrameOrigin
        ld      hl, frame.origin
        ldi     de, (hl)
        ld      c, (hl)
        ld      l, c
        ret

; =========================================================
; Output
;   de - x
;   bc - width
;   hl - y / height
@LoadFrame
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
        ret

; =========================================================
; Puts pixel at frame.origin using color.
Pixel
        call    LoadFrameOrigin
        ld      a, (color)
        jp      L2_320.PutPixel

; =========================================================
; Fills frame with color.
Fill
        call    LoadFrame
        ld      a, (color)
        jp      L2_320.FillRect

; =========================================================
; Input
;    hl - string ptr
Text
        push    hl
        ld      hl, (font)
        ld      (L2_320.fontPtr), hl
        ld      a, (color)
        ld      (L2_320.textColor), a
        call    LoadFrameOrigin
        call    L2_320.MoveTo
        ex      de, hl
        pop     hl
        jp      L2_320.DrawString

; =========================================================
; Draws pattern inside a frame
Pattern
        break   ; todo

        endmodule

        endif
