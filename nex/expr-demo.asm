        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include debug.asm

        lua allpass
        require("nex/expr-demo")
        endlua

Main
        call    Terminal.Init
        ld      ix, Terminal.writer

        lua allpass
        expr_demo()
        endlua

value  dw      $1234

        savenex open "built/expr-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/expr-demo.map"
