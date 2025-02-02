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
        ld      ix, Terminal.writer
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
        ld      a, %01000010            ; not-inversed attr
.printKey
        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), a
        pop     af
        call    KeyName.GetChar
        ld      ix, Terminal.writer
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

WriteKey
        push    af
        ld      a, (.didWriteKey)
        or      a
        jp      z, .noComma
.comma
        ld      a, ','
        call    Writer.Char
        ld      a, ' '
        call    Writer.Char
.noComma
        ld      a, 1
        ld      (.didWriteKey), a
        pop     af

        push    af
        and     $3f
        call    KeyName.GetString
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
        jp      Writer.String

.downString     dz      "down"
.upString       dz      "up"
.didWriteKey    db      0

        savenex open "built/keys.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/keys.map"
