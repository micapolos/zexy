        ifndef  L2_320_asm
        define  L2_320_asm

        include bank.asm
        include reg.asm
        include blit.asm
        include struct.asm
        include sm.asm

        module  L2_320

baseBank8       dw      18

; =========================================================
Init
        nextreg Reg.ULA_CTRL, Reg.ULA_CTRL.ulaOff | Reg.ULA_CTRL.extKeysOff
        nextreg Reg.DISP_CTRL, Reg.DISP_CTRL.l2on
        nextreg Reg.L2_CTRL, Reg.L2_CTRL.mode320

        nextreg Reg.CLIP_WND_CTL, Reg.CLIP_WND_CTL.resL2RegIdx
        nextreg Reg.CLIP_WND_L2, 0
        nextreg Reg.CLIP_WND_L2, 159
        nextreg Reg.CLIP_WND_L2, 0
        nextreg Reg.CLIP_WND_L2, 255
        ; fall through to Clear

; =========================================================
Clear
        ld      a, 0
        ; fall through to Fill

        macro   L2_320_Clear
        call    L2_320.Clear
        endm

; =========================================================
; Input
;   a - value
Fill
        ld      e, a
        ld      a, (baseBank8)
        ld      b, 10
.loop
        push    af
        push    bc
        push    de
        call    Bank.Fill
        pop     de
        pop     bc
        pop     af
        inc     a
        djnz    .loop
        ret

        macro   L2_320_Fill color
        ld      a, color
        call    L2_320.Fill
        endm

; ========================================================
; Input
;   de - col
;   h - row
;   bc - width
;   l - height
;   a - color
FillRect
        ; Write row, height and color
        ld      (.color), a
        ld      a, h
        ld      (.row), a
        ld      a, l
        ld      (.height), a

        ; Write blitLineProc
        ld      hl, .fillLine
        ld      (Blit.Bank7Lines256UntilZ.blitLineProc), hl

        ; h = start address
        ld      a, e
        and     $1f
        add     $e0
        ld      h, a

        ; l = bank number (preserve bc = width)
        push    bc
        ld      b, 5
        bsrl    de, b
        ld      a, e
        add     $12
        ld      l, a
        pop     bc

        jp      Blit.Bank7Lines256UntilZ
.fillLine
        push    bc
.row+*          ld      l, 0
.height+*       ld      b, 0
.color+*        ld      a, 0
.loop
        ld      (hl), a
        inc     l
        djnz    .loop
        pop     bc

        dec     bc
        ld      a, b
        or      c
        ret

        macro   L2_320_FillRect x, y, width, height, color
        ld      de, x
        ld      hl, (y << 8) | height
        ld      bc, width
        ld      a, color
        call    L2_320.FillRect
        endm

; ========================================================
; Input
;   de - col
;   l - row
;   a - color
; Output
;   bank in slot 7 corrupted
PutPixel
        push    af
        call    MoveTo
        pop     af
        ld      (hl), a
        ret

        macro   L2_320_PutPixel x, y, color
        ld      de, x
        ld      l, y
        ld      a, color
        SM_Call L2_320.PutPixel
        endm

; ========================================================
; Input
;   de - col
;   h - row
;   bc - width
;   a - color
; Output
;   bank in slot 7 corrupted
DrawHLine
        ld      l, 1            ; height
        jp      FillRect

        macro   L2_320_DrawHLine x, y, width, color
        ld      de, x
        ld      h, y
        ld      bc, width
        ld      a, color
        call    L2_320.DrawHLine
        endm

; ========================================================
; Input
;   de - col
;   hl - row / height
;   a - color
; Output
;   bank in slot 7 corrupted
DrawVLine
        ld      bc, 1           ; width
        jp      FillRect

        macro   L2_320_DrawVLine x, y, height, color
        ld      de, x
        ld      hl, (y << 8) | height
        ld      a, color
        call    L2_320.DrawVLine
        endm

