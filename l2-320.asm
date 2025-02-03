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

        endmodule

        endif
