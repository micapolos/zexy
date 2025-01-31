        ifndef  Reg_asm
        define  Reg_asm

        module  Reg

CPU_SPEED               equ     $07
DAC_A_D                 equ     $2d
TILEMAP_OFFSET_Y        equ     $31
TRANS_COLOR_FALLBACK    equ     $4a
MMU_0                   equ     $50
MMU_1                   equ     $51
MMU_2                   equ     $52
MMU_3                   equ     $53
MMU_4                   equ     $54
MMU_5                   equ     $55
MMU_6                   equ     $56
MMU_7                   equ     $57
ULA_CTRL                equ     $68
.disabled               equ     %10000000
L2_CTRL                 equ     $70

; Input:
;   A - register
; Output:
;   A - value
;   BC, DE, HL - preserved
Read:
        push    bc
        ld      bc, $243b
        out     (c), a
        inc     b
        in      a, (c)
        pop     bc
        ret

        endmodule

        endif
