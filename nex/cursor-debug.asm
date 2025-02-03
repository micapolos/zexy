        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cursor.asm
        include raster.asm
        include sprite.asm
        include cursor-sprite.asm

Main
        call    Terminal.Init

        ld      hl, cursor
        ld      c, $08
        call    Cursor.Init
        break
.loop
        ld      b, $0c
.updateLoop
        push    bc
        ld      hl, cursor
        call    Cursor.Update
        ld      hl, cursor
        ld      de, sprite
        call    CursorSprite.Sync
        pop     bc
        break
        djnz    .updateLoop

        ld      hl, cursor
        ld      bc, $123
        ld      e, $45
        call    Cursor.Move
        break

        jr      .loop

cursor  Cursor
sprite  Sprite { $ff, $ff, $fe, $7f, $ff }

        savenex open "built/cursor-debug.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/cursor-debug.map"
