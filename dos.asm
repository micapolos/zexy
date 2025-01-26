        ifndef Dos_asm
        define Dos_asm

        module Dos

Reset
        ; page-in ROM
        nextreg NextReg.MMU_0, $ff
        nextreg NextReg.MMU_1, $ff
        rst     $00

; Input
;   (sp) - value
Call
        pop     hl
        ld      a, (hl)
        inc     hl
        ld      (.arg), a
        push    hl

        ; page-in ROM
        nextreg NextReg.MMU_0, $ff
        nextreg NextReg.MMU_1, $ff

        rst     $08
.arg    db      0

        ; page-out ROM
        nextreg NextReg.MMU_0, 35
        nextreg NextReg.MMU_1, 36
        ret

        endmodule

        endif
