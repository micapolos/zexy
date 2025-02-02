        ifndef  Bank_asm
        define  Bank_asm

        include mem.asm

        module  Bank

; =========================================================
; Input
;   a - 8K bank number
Clear
        ld      e, 0
        ; fall-through

; =========================================================
; Input
;   a - 8K bank number
;   e - value
Fill
.loop
        nextreg Reg.MMU_7, a
        ld      hl, $e000
        ld      bc, $2000
        jp      Mem.Fill

        endmodule

        endif
