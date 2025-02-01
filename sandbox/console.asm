        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cmd/ls.asm
        include cmd/cat.asm
        include debug.asm

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

        ld      hl, string.pressSpace
        call    Writer.StringLine
        call    Debug.WaitSpace

        call    CmdLs.Exec

        ld      hl, string.pressSpace
        call    Writer.StringLine
        call    Debug.WaitSpace

        ld      hl, string.filename
        call    CmdCat.Exec

.loop   jp      .loop

string
.hello          dz      "Hello, everyone. This is Zexy console!!!"
.pressSpace     dz      "Press space to continue..."
.filename       dz      "console.lst"

        savenex open "built/sandbox/console.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/sandbox/console.map"
