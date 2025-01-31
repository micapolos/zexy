        device  zxspectrumnext

        org     $8000

        include nextreg.asm

Main
        nextreg NextReg.ULA_CONTROL, %10000000  ; disable ula

        ; Fill triangle wave, 256 bytes
        xor     a
        ld      hl, buffer

        ld      b, 128
.fillUp
        ld      (hl), a
        inc     hl
        inc     a
        inc     a
        djnz    .fillUp

        ld      b, 128
.fillDown
        dec     a
        dec     a
        ld      (hl), a
        inc     hl
        djnz    .fillDown

        ; Start DMA
        ld      hl, dmaProgram
        ld      b, dmaProgram.size
        ld      c, $6b
        otir

.loop
        ld      a, %10111011    ; WR6 - Read mask
        ld      ($6b), a
        ld      a, %10000010    ; counter LSB
        ld      ($6b), a
        ld      a, %10100111    ; WR6 - initialize read sequence
        ld      ($6b), a
        in      a, ($6b)
        nextreg NextReg.TRANS_COLOR_FALLBACK, a
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
        db      %00001000       ; prescalar
        db      %11001101       ; WR4: burst mode
        dw      $dfdf           ; start address B (DAC)
        db      %10100010       ; WR5: auto restart
        db      %11001111       ; WR6: load
        db      %10000111       ; WR6: enable DMA
.size = $ - dmaProgram

buffer  ds      .size
.size   equ     $100

        cspectmap    "sandbox/dma-sound.map"
        savenex open "sandbox/dma-sound.nex", Main, $bfe0
        savenex auto
        savenex close
