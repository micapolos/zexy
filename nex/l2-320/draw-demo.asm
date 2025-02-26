        device  zxspectrumnext

        org     $8000

        include l2-320/draw.asm

Main
        call    L2_320_Draw.Init

        ld      hl, fill
        call    L2_320_Draw.DrawFill

        ld      hl, filledRect
        call    L2_320_Draw.DrawFilledRect

        ld      hl, patch
        call    L2_320_Draw.DrawPatch
.loop
        jr      .loop

fill
        L2_320_Draw.Fill { $01 }

filledRect
        L2_320_Draw.FilledRect { 10, 10, 300, 236, $02 }

patch
        L2_320_Draw.Patch { 20, 20, .data, 7, 8, 10 }
.data
        db      $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00
        db      $ff, $40, $ff, $40, $40, $40, $40, $ff, $00, $00
        db      $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00
        db      $ff, $40, $ff, $40, $40, $40, $40, $ff, $00, $00
        db      $ff, $40, $ff, $40, $40, $40, $40, $ff, $00, $00
        db      $ff, $40, $ff, $40, $40, $40, $40, $ff, $00, $00
        db      $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00

        savenex open "built/l2-320/draw-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/l2-320/draw-demo.map"
