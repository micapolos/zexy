        ifndef  Debug_asm
        define  Debug_asm

        module  Debug

; ===================================================================

        macro   DebugWait count
        push    af, bc, de, hl
        ld      bc, count
        call    Debug.Wait
        pop     hl, de, bc, af
        endm

; ===================================================================
; Input
;   bc - count
Wait
.loop   dec     bc
        ld      a, b
        or      c
        ret     z
        jp      .loop

        endmodule

        endif
