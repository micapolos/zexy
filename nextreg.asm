        IFNDEF  NEXTREG_LIB
        DEFINE  NEXTREG_LIB
        MODULE  NextReg

; Input:
;   A - register
; Output:
;   A - value
Read:
        push    bc
        ld      bc, $243b
        out     (c), a
        inc     b
        in      a, (c)
        pop     bc
        ret

        ENDMODULE
        ENDIF
