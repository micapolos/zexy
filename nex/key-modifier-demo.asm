        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include keyboard.asm
        include key-modifier.asm
        include printer.asm
        include writer.asm

Main
        call    Terminal.Init
.loop
        call    Keyboard.GetModifier

        ld      ix, Terminal.printer
        ld      hl, $2408
        call    Printer.MoveTo

        call    Writer.Bin8

        jr      .loop

        savenex open "built/key-modifier-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/key-modifier-demo.map"
