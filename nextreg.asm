        IFNDEF  NEXTREG_LIB
        DEFINE  NEXTREG_LIB
        MODULE  NextReg

CPU_SPEED               EQU     $07
TILEMAP_OFFSET_Y        EQU     $31
MMU_0                   EQU     $50
MMU_1                   EQU     $51
MMU_2                   EQU     $52
MMU_3                   EQU     $53
MMU_4                   EQU     $54
MMU_5                   EQU     $55
MMU_6                   EQU     $56
MMU_7                   EQU     $57

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
