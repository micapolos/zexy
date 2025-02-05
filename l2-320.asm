        ifndef  L2_320_asm
        define  L2_320_asm

        include bank.asm
        include reg.asm

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

        ret

; =========================================================
Clear
        ld      a, 0
        ; fall-through

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

; ========================================================
; Input
;   h - line address MSB
;   l - bank number
;   (.blitLineProc) - blit line proc
;     Input
;       h - line address MSB
;       l - bank number
;       de - preserved
;       bc - preserved
;       af - corrupted
;     Output
;       f - z to stop, nz to continue
; Output
;     z - stop
BlitUntilZ
.bankLoop
        ; set bank "e" in slot 7
        ld      a, l
        nextreg Reg.MMU_7, a

.lineLoop
        push    hl
.blitLineProc+* call    0
        pop     hl
        ret     z

.nextLine
        inc     h
        ld      a, h
        and     $1f
        jp      nz, .lineLoop

.nextBank
        ld      a, h
        sub     $20
        ld      h, a
        inc     l
        jp      .bankLoop

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
        ld      (BlitUntilZ.blitLineProc), hl

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

        jp      BlitUntilZ

.fillLine
.row+*          ld      l, 0
.height+*       ld      b, 0
.color+*        ld      a, 0
.loop
        ld      (hl), a
        inc     l
        djnz    .loop

        dec     bc
        ld      a, b
        or      c
        ret

        endmodule

        endif
