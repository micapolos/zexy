        ifndef Dos_asm
        define Dos_asm

        module Dos

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

        call    .rst

        ; page-out ROM
        nextreg NextReg.MMU_0, 35
        nextreg NextReg.MMU_1, 36
        ret

.rst
        rst     $08
.arg    db      0
        ret

        endmodule

        endif
