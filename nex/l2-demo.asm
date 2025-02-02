        device  zxspectrumnext

        org     $8000

        include reg.asm
        include mem.asm
        include l2-320.asm

Main
        nextreg Reg.CPU_SPEED, 0
        call    L2_320.Init

        ld      a, 165
        call    L2_320.Fill

        ld      a, 0
        call    L2_320.Fill

.loop   jr      .loop

        savenex open "built/l2-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/l2-demo.map"
