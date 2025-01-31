        ifndef  Debug_asm
        define  Debug_asm

        module  Debug

        macro   DebugWait count
        push    af
        push    bc
        push    de
        push    hl
        ld      bc, count
        call    Debug.Wait
        pop     hl
        pop     de
        pop     bc
        pop     af
        endm

; Input
;   bc - counter
Wait
.loop   dec     bc
        ld      a, b
        or      c
        ret     z
        jp      .loop

        endmodule

        endif
