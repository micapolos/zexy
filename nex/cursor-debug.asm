        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cursor.asm
        include raster.asm
        include sprite.asm
        include cursor-sprite.asm

Main
        call    Terminal.Init

        nextreg Reg.SPR_LAY_SYS, Reg.SPR_LAY_SYS.sprOn

        ld      a, 0
        call    CursorSprite.LoadPattern

        ld      hl, cursor
        ld      c, $08
        call    Cursor.Init
.loop
        ld      b, $0c
.updateLoop
        push    bc

        ld      hl, cursor
        call    Cursor.Update

        ld      hl, cursor
        ld      de, sprite
        call    CursorSprite.Sync

        nextreg Reg.SPR_IDX, 0
        ld      hl, sprite
        call    Sprite.Load

        pop     bc
        djnz    .updateLoop

        ld      hl, cursor
        ld      bc, $123
        ld      e, $45
        call    Cursor.Move

        jr      .loop

cursor  Cursor
sprite  Sprite

        savenex open "built/cursor-debug.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/cursor-debug.map"
