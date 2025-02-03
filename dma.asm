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

        ld      hl, program.wr0
        ld      (hl), %01111101       ; A->B, transfer

        ld      hl, program.wr1
        ld      (hl), %00110100       ; WR1: port A static, memory

        ld      hl, program.wr2
        ld      (hl), %00010000       ; WR2: port B increment, memory

        ld      hl, program.startA
        ld      bc, program.value
        ld      (hl), bc

        ld      (program.value), a

        jp      LoadProgram

; =========================================================
; Input
;   hl - src
;   de - dst
;   bc - size
;   a - value
Copy
        push    hl
        ld      bc, hl
        ld      hl, program.startA
        ld      (hl), bc
        pop     hl

        ld      hl, program.len
        ld      (hl), bc

        ld      hl, program.startB
        ld      (hl), de

        ld      hl, program.wr0
        ld      (hl), %01111101       ; A->B, transfer

        ld      hl, program.wr1
        ld      (hl), %00010100       ; WR1: port A increment, memory

        ld      hl, program.wr2
        ld      (hl), %00010000       ; WR2: port B increment, memory

        jp      LoadProgram

; =========================================================
; Input
;   hl - src ptr
;   de - dst port
;   bc - size
CopyToPort
        push    hl
        ld      bc, hl
        ld      hl, program.startA
        ld      (hl), bc
        pop     hl

        ld      hl, program.len
        ld      (hl), bc

        ld      hl, program.startB
        ld      (hl), de

        ld      hl, program.wr0
        ld      (hl), %01111101       ; A->B, transfer

        ld      hl, program.wr1
        ld      (hl), %00010100       ; WR1: port A increment, memory

        ld      hl, program.wr2
        ld      (hl), %00101000       ; WR2: port B static, I/O

        jp      LoadProgram

@LoadProgram
        ld      hl, program
        ld      b, program.size
        ld      c, Port.DMA
        otir
        ret

; =========================================================
program
        db      %10000011       ; WR6: disable DMA
.wr0    db      0               ; WR0
.startA dw      0               ; start address A
.len    dw      0               ; length
.wr1    db      0               ; WR1
.wr2    db      0               ; WR2
        db      %10101101       ; WR4: continuous mode
.startB dw      0               ; start address B
        db      %10000010       ; WR5: stop on end
        db      %11001111       ; WR6: load
        db      %10000111       ; WR6: enable DMA
.size   equ     $ - program
.value  db      0

        endmodule

        endif
