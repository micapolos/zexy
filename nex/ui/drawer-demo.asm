        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include ui/drawer.asm
        include ui/frame.asm
        include ui/coord.asm

Main
        call    L2_320.Init

        ; Direct fill
        ld      a, $12
        ld      hl, frame
        call    UIDrawer.Fill

        ; Fill proc
        ld      hl, fill
        call    UIDrawer.InitFill

        ; Draw through fill proc
        ld      a, $16
        ld      (UIDrawer.color), a
        ld      hl, 20
        ld      (frame.origin.x), hl
        ld      hl, 16
        ld      (frame.origin.y), hl
        ld      hl, 280
        ld      (frame.size.width), hl
        ld      hl, frame
        call    fill

        ; Draw through fill proc
        ld      a, $60
        ld      (UIDrawer.color), a
        ld      hl, 30
        ld      (frame.origin.x), hl
        ld      hl, 32
        ld      (frame.origin.y), hl
        ld      hl, 260
        ld      (frame.size.width), hl
        ld      hl, frame
        call    fill

.loop   jr      .loop

frame   UIFrame { 10, 0, 300, 8 }
fill    ds      UIDrawer.Fill.size

        savenex open "built/ui/drawer-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/drawer-demo.map"
