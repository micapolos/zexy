        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include reg.asm
        include mem.asm
        include dma.asm
        include keyboard.asm

Main
        call    L2_320.Init

        call    DrawRainbow

        L2_320_FillRect $20, $10, $100, $e0, 0
        L2_320_FillRect $30, $20, $e0, $c0, 56
        L2_320_FillRect $40, $30, $c0, $a0, 165
        L2_320_PutPixel $42, $32, $ff

        L2_320_DrawHLine $42, $34, $20, $ff
        L2_320_DrawVLine $42, $36, $20, $ff
        L2_320_DrawRect  $50, $40, $a0, $80, 111

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

DrawRainbow
        ld      de, 320
        ld      hl, BlitRainbow
        ld      (Blit.Bank7Lines256UntilZ.blitLineProc), hl
        ld      hl, $e012       ; start from address $e000, bank $12 (start of L2)
        jp     Blit.Bank7Lines256UntilZ

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
