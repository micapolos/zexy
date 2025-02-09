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
        writeln("Hello, world!")
        write("value is: ")
        store("value", inc(load16("value")))
        writeln(load16("value"))
        endlua
        jr      .loop

value  dw      $1234

        savenex open "built/expr-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/expr-demo.map"
