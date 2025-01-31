        device  zxspectrumnext

        org     $8000

        include reg.asm
        include port.asm

Main
        nextreg Reg.ULA_CTRL, Reg.ULA_CTRL.ulaOff
        nextreg Reg.DISP_CTRL, Reg.DISP_CTRL.l2on

        ; Fill sawtooth wave, 256 bytes
        xor     a
        ld      hl, buffer
        ld      b, 0
.fill
        ld      (hl), a
        inc     hl
        add     a, 2
        djnz    .fill

        ; Start DMA
        ld      hl, dmaProgram
        ld      b, dmaProgram.size
        ld      c, Port.DMA
        otir

.loop
        in      a, (Port.DMA)  ; LSB
        and     %11100000
        nextreg Reg.TRANS_COL_FBK, a
        jp      .loop

dmaProgram
        db      %10000011       ; WR6: disable DMA
        db      %01111101       ; WR0: A->B, transfer
        dw      buffer          ; start address A
        dw      buffer.size     ; length
        db      %01010100       ; WR1: port A increment, memory
        db      %00000010       ; cycle length 2
        db      %01111000       ; WR2: port B static, I/O
        db      %00100010       ; cycle length 2, next byte prescalar
        db      %00111000       ; prescalar
        db      %11001101       ; WR4: burst mode
        dw      $dfdf           ; start address B (DAC)
        db      %10100010       ; WR5: auto restart
        db      %11001111       ; WR6: load
        db      %10100111       ; WR6 - initialize read sequence
        db      %10111011       ; WR6 - Read mask
        db      %00000010       ; read counter LSB
        db      %10000111       ; WR6: enable DMA
.size = $ - dmaProgram

buffer  ds      .size
.size   equ     $100

        cspectmap    "sandbox/dma-sound.map"
        savenex open "sandbox/dma-sound.nex", Main, $bfe0
        savenex auto
        savenex close
