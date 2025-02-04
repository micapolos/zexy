        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include key-writer.asm
        include key-table.asm
        include raster.asm

Main
        call    Terminal.Init

        ld      hl, keyWriter
        ld      de, $0818       ; repeatDelay / initialDelay
        call    KeyWriter.Init

.loop
        ld      iy, HandleKeyEvent
        call    KeyTable.Scan

        ld      ix, Terminal.writer
        call    KeyWriter.Update

        call    Raster.FrameWait

        jp      .loop

; Input
;   de - KeyEvent
HandleKeyEvent
        push    ix
        ld      ix, Terminal.writer
        ld      hl, keyWriter
        call    KeyWriter.HandleKeyEvent
        pop     ix
        ret

keyWriter       KeyWriter

        savenex open "built/key-writer-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/key-writer-demo.map"
