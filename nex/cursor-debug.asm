        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cursor.asm
        include raster.asm
        include sprite.asm
        include cursor-sprite.asm
        include math.asm

Main
        call    Terminal.Init

        nextreg Reg.SPR_LAY_SYS, Reg.SPR_LAY_SYS.sprOn | Reg.SPR_LAY_SYS.sprOverBord

        ld      a, 0
        call    CursorSprite.LoadPattern

        ld      hl, cursor
        ld      c, $10
        call    Cursor.Init

        ld      hl, (curX)
        ld      bc, hl
        ld      hl, cursor
        ld      e, $89
        call    Cursor.Move

.loop
        ld      hl, cursor
        call    Cursor.Update

        ld      hl, cursor
        ld      de, sprite
        call    CursorSprite.Sync

        nextreg Reg.SPR_IDX, 0
        ld      hl, sprite
        call    Sprite.Load

        ld      bc, $7ffe
        in      a, (c)
        and     %00001
        jp      nz, .spaceUp

.spaceDown
        ld      hl, (curX)
        ld      de, 320
        call    Math.IncHLWrapDE
        ld      (curX), hl

        ld      bc, hl
        ld      hl, cursor
        ld      e, $89
        call    Cursor.Move

.spaceUp
        call    Raster.FrameWait

        jr      .loop

cursor  Cursor
sprite  Sprite
curX    dw      60

        savenex open "built/cursor-debug.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/cursor-debug.map"
