        device  zxspectrumnext

        org     $8000

        include debug.asm
        include l2-320.asm
        include ui.asm
        include ui/draw.asm
        include ui/frame.asm
        include ui/coord.asm
        include ui/size.asm

        lua allpass
        require("sys-font")
        require("sys-bold-font")
        require("font-gen")
        font_gen("fontNormal", sys_font)
        font_gen("fontBold", sys_bold_font)
        endlua

Main
        call    UI.Init

        ; Point 1
        ld      a, $16
        ld      (UIDraw.color), a
        ld      hl, 0
        ld      (UIDraw.frame.origin.x), hl
        ld      hl, 0
        ld      (UIDraw.frame.origin.y), hl
        call    Debug.ClearRegs
        call    UIDraw.Pixel

        ; Point 1
        ld      a, $60
        ld      (UIDraw.color), a
        ld      hl, 319
        ld      (UIDraw.frame.origin.x), hl
        ld      hl, 255
        ld      (UIDraw.frame.origin.y), hl
        call    Debug.ClearRegs
        call    UIDraw.Pixel

        ; Fill 1
        ld      a, $16
        ld      (UIDraw.color), a
        ld      hl, 20
        ld      (UIDraw.frame.origin.x), hl
        ld      hl, 16
        ld      (UIDraw.frame.origin.y), hl
        ld      hl, 280
        ld      (UIDraw.frame.size.width), hl
        ld      hl, 8
        ld      (UIDraw.frame.size.height), hl
        call    Debug.ClearRegs
        call    UIDraw.Fill

        ; Fill 2
        ld      a, $60
        ld      (UIDraw.color), a
        ld      hl, 30
        ld      (UIDraw.frame.origin.x), hl
        ld      hl, 32
        ld      (UIDraw.frame.origin.y), hl
        ld      hl, 260
        ld      (UIDraw.frame.size.width), hl
        ld      hl, 8
        ld      (UIDraw.frame.size.height), hl
        call    Debug.ClearRegs
        call    UIDraw.Fill

        ; Text 1
        ld      a, $12
        ld      (UIDraw.color), a
        ld      hl, 50
        ld      (UIDraw.frame.origin.x), hl
        ld      hl, 50
        ld      (UIDraw.frame.origin.y), hl
        ld      hl, fontBold.index
        ld      (UIDraw.font), hl
        call    Debug.ClearRegs
        ld      hl, string.line1
        call    UIDraw.Text

        ; Text 2
        ld      a, $18
        ld      (UIDraw.color), a
        ld      hl, 50
        ld      (UIDraw.frame.origin.x), hl
        ld      hl, 58
        ld      (UIDraw.frame.origin.y), hl
        ld      hl, fontNormal.index
        ld      (UIDraw.font), hl
        call    Debug.ClearRegs
        ld      hl, string.line2
        call    UIDraw.Text

.loop   jr      .loop

string
.line1  dz      "Hello, world!"
.line2  dz      "How are you doin'?"

        savenex open "built/ui/draw-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/draw-demo.map"
