        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cmd/ls.asm

Main
        call    Terminal.Init

        ld      ix, Terminal.writer

        ld      hl, string.hello
        call    Writer.String

        call    Writer.NewLine

        ld      a, $1
        call    Writer.Nibble

        ld      a, $23
        call    Writer.Hex8

        ld      hl, $4567
        call    Writer.Hex16

        call    Writer.NewLine

        call    CmdLs.Exec

.loop   jp      .loop

string
.hello  dz      "Hello, everyone!!!"

        savenex open "built/sandbox/console.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/sandbox/console.map"
