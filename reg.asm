        ifndef  Reg_asm
        define  Reg_asm

        module  Reg

PERIPH_1                equ     $05
.hz60                   equ     %00000100

CPU_SPEED               equ     $07

LINE_INT_CTL            equ     $22
.intRead                equ     %10000000
.ulaIntOff              equ     %00000100
.lineIntOn              equ     %00000010
.lineValMsb             equ     %00000001

LINE_INT_VAL            equ     $23

DAC_A_D                 equ     $2d
TM_OFS_Y                equ     $31
TRANS_COL_FBK           equ     $4a

MMU_0                   equ     $50
MMU_1                   equ     $51
MMU_2                   equ     $52
MMU_3                   equ     $53
MMU_4                   equ     $54
MMU_5                   equ     $55
MMU_6                   equ     $56
MMU_7                   equ     $57

ULA_CTRL                equ     $68
.ulaOff                 equ     %10000000

DISP_CTRL               equ     $69
.l2on                   equ     %10000000

L2_CTRL                 equ     $70

INT_CTL                 equ     $c0
.intTableMask           equ     %11100000
.im2                    equ     %00000001

INT_EN_0                equ     $c4
.expBusInt              equ     %10000000
.line                   equ     %00000010
.ula                    equ     %00000001

INT_EN_1                equ     $c5
.ctc7                   equ     %10000000
.ctc6                   equ     %01000000
.ctc5                   equ     %00100000
.ctc4                   equ     %00010000
.ctc3                   equ     %00001000
.ctc2                   equ     %00000100
.ctc1                   equ     %00000010
.ctc0                   equ     %00000001

INT_EN_2                equ     $c5
.uart1TxEmpty           equ     %01000000
.uart1RxHalfFull        equ     %00100000
.uart1RxAvail           equ     %00010000
.uart0TxEmpty           equ     %00000100
.uart0RxHalfFull        equ     %00000010
.uart0RxAvail           equ     %00000001

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
