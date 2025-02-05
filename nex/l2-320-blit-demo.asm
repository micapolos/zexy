        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include glyph.asm
        include reg.asm

Main
        call    L2_320.Init
.loop
        ld      de, 320
        ld      hl, BlitLine
        ld      (L2_320.BlitUntilZ.blitLineProc), hl
        ld      hl, $e012       ; start from address $e000, bank $12 (start of L2)
        call    L2_320.BlitUntilZ

        ld      hl, BlitLine.offset
        inc     (hl)

        jp      .loop

BlitLine
.offset+*       ld      l, 0
        ld      b, 0
.loop
        ld      (hl), b
        inc     l
        djnz    .loop

        dec     de
        ld      a, d
        or      e
        ret

        savenex open "built/l2-320-blit-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/l2-320-blit-demo.map"
