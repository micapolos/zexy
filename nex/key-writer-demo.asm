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

        call    KeyWriter.Update

        call    Raster.FrameWait

        jp      .loop

; Input
;   de - KeyEvent
HandleKeyEvent
        ld      hl, keyWriter
        jp      KeyWriter.HandleKeyEvent

keyWriter       KeyWriter

        savenex open "built/key-writer-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/key-writer-demo.map"
