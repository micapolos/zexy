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
        ld      hl, $0000
        call    Printer.MoveTo

        ld      ix, Terminal.writer
        ld      a, 'A'
        call    Writer.Char

        ld      ix, Terminal.tilebuffer
        call    Tilebuffer.Push

        ld      ix, Terminal.tilebuffer
        ld      de, $0802
        ld      bc, $401c
        call    Tilebuffer.Cut

        ld      de, (%01000000 << 8) | 'x'
        call    Tilebuffer.Fill

        ld      ix, Terminal.printer
        ld      hl, $0000
        call    Printer.MoveTo

        ld      ix, Terminal.writer
        ld      a, 'B'
        call    Writer.Char

        ld      ix, Terminal.tilebuffer
        call    Tilebuffer.Push

        ld      de, $0101
        ld      bc, $3e1a
        call    Tilebuffer.Cut

        ld      de, (%01000000 << 8) | ' '
        call    Tilebuffer.Fill

        ld      ix, Terminal.printer
        ld      hl, $0000
        call    Printer.MoveTo

        ld      ix, Terminal.writer
        ld      a, 'C'
        call    Writer.Char

        ld      ix, Terminal.tilebuffer
        call    Tilebuffer.Pop

        ld      ix, Terminal.printer
        ld      hl, $0100
        call    Printer.MoveTo

        ld      ix, Terminal.writer
        ld      a, 'D'
        call    Writer.Char

        ld      ix, Terminal.tilebuffer
        call    Tilebuffer.Pop

        ld      ix, Terminal.printer
        ld      hl, $0100
        call    Printer.MoveTo

        ld      ix, Terminal.writer
        ld      a, 'E'
        call    Writer.Char

.loop   jr      .loop

        savenex open "built/tilebuffers.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/tilebuffers.map"
