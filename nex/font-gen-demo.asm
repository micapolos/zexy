        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include blit.asm
        include reg.asm

Main
        call    L2_320.Init

        ld      a, %00100001
        call    L2_320.Fill

        ld      hl, sysFont.index
        ld      (L2_320.fontPtr), hl

        ld      a, %11011011
        ld      (L2_320.textColor), a

        ld      de, 10
        ld      l, 8
        call    L2_320.MoveTo
        ex      de, hl

        ld      hl, string
        call    L2_320.DrawString

        ; Do the same using macro
        L2_320_DrawString 10, 16, uppercase
        L2_320_DrawString 10, 24, lowercase
        L2_320_DrawString 10, 32, digits
        L2_320_DrawString 10, 40, symbols

.loop   jr      .loop

        lua allpass
        require("sys-font")
        require("font-gen")
        font_gen("sysFont", sys_font)
        endlua

string  dz      "Hello, world!"
uppercase       dz      "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
lowercase       dz      "abcdefghijklmnopqrstuvwxyz"
digits          dz      "0123456789"
symbols         dz      "!@#$%^&*()`~_-+={[}]|\\:;\"'<,>>?/'"

        savenex open "built/font-gen-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/font-gen-demo.map"