; ========================================================
; Input
;   de - col
;   h - row
;   bc - width
;   l - height
;   a - color
DrawRect
        push    bc, de, hl, af
        ld      l, 1
        call    DrawHLine
        pop     af, hl, de, bc

        push    bc, de, hl, af
        push    af
        ld      a, h
        add     l
        ld      h, a
        ld      l, 1
        pop     af
        call    DrawHLine
        pop     af, hl, de, bc

        push    bc, de, hl, af
        ld      bc, 1
        call    DrawVLine
        pop     af, hl, de, bc

        push    hl
        ld      hl, bc
        add     hl, de
        dec     hl
        ex      de, hl
        pop     hl
        ld      bc, 1
        jp      DrawVLine

        macro   L2_320_DrawRect x, y, width, height, color
        ld      de, x
        ld      hl, (y << 8) | height
        ld      bc, width
        ld      a, color
        call    L2_320.DrawRect
        endm

; ========================================================
; Input
;   de - col
;   l - row
; Output
;   hl - address
;   correct bank in slot 7
MoveTo
        call    GetAddrBank7
        nextreg Reg.MMU_7, a
        ret

; ========================================================
; Input
;   de - col
; Output
;   h - address MSB between $e0..$ff
;   a - bank in slot 7
GetAddrBank7
        ; h = address MSB, l = already valid
        ld      a, e
        and     $1f
        add     $e0
        ld      h, a

        ; a = bank in slot 7
        ld      b, 5
        bsrl    de, b
        ld      a, e
        add     $12
        nextreg Reg.MMU_7, a
        ret

; =========================================================
; Input
;   de - col
;   bc - width
;   hl - run addr
;   (.color) - color
;   (.top) - top
DrawLabel
        ; Write blitLineProc
        push    hl
        ld      hl, .blitLine
        ld      (Blit.Bank7Lines256UntilZ.blitLineProc), hl

        ; h = start address MSB for blit
        ; a = bank number
        push    bc
        call    GetAddrBank7
        pop     bc

        ; de - run addr
        pop     de

        ; l = start bank number for blit
        ld      l, a

        jp      Blit.Bank7Lines256UntilZ

.blitLine
        ldi     a, (de)
        push    de
.color+*        ld      e, 0
.bit7
.top+*  ld      l, 0            ; self-modified code
        rlca
        jp      nc, .bit6
        ld      (hl), e
.bit6
        inc     l
        rlca
        jp      nc, .bit5
        ld      (hl), e
.bit5
        inc     l
        rlca
        jp      nc, .bit4
        ld      (hl), e
.bit4
        inc     l
        rlca
        jp      nc, .bit3
        ld      (hl), e
.bit3
        inc     l
        rlca
        jp      nc, .bit2
        ld      (hl), e
.bit2
        inc     l
        rlca
        jp      nc, .bit1
        ld      (hl), e
.bit1
        inc     l
        rlca
        jp      nc, .bit0
        ld      (hl), e
.bit0
        inc     l
        rlca
        jp      nc, .nextLine
        ld      (hl), e
.nextLine
        pop     de
        dec     bc
        ld      a, b
        or      c
        ret

        macro   L2_320_DrawLabel x, y, label, width, color
        ld      hl, L2_320.DrawLabel.color
        ld      (hl), color
        ld      hl, L2_320.DrawLabel.top
        ld      (hl), y
        ld      hl, label
        ld      de, x
        ld      bc, width
        call    L2_320.DrawLabel
        endm

; =========================================================

        ; Defines nine patch, followed by data
        macro   L2_320_NinePatch left, top, right, bottom
        dw      .data
        db      ((left & $0f) << 4) | (right & $0f)
        db      ((top & $0f) << 4) | (bottom & $0f)
        db      %10010000       ; TODO: Compute from left/right
        db      %10010000       ; TODO: Compute from top/bottom
@.data
        endm

; =========================================================
; Input
;   hl - params ptr
;     x         dw
;     y         db
;     width     dw
;     height    db
;     ninePatch dw
;     flags     db
DrawNinePatch
        StructLdi de
        StructLdi l
        call    MoveTo  ; hl = address
        ex      de, hl  ; de = address
        StructLdi bc


        ; Push start address
        push    hl
        ld      l, c
        call    MoveTo
        ex      de, hl
        pop     hl
        push    de

        ; TODO

        ret

        macro   L2_320_DrawNinePatch ninePatch, x, y, width, height
        SM_Const ninePatch
        SM_Const x
        SM_Const y
        push    x
        call    L2_320.DrawNinePatch
        endm

        endmodule

        endif
