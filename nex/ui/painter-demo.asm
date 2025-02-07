        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include ui/painter.asm
        include struct.asm
        include ui/alignment.asm

Main
        call    L2_320.Init

        ld      hl, painter
        call    UIPainter.Fill
        call    UIPainter.Fill    ; should use advanced ptr
        call    UIPainter.Stroke  ; should use advanced ptr

        ld      hl, innerPainter
        ld      de, $0003       ; x
        ld      bc, $0002       ; y
        ld      a, UIAlignment.left | UIAlignment.top
        call    UIPainter.Point

        ld      hl, innerPainter
        ld      de, $0003       ; x
        ld      bc, $0002       ; y
        ld      a, UIAlignment.right | UIAlignment.top
        call    UIPainter.Point

        ld      hl, innerPainter
        ld      de, $0003       ; x
        ld      bc, $0002       ; y
        ld      a, UIAlignment.left | UIAlignment.bottom
        call    UIPainter.Point

        ld      hl, innerPainter
        ld      de, $0003       ; x
        ld      bc, $0002       ; y
        ld      a, UIAlignment.right | UIAlignment.bottom
        call    UIPainter.Point

.loop   jr      .loop

painter
        UIPainter { { { 0, 0 }, { 320, 256 } }, 1 }
        UIPainter { 20, 20, 280, 216, 145 }
innerPainter
        UIPainter { 30, 30, 260, 196, 4 }

        savenex open "built/ui/painter-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/painter-demo.map"
