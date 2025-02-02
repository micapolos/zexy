        device  zxspectrumnext

        org     $8000

        include l2-320.asm

Main
        call    L2_320.Init

        ld      a, %00100101
        call    L2_320.Fill

        ld      a, %11011011
        call    L2_320.Fill

        ld      a, 0
        call    L2_320.Fill

.loop   jr      .loop

        savenex open "built/l2-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/l2-demo.map"
