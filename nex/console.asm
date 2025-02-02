        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cmd/ls.asm
        include cmd/cat.asm
        include cmd/pwd.asm
        include debug.asm

Main
        call    Terminal.Init

        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), %01000010

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

        ; Set system drive
        ld      a, '$'
        rst     $08
        db      EsxDOS.getSetDrv
        jp      c, .error

        ld      hl, string.prompt
        call    Writer.String
        call    Debug.WaitSpace

        ld      hl, string.pwd
        call    Writer.StringLine
        call    Debug.WaitSpace

        call    CmdPwd.Exec

        ld      hl, string.prompt
        call    Writer.String
        call    Debug.WaitSpace

        ld      hl, string.ls
        call    Writer.StringLine
        call    Debug.WaitSpace

        call    CmdLs.Exec

        ld      hl, string.prompt
        call    Writer.String
        call    Debug.WaitSpace

        ld      hl, string.cat
        call    Writer.String
        ld      a, ' '
        call    Writer.Char
        ld      hl, string.filename
        call    Writer.StringLine
        call    Debug.WaitSpace

        ld      hl, string.filename
        call    CmdCat.Exec

.loop   jp      .loop
.error  jp      .loop

string
.hello          dz      "Hello, everyone. This is Zexy console!!!"
.filename       dz      "readme.md"
.prompt         dz      "> "
.pwd            dz      "pwd"
.ls             dz      "ls"
.cat            dz      "cat"

        savenex open "built/console.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/console.map"
