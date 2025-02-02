        ifndef  L2_320_asm
        define  L2_320_asm

        module  L2_320

; =========================================================
Init
        nextreg Reg.ULA_CTRL, Reg.ULA_CTRL.ulaOff | Reg.ULA_CTRL.extKeysOff
        nextreg Reg.DISP_CTRL, Reg.DISP_CTRL.l2on
        nextreg Reg.L2_CTRL, Reg.L2_CTRL.mode320

; =========================================================
Clear
        ld      b, 10
        ld      a, 18
.loop
        nextreg Reg.MMU_7, a
        push    af
        push    bc
        ld      hl, $e000
        ld      bc, $2000
        call    Mem.Clear
        pop     bc
        pop     af
        inc     a
        djnz    .loop
        ret

        endmodule

        endif
