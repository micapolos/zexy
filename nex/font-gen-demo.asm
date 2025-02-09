        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include blit.asm
        include reg.asm

Main
        call    L2_320.Init

        ld      a, %00100001
        call    L2_320.Fill

        nextreg Reg.MMU_7, 18
        ld      hl, sysFont
        ld      de, $e100
        ld      bc, sysFont.dataSize
        ld      a, %11011011
        call    Blit.Copy8BitLines

.loop   jr      .loop

        lua allpass
        require("sys-font")
        require("font-gen")
        font_gen("sysFont", sys_font)
        endlua

        savenex open "built/font-gen-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/font-gen-demo.map"
