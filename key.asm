        ifndef  Key_asm
        define  Key_asm

        include key-table.asm

        module  Key

; =========================================================
; Input
;   a - key
; Output
;   nz - pressed
IsPressed       equ     KeyTable.IsKeyPressed

        endmodule

        endif
