        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include tilebuffer.asm
        include printer.asm

Main
        call    Terminal.Init

        ld      ix, Terminal.tilebuffer
        ld      de, (%00100000 << 8) | '.'
        call    Tilebuffer.Fill

        ld      ix, Terminal.printer
        ld      hl, $0100
        call    Printer.MoveTo

        ld      hl, string.tilebuffer1
        call    Writer.String

        ld      ix, Terminal.tilebuffer
        call    Tilebuffer.Push

        ld      ix, Terminal.tilebuffer
        ld      de, $0802
        ld      bc, $401c
        call    Tilebuffer.Cut

        ld      de, (%01000000 << 8) | 'x'
        call    Tilebuffer.Fill

        ld      ix, Terminal.printer
        ld      hl, $0100
        call    Printer.MoveTo

        ld      hl, string.tilebuffer2
        call    Writer.String

        ld      ix, Terminal.tilebuffer
        call    Tilebuffer.Push

        ld      de, $0202
        ld      bc, $3c18
        call    Tilebuffer.Cut

        ld      de, (%01000000 << 8) | ' '
        call    Tilebuffer.Fill

        ld      ix, Terminal.printer
        ld      hl, $0100
        call    Printer.MoveTo

        ld      hl, string.tilebuffer3
        call    Writer.String

        ld      ix, Terminal.printer
        ld      hl, $0000
        call    Printer.MoveTo

        ld      a, '*'
        call    Writer.Char

        ld      ix, Terminal.tilebuffer
        call    Tilebuffer.Pop

        ld      ix, Terminal.printer
        ld      hl, $0000
        call    Printer.MoveTo

        ld      a, '*'
        call    Writer.Char

        ld      ix, Terminal.tilebuffer
        call    Tilebuffer.Pop

        ld      ix, Terminal.printer
        ld      hl, $0000
        call    Printer.MoveTo

        ld      a, '*'
        call    Writer.Char

.loop   jr      .loop

string
.tilebuffer1    dz      "Tilebuffer1"
.tilebuffer2    dz      "Tilebuffer2"
.tilebuffer3    dz      "Tilebuffer3"


        savenex open "built/tilebuffers.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/tilebuffers.map"
