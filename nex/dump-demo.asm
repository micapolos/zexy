        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include dump.asm

Main
        call    Terminal.Init

        ld      hl, 0
        ld      c, 16
        call    Writer.DumpLine
        ld      c, 16
        call    Writer.DumpLine
        ld      c, 8
        call    Writer.DumpLine

        call    Writer.NewLine

        ld      hl, 0
        ld      bc, $93
        call    Writer.Dump

.end    jp      .end

        savenex open "built/dump-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/dump-demo.map"
