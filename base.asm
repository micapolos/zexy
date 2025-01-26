        IFNDEF  Base_asm
        DEFINE  Base_asm

        MODULE  Base

; Input:
;   B - count
;   IY - callback
Repeat:
.loop
        push    bc
        push    .continue
        jp      (IY)
.continue
        pop     bc
        djnz    .loop
        ret

        ENDMODULE

        ENDIF
