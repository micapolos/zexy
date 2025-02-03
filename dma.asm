        ifndef  Dma_asm
        define  Dma_asm

        include port.asm

        module  Dma

; =========================================================
; Input
;   de - dst
;   bc - size
;   a - value
Fill
        ld      hl, program.len
        ld      (hl), bc

        ld      hl, program.startB
        ld      (hl), de

        ld      hl, program.startA
        ld      bc, program.value
        ld      (hl), bc

        ld      (program.value), a

        ld      hl, program
        ld      b, program.size
        ld      c, Port.DMA
        otir

        ret

; =========================================================
; Input
;   de - dst
;   bc - size
;   a - value
Copy
        ld      hl, program.startA
        ld      (hl), program.value

        ld      hl, program.len
        ld      (hl), bc

        ld      hl, program.startB
        ld      (hl), de

        ld      (program.value), a

        ld      hl, program
        ld      b, program.size
        ld      c, Port.DMA
        otir

        ret

; =========================================================
program
        db      %10000011       ; WR6: disable DMA
        db      %01111101       ; WR0: A->B, transfer
.startA dw      0               ; start address A
.len    dw      0               ; length
        db      %00110100       ; WR1: port A static, memory
        db      %00010000       ; WR2: port B increment, memory
        db      %10101101       ; WR4: continuous mode
.startB dw      0               ; start address B
        db      %10000010       ; WR5: stop on end
        db      %11001111       ; WR6: load
        db      %10000111       ; WR6: enable DMA
.size   equ     $ - program
.value  db      0

        endmodule

        endif
