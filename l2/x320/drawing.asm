        ifndef  L2_x320_Drawing_asm
        define  L2_x320_Drawing_asm

        include ../../blit.asm
        include ../../l2-320.asm

        module  L2
        module  x320
        module  Drawing

; =========================================================
Init
        jp      L2_320.Init

; =========================================================

        struct  Fill
color   db      0
        ends

; =========================================================
; Input
;   hl - Fill*
DrawFill
        ld      a, (hl)
        jp      L2_320.Fill

; =========================================================

        struct  FilledRect
left    dw      0
top     db      0
width   dw      0
height  db      0
color   db      0
        ends

; =========================================================
; Input
;   hl - FilledRect*
DrawFilledRect
        ldi     de, (hl)
        push    de
        ldi     b, (hl)
        ldi     de, (hl)
        push    de
        ldi     c, (hl)
        push    bc
        ld      a, (hl)
        pop     hl
        pop     bc
        pop     de
        jp      L2_320.FillRect

; =========================================================

        struct  Patch
left    dw      0
top     db      0
src     dw      0
width   dw      0
height  db      0
advance db      0
        ends

; =========================================================
; Input
;   hl - Patch*
DrawPatch
        ldi     de, (hl)                ; de = left
        ldi     a, (hl)                 ; a = top
        push    hl                      ; push Patch*
        ld      l, a                    ; l = top
        call    L2_320.GetAddrBank7     ; hl = dst, a = bank
        ex      de, hl                  ; de = dst
        pop     hl                      ; pop Patch*
        push    de                      ; push dst
        push    af                      ; push bank

        ldi     de, (hl)                ; de = src
        push    de                      ; push src
        ldi     de, (hl)                ; de = width
        push    de                      ; push width
        ldi     bc, (hl)                ; bc = advance / height

        exx
        pop     bc                      ; bc' = width
        exx

        pop     hl                      ; hl = src

        exx
        pop     de                      ; de' = bank / ?
        ld      e, d                    ; e' = bank
        exx

        pop     de                      ; de = dst
        jp      Blit.CopyLinesMmu7

; =========================================================

        struct  PatchX
left    dw      0
top     db      0
xColor  db      0
src     dw      0
width   dw      0
height  db      0
advance db      0
        ends

; =========================================================
; Input
;   hl - PatchX*
DrawPatchX
        ldi     de, (hl)                ; de = left
        ldi     a, (hl)                 ; a = top
        push    hl                      ; push Patch*
        ld      l, a                    ; l = top
        call    L2_320.GetAddrBank7     ; hl = dst, a = bank
        ex      de, hl                  ; de = dst
        pop     hl                      ; pop Patch*
        push    de                      ; push dst
        ld      e, a                    ; e = bank
        ldi     d, (hl)                 ; d = xColor
        push    de                      ; push xColor / bank

        ldi     de, (hl)                ; de = src
        push    de                      ; push src
        ldi     de, (hl)                ; de = width
        push    de                      ; push width
        ldi     bc, (hl)                ; bc = advance / height

        exx
        pop     bc                      ; bc' = width
        exx

        pop     hl                      ; hl = src

        exx
        pop     de                      ; de' = xColor / bank
        exx

        pop     de                      ; de = dst
        jp      Blit.CopyLinesXMmu7

        endmodule
        endmodule
        endmodule

        endif
