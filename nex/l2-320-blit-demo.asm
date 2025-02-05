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
        ld      (L2_320.BlitUntilZ.blitLineProc), hl
        ld      hl, $e012       ; start from address $e000, bank $12 (start of L2)
        call    L2_320.BlitUntilZ

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
        ld      (L2_320.BlitUntilZ.blitLineProc), hl
        ld      hl, $e012       ; start from address $e000, bank $12 (start of L2)
        call    L2_320.BlitUntilZ

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
