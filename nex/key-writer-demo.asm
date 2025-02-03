        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include key-writer.asm
        include key-table.asm

Main
        call    Terminal.Init

.loop
        ld      ix, Terminal.writer
        ld      iy, KeyWriter.Put
        call    KeyTable.Scan

        jp      .loop

        savenex open "built/key-writer-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/key-writer-demo.map"
