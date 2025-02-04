        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include cursor.asm
        include raster.asm
        include sprite.asm
        include cursor-sprite.asm
        include sprite.asm
        include math.asm
        include key-table.asm
        include key-writer.asm

Main
        call    Terminal.Init

        ld      hl, keyWriter
        ld      de, $0818       ; repeatDelay / initialDelay
        call    KeyWriter.Init

        nextreg Reg.SPR_LAY_SYS, Reg.SPR_LAY_SYS.sprOn | Reg.SPR_LAY_SYS.sprOverBord
        nextreg Reg.SPR_TRANS_IDX, 0

        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), %11100000

        ld      hl, cursorPattern
        ld      de, cursorPattern.size
        ld      a, 0
        call    Sprite.LoadPatterns

        ld      hl, cursor
        ld      c, $10
        call    Cursor.Init

        ld      hl, cursor
        ld      bc, 0
        ld      e, 0
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

        ld      iy, HandleKeyEvent
        call    KeyTable.Scan

.noMove
        call    Raster.FrameWait

        jr      .loop

; Input
;   de - KeyEvent
HandleKeyEvent
        push    ix
        ld      ix, writer
        ld      hl, keyWriter
        call    KeyWriter.HandleKeyEvent
        pop     ix
        ret

; =========================================================
; Input
;   ix - Printer ptr
;   a - char
WriteChar
        call    Printer.Put
        jp      CursorMoveToPrinterCoord

; =========================================================
; Input
;   ix - Printer ptr
CursorMoveToPrinterCoord
        ld      hl, cursor
        ld      b, 0
        ld      c, (ix + Printer.cursor.col)
        sla     bc
        sla     bc
        ld      a, (ix + Printer.cursor.row)
        rlca
        rlca
        rlca
        ld      e, a
        jp      Cursor.Move

writer  Writer  { Terminal.printer, WriteChar }
cursor  Cursor
sprite  Sprite  { 0, 0, %11110000, %01000000, %10000000 }
curX    dw      60
keyWriter       KeyWriter

cursorPattern
        include data/cursor-underscore.asm
.size   equ     $ - cursorPattern

        savenex open "built/cursor-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/cursor-demo.map"
