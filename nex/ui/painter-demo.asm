        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include ui/painter.asm

Main
        call    L2_320.Init

        ld      hl, painter
        call    UIPainter.Fill
        call    UIPainter.Fill  ; should use advanced painter

.loop   jr      .loop

painter
        UIPainter { { { 0, 0 }, { 320, 256 } }, 1 }
        UIPainter { 20, 20, 280, 216, 145 }

        savenex open "built/ui/painter-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/painter-demo.map"
