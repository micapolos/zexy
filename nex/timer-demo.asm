        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include timer.asm
        include raster.asm

Main
        call    Terminal.Init

        ld      hl, timer
        ld      de, Fire
        call    Timer.Init

        ld      hl, timer
        ld      a, $20
        call    Timer.Start

.loop
        ld      hl, timer
        call    Timer.Update

        call    Raster.FrameWait
        jr      .loop

Fire
        ; restart timer
        ld      hl, timer
        ld      a, $08
        call    Timer.Start

        ; write *
        ld      ix, Terminal.writer
        ld      a, (char)
        inc     a
        ld      (char), a
        jp      Writer.Char

timer   Timer
char    db      $20

        savenex open "built/timer-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/timer-demo.map"
