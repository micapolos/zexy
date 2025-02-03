        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cursor.asm
        include raster.asm
        include key-table.asm

Main
        call    Terminal.Init

        ld      hl, cursor
        ld      c, $08
        call    Cursor.Init
.loop
        break
        ld      hl, cursor
        call    Cursor.Update

        jr      .loop

cursor  Cursor

        savenex open "built/cursor-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/cursor-demo.map"
