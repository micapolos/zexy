        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cmd/ls.asm
        include cmd/cat.asm
        include esxdos.asm
        include debug.asm

Main
        call    Terminal.Init

        ld      ix, Terminal.printer

        ld      (ix + Printer.attr), %10000010
        ld      a, 'Z'
        call    Printer.Put

        ld      (ix + Printer.attr), %11000010
        ld      a, 'E'
        call    Printer.Put

        ld      (ix + Printer.attr), %01000010
        ld      a, 'X'
        call    Printer.Put

        ld      (ix + Printer.attr), %01100010
        ld      a, 'Y'
        call    Printer.Put

        ld      (ix + Printer.attr), %11100000

        ld      hl, string.os
        call    Writer.StringLine
        call    Writer.NewLine

        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), %11100000

        ; Set system drive
        ld      a, '$'
        rst     $08
        db      EsxDOS.getSetDrv
        jp      c, .error

.loop
        call    WritePrompt
        call    Debug.WaitSpace

        ld      hl, string.ls
        call    Writer.StringLine
        call    Debug.WaitSpace

        call    CmdLs.Exec

        call    WritePrompt
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

        jp      .loop
.error  jp      .loop

WritePrompt
        ld      a, '*'
        push    ix
        ld      ix, .buffer
        rst     $08
        db      EsxDOS.getCwd
        pop     ix

        ld      hl, .buffer
        call    Writer.String
        ld      hl, string.prompt
        jp      Writer.String
.buffer         ds 256

string
.os             dz      " v0.1"
.filename       dz      "readme.md"
.prompt         dz      "> "
.pwd            dz      "pwd"
.ls             dz      "ls"
.cat            dz      "cat"

        savenex open "built/console.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/console.map"
