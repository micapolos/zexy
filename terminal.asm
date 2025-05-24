        ifndef  Terminal_asm
        define  Terminal_asm

        include int-table.asm
        include reg.asm
        include tilebuffer.asm
        include printer.asm
        include writer.asm
        include palette.asm
        include color.asm
        include debug.asm
        include mem.asm
        include zexy.asm

        module  Terminal

width           equ     80
height          equ     32

; ==========================================================
Init
        nextreg $6b, %11001011  ; enable tilemap, 80x32, 512 tiles, textmode, tilemap over ULA
        nextreg $6c, %00000000  ; Default tilemap attribute
        nextreg $6e, (tileMap - $4000) >> 8
        nextreg $6f, (tileDefs - $4000) >> 8
        nextreg Reg.ULA_CTRL, Reg.ULA_CTRL.ulaOff | Reg.ULA_CTRL.extKeysOff

        ; Clear tilemap
        ld      hl, tileMap
        ld      bc, tileMap.size
        call    Mem.Clear

        ; Copy font into tile defs
        ld      hl, font
        ld      de, tileDefs
        ld      bc, font.size
        ldir

        ld      hl, textPalette
        ld      de, tilemapPalette
        call    Palette.InitText

        nextreg $43, %00110000  ; tilemap 1-st palette for write, auto-increment
        nextreg $40, 0          ; start palette index = 0

        ld      hl, tilemapPalette
        ld      b, 0
        call    Palette.Load9Bit

        ld      hl, WriteChar
        ld      (Writer.Char.proc), hl

        ; Set white color (not bright)
        push    ix
        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), %11100000
        pop     ix

        ret

WriteChar
        push    ix
        ld      ix, Terminal.printer
        call    Printer.Put
        pop     ix
        ret

        macro   TerminalInk ink
        push    ix
        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), ink << 5
        pop     ix
        endm

        macro   _test name
        _write "Testing "
        TerminalInk %110
        _write name
        TerminalInk %111
        _write "... "
        endm

        macro   _ok
        TerminalInk %010
        _writeln "OK"
        TerminalInk %111
        endm

        macro   _error
        TerminalInk %100
        _writeln "ERROR"
.loop   jp      .loop
        endm

        macro   _okif cond
        _if cond
          _ok
        _else
          _error
        _end
        endm

tilebuffer
printer         Printer { { tileMap, { height, width }, 0 }, { 0, 0 }, %11100010 }

@tilemapPalette
        ds      256 * 2

@textPalette
        ; normal palette
        RGB_333         0, 0, 1
        RGB_333         0, 0, 6
        RGB_333         0, 5, 1
        RGB_333         0, 5, 6
        RGB_333         5, 0, 1
        RGB_333         5, 0, 6
        RGB_333         5, 5, 1
        RGB_333         5, 5, 6

        ; bright palette
        RGB_333         0, 0, 1
        RGB_333         0, 0, 7
        RGB_333         0, 7, 1
        RGB_333         0, 7, 7
        RGB_333         7, 0, 1
        RGB_333         7, 0, 7
        RGB_333         7, 7, 1
        RGB_333         7, 7, 7

@tileSize        equ     2

@tileMap         equ     $4000
.size            equ     width * height * tileSize
@tileDefs        equ     $4000 + tileMap.size

@font    include data/topaz-8.asm
.size   equ     $ - font

        endmodule

        endif
