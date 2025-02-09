        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include key-table.asm
        include raster.asm
        include empty.asm
        include key-name.asm
        include key-code.asm
        include key.asm

Main
        call    Terminal.Init

        ld      ix, Terminal.printer
        ld      hl, $0002
        call    Printer.MoveTo

.scanLoop
        ld      ix, eventPrinter
        ld      iy, WriteKey
        call    KeyTable.Scan

        ld      ix, Terminal.printer
        call    Printer.PushCursor
        call    Printer.PushAttr

        ld      hl, $0000
        call    Printer.MoveTo

        ld      a, 0
        ld      b, KeyCode.count
.writeLoop
        push    bc
        push    af
        push    af
        call    Key.IsPressed
        jp      z, .notPressed
        ld      a, %00001010            ; inverse attr
        jp      .printKey
.notPressed
        ld      a, %01000000            ; not-inversed attr
.printKey
        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), a
        pop     af
        call    KeyName.GetChar
        call    Writer.Char
        pop     af
        pop     bc
        inc     a
        djnz    .writeLoop

        ld      ix, Terminal.printer
        call    Printer.PopAttr
        call    Printer.PopCursor

        call    Raster.FrameWait

        jp       .scanLoop

; Input
;   de - KeyEvent
WriteKey
        push    de
        ld      a, d    ; modifiers
        call    Writer.Bin8
        ld      a, ' '
        call    Writer.Char
        pop     de

        ld      a, e
        call    KeyName.GetString
        call    Writer.String

        jp      Writer.NewLine

.downString     dz      "down"
.upString       dz      "up"

eventPrinter
        Printer {
          { tileMap + 80*2*2 + 25*2, { 30, 30 }, 50 },
          { 0, 0 },
          %11100000
        }

        savenex open "built/key-event-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/key-event-demo.map"
