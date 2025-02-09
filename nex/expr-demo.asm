        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include debug.asm

        lua allpass
        require("expr")
        endlua

Main
        call    Terminal.Init
        ld      ix, Terminal.writer

        lua allpass

        exec(
          loop(
            writeln("Hello, world!"),
            write("value is: "),
            store("value", inc(load16("value"))),
            writeln(load16("value")),
            waitSpace()))

        endlua

value  dw      $1234

        savenex open "built/expr-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/expr-demo.map"
