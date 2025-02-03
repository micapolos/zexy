        ifndef Dos_asm
        define Dos_asm

        include reg.asm

        module Dos

Reset
        ; page-in ROM
        nextreg Reg.MMU_0, $ff
        nextreg Reg.MMU_1, $ff
        rst     $00

; Input
;   (sp) - value
Call
        pop     hl
        push    af
        ld      a, (hl)
        inc     hl
        ld      (.arg), a
        pop     af
        push    hl

        ; page-in ROM
        nextreg Reg.MMU_0, $ff
        nextreg Reg.MMU_1, $ff

        rst     $08
.arg    db      0

        ; page-out ROM
        nextreg Reg.MMU_0, 35
        nextreg Reg.MMU_1, 36
        ret

        endmodule

        endif
