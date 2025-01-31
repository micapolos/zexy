        device  zxspectrumnext

        org     $8000

        include nextreg.asm

Main
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

.loop   jp      .loop

dmaProgram
        db      %10000011       ; WR6: disable DMA
        db      %01111101       ; WR0: A->B, transfer
        dw      buffer          ; start address A
        dw      buffer.size     ; length
        db      %00010100       ; WR1: port A increment, memory
        db      %01111000       ; WR2: port B static, I/O
        db      %00100000       ; cycle length 4, next byte prescalar
        db      %00001000       ; prescalar
        db      %11001101       ; WR4: burst mode
        dw      $dfdf           ; start address B (DAC)
        db      %10100010       ; WR5: auto restart
        db      %11001111       ; WR6: load
        db      %10000111       ; WR6: enable DMA
.size = $ - dmaProgram

buffer  ds      .size
.size   equ     $100

        cspectmap "sandbox/dma-sound.map"
        savenex open "sandbox/dma-sound.nex", Main, $bfe0
        savenex auto
        savenex close
