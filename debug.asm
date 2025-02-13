        ifndef  Debug_asm
        define  Debug_asm

        include port.asm

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

; ===================================================================
; Wait until space key is pressed
WaitSpace
        ld      bc, $7ffe
.upLoop
        in      a, (c)
        and     %00000001
        jp      z, .upLoop
.downLoop
        in      a, (c)
        and     %00000001
        jp      nz, .downLoop
.end
        ret

; ===================================================================

ClearRegs
        xor     a
        ld      b, a
        ld      c, a
        ld      d, a
        ld      e, a
        ld      h, a
        ld      l, a
        ret

        endmodule

        endif
