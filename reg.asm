        ifndef  Reg_asm
        define  Reg_asm

        include port.asm

        module  Reg

TIMING                  equ     $03
.zx48                   equ     %00010000

PERIPH_1                equ     $05
.hz60                   equ     %00000100

CPU_SPEED               equ     $07

SPR_LAY_SYS             equ     $15
.sprOverBord            equ     %00000010
.sprOn                  equ     %00000001

CLIP_WND_L2             equ     $18

CLIP_WND_CTL            equ     $1c
.resTmIdx               equ     %00001000
.resUlaRegIdx           equ     %00000100
.resSprRegIdx           equ     %00000010
.resL2RegIdx            equ     %00000001

LINE_INT_CTL            equ     $22
.intRead                equ     %10000000
.ulaIntOff              equ     %00000100
.lineIntOn              equ     %00000010
.lineValMsb             equ     %00000001

LINE_INT_VAL            equ     $23

DAC_A_D                 equ     $2d
TM_OFS_Y                equ     $31

SPR_IDX                 equ     $34
SPR_ATTR_0              equ     $35
SPR_ATTR_1              equ     $36
SPR_ATTR_2              equ     $37
SPR_ATTR_3              equ     $38
SPR_ATTR_4              equ     $39

PAL_IDX                 equ     $40
PAL_VAL8                equ     $41
SPR_TRANS_IDX           equ     $4b

PAL_CTRL                equ     $43
.palAutoIncOff          equ     %10000000
.rwUlaPal1              equ     %00000000
.rwUlaPal2              equ     %00010000
.rwL2PalL1              equ     %00100000
.rwL2PalL2              equ     %00110000
.rwSprPal1              equ     %01000000
.rwSprPal2              equ     %01010000
.rwTmPal1               equ     %01100000
.rwTmPal2               equ     %01110000
.selSprPal2             equ     %00001000
.selL2Pal2              equ     %00000100
.selUlaPal2             equ     %00000010
.ulaNextMode            equ     %00000001

PAL_VAL9                equ     $44

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
.extKeysOff             equ     %00010000

DISP_CTRL               equ     $69
.l2on                   equ     %10000000

L2_CTRL                 equ     $70
.mode256                equ     %00000000
.mode320                equ     %00010000
.mode640                equ     %00100000

SPR_ATTR_0_INC          equ     $75
SPR_ATTR_1_INC          equ     $76
SPR_ATTR_2_INC          equ     $77
SPR_ATTR_3_INC          equ     $78
SPR_ATTR_4_INC          equ     $79

EXT_KEYS_0              equ     $b0
EXT_KEYS_1              equ     $b1

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

INT_EN_2                equ     $c6
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
        ld      bc, Port.ACTIVE_REG
        out     (c), a
        inc     b
        in      a, (c)
        pop     bc
        ret

        endmodule

        endif
