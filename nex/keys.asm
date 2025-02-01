        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include key-table.asm
        include raster.asm

Main
        call    Terminal.Init

.scanLoop
        ld      hl, keyTable
        call    KeyTable.Scan

        ld      ix, Terminal.printer
        ld      hl, $0000
        call    Printer.MoveTo

        ld      ix, Terminal.writer
        ld      hl, keyTable
        ld      b, 10
.writeLoop
        ldi     a, (hl)
        inc     hl

        push    bc
        push    hl
        call    Writer.Bin8
        pop     hl
        pop     bc
        djnz    .writeLoop

        call    Raster.FrameWait

        jp       .scanLoop

keyTable        KeyTable

        savenex open "built/keys.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/keys.map"
