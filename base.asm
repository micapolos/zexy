        ifndef  Base_asm
        define  Base_asm

        module  Base

; Input:
;   B - count
;   iy - callback
Repeat:
.loop
        push    bc
        push    .continue
        jp      (iy)
.continue
        pop     bc
        djnz    .loop
        ret

        endmodule

        endif
