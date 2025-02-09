        device  zxspectrumnext

        org     $8000

        include terminal.asm

        lua allpass
        require("expr")
        endlua

Main
        call    Terminal.Init
        ld      ix, Terminal.writer

.loop
        lua allpass
        ld_hl(store16("value", inc16(load16("value"))))
        endlua
        jr      .loop

value  dw      0

        savenex open "built/expr-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/expr-demo.map"
