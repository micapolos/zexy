        device  zxspectrumnext

        org     $8000

        include ui.asm
        include ui/frame.asm

Main
        call    UI.Init

        ld      hl, frame

        ld      a, 1
        call    UIFrame.Fill

        ld      a, 145
        call    UIFrame.Fill  ; should use advanced ptr

        ld      a, 67
        call    UIFrame.Stroke  ; should use advanced ptr

.loop   jr      .loop

frame
        UIFrame { { 0, 0 }, { 320, 256 } }
        UIFrame { 20, 20, 280, 216 }
        UIFrame { 30, 30, 260, 196 }

        savenex open "built/ui/frame-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/frame-demo.map"
