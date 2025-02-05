        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include glyph.asm
        include reg.asm
        include mem.asm
        include dma.asm
        include keyboard.asm

Main
        call    L2_320.Init

        ld      de, 320
        ld      hl, BlitRainbow
        ld      (Blit.Bank7Lines256UntilZ.blitLineProc), hl
        ld      hl, $e012       ; start from address $e000, bank $12 (start of L2)
        call    Blit.Bank7Lines256UntilZ

        ld      de, $20
        ld      bc, $100
        ld      hl, $10e0
        ld      a, 0
        call    L2_320.FillRect

        ld      de, $30
        ld      bc, $e0
        ld      hl, $20c0
        ld      a, 56
        call    L2_320.FillRect

        ld      de, $40
        ld      bc, $c0
        ld      hl, $30a0
        ld      a, 165
        call    L2_320.FillRect

        ld      de, $42         ; x
        ld      l, $32          ; y
        ld      a, $ff          ; color
        call    L2_320.PutPixel

        ld      de, $42         ; x
        ld      h, $34          ; y
        ld      bc, $20         ; width
        ld      a, $ff          ; color
        call    L2_320.DrawHLine

.loop
        ; shift = DMA, no shift = CPU
        call    Keyboard.GetModifier
        and     %00000001
        jp      nz, .dma
        ld      hl, ScrollCpu
        jp      .blit
.dma
        ld      hl, ScrollDma
.blit
        ld      de, 320
        ld      (Blit.Bank7Lines256UntilZ.blitLineProc), hl
        ld      hl, $e012       ; start from address $e000, bank $12 (start of L2)
        call    Blit.Bank7Lines256UntilZ

        jp      .loop

BlitRainbow
        ld      b, 0
.loop
        ld      l, b
        ld      (hl), b
        djnz    .loop

        dec     de
        ld      a, d
        or      e
        ret

ScrollCpu
        push    hl
        push    de

        ld      l, 0
        ld      de, hl
        inc     hl
        ld      bc, $00ff
        ldir

        pop     de
        pop     hl

        dec     de
        ld      a, d
        or      e
        ret

ScrollDma
        push    hl
        push    de

        ld      l, 0
        ld      de, hl
        inc     hl
        ld      bc, $00ff
        call    Dma.Copy

        pop     de
        pop     hl

        dec     de
        ld      a, d
        or      e
        ret

        savenex open "built/l2-320-blit-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/l2-320-blit-demo.map"
