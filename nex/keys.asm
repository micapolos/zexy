        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include key-table.asm
        include raster.asm
        include empty.asm
        include key-name.asm

Main
        call    Terminal.Init

        ld      ix, Terminal.printer
        ld      hl, $0001
        call    Printer.MoveTo

.scanLoop
        ld      ix, Terminal.writer
        ld      iy, WriteKey
        call    KeyTable.Scan

        ld      ix, Terminal.printer
        call    Printer.PushCursor

        ld      hl, $0000
        call    Printer.MoveTo

        ld      ix, Terminal.writer
        ld      hl, KeyTable.lines
        ld      b, 10
.writeLoop
        ldi     a, (hl)

        push    bc
        push    hl
        call    Writer.Bin8
        pop     hl
        pop     bc
        djnz    .writeLoop

        ld      ix, Terminal.printer
        call    Printer.PopCursor

        call    Raster.FrameWait

        jp       .scanLoop

WriteKey
        push    af
        and     $3f
        call    KeyName.String
        call    Writer.String

        ld      a, ' '
        call    Writer.Char
        pop     af

        bit     7, a
        jp      z, .keyUp
.keyDown
        ld      hl, .downString
        jp      .write
.keyUp
        ld      hl, .upString
.write
        jp      Writer.StringLine

.downString     dz      "down"
.upString       dz      "up"

        savenex open "built/keys.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/keys.map"
