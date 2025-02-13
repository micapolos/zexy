        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include ui/drawer.asm
        include ui/frame.asm
        include ui/coord.asm
        include ui/size.asm

Main
        call    L2_320.Init

        ld      a, $16
        ld      (UIDrawer.color), a
        ld      hl, 20
        ld      (UIDrawer.frame.origin.x), hl
        ld      hl, 16
        ld      (UIDrawer.frame.origin.y), hl
        ld      hl, 280
        ld      (UIDrawer.frame.size.width), hl
        ld      hl, 8
        ld      (UIDrawer.frame.size.height), hl
        call    UIDrawer.Fill

        ; Draw through fill proc
        ld      a, $60
        ld      (UIDrawer.color), a
        ld      hl, 30
        ld      (UIDrawer.frame.origin.x), hl
        ld      hl, 32
        ld      (UIDrawer.frame.origin.y), hl
        ld      hl, 260
        ld      (UIDrawer.frame.size.width), hl
        ld      hl, 8
        ld      (UIDrawer.frame.size.height), hl
        call    UIDrawer.Fill

.loop   jr      .loop

        savenex open "built/ui/drawer-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/drawer-demo.map"
