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

        module  Terminal

width           equ     80
height          equ     32
writer          Writer { printer, Printer.Put }

; ==========================================================
Init
        nextreg $6b, %11001011  ; enable tilemap, 80x32, 512 tiles, textmode, tilemap over ULA
        nextreg $6c, %00000000  ; Default tilemap attribute
        nextreg $6e, (tileMap - $4000) >> 8
        nextreg $6f, (tileDefs - $4000) >> 8
        nextreg $68, %10010000  ; Disable ULA output, cancel ext keys simulation

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
        ret

tilebuffer
printer         Printer { { tileMap, { height, width }, 0 }, { 0, 0 }, %11100010 }

@tilemapPalette
        ds      256 * 2

@textPalette
        ; normal palette
        RGB_333         0, 0, 0
        RGB_333         0, 0, 3
        RGB_333         0, 3, 0
        RGB_333         0, 3, 3
        RGB_333         3, 0, 0
        RGB_333         3, 0, 3
        RGB_333         3, 3, 0
        RGB_333         3, 3, 3

        ; bright palette
        RGB_333         0, 0, 0
        RGB_333         0, 0, 7
        RGB_333         0, 7, 0
        RGB_333         0, 7, 7
        RGB_333         7, 0, 0
        RGB_333         7, 0, 7
        RGB_333         7, 7, 0
        RGB_333         7, 7, 7

@tileSize        equ     2

@tileMap         equ     $4000
.size           equ     width * height * tileSize
@tileDefs        equ     $4000 + tileMap.size

@font    include topaz-8.asm
.size   equ     $ - font

        endmodule

        endif
