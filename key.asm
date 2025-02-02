        ifndef  Key_asm
        define  Key_asm

        include key-table.asm

        module  Key

; =========================================================
; Input
;   a - key code
; Output
;   nz - pressed
IsPressed       equ     KeyTable.IsKeyPressed

        endmodule

        endif
