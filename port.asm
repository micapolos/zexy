        ifndef  Port_asm
        define  Port_asm

        module  Port

L2_ACCESS       equ     $123b
ULA             equ     $fe
DMA             equ     $6b
ACTIVE_REG      equ     $243b
REG_RW          equ     $253b
SPR_SEL         equ     $303b
SPR_PAT_LD      equ     $5b

        endmodule

        endif
