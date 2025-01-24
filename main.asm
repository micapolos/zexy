        DEVICE ZXSPECTRUMNEXT

CHAR_COUNT  EQU   96

        ORG $c000

        INCLUDE blit.asm
        INCLUDE surface.asm
        INCLUDE palette.asm
        INCLUDE color.asm

screenSurface:
        Surface { tileMap, 80, 32 }

backSurface:
        Surface { backTileMap, 32, 3 }

main:
        di

        nextreg $07, 3   ; 28MHz clock
        nextreg $54, 34  ; MMU 4, 34

        nextreg $6b, %11001011  ; enable tilemap, 80x32, 512 tiles, textmode, tilemap over ULA
        nextreg $6c, %00000000  ; Default tilemap attribute
        nextreg $6e, (tileMap - $4000) >> 8
        nextreg $6f, (tileDefs - $4000) >> 8
        nextreg $68, %10000000  ; Disable ULA output

        call    InitTilemapPalette

        ld      ix, screenSurface
        ld      iy, backSurface

        ld      hl, $0000       ; col / row
        ld      bc, $5020       ; width / height
        ld      de, $040e       ; value
        call    Surface.FillRect

        ld      hl, $1008       ; col / row
        ld      bc, $2008       ; width / height
        ld      de, $1003       ; tile
        call    Surface.FillRect

        ld      hl, $0402       ; dst col / row
        ld      de, $0000       ; src col / row
        ld      bc, $2003       ; width / height
        call    Surface.CopyRect

.loop:
        jp      .loop

InitTilemapPalette:
        ld      hl, textPalette
        ld      de, tilemapPalette
        call    Palette.LoadText

        nextreg $43, %00110000  ; tilemap 1-st palette for write, auto-increment
        nextreg $40, 0          ; start palette index = 0
        ld      hl, tilemapPalette
        ld      b, 0
.loop:
        ld      a, (hl)
        inc     hl
        nextreg $44, a

        ld      a, (hl)
        inc     hl
        nextreg $44, a

        djnz    .loop

        ret

        ORG $4000

tileMap:
        ds      80 * 32 * 2

tileDefs:
        INCLUDE topaz-8.asm
        ds      96 * 32

        MMU     4, 34
        ORG     $8000

tilemapPalette:
        DB %00000000
        DB %00000000
        DB %00000000
        DB %00000010
        DB %00000000
        DB %00010000
        DB %00000000
        DB %00010010
        DB %00000000
        DB %10000000
        DB %00000000
        DB %10000010
        DB %00000000
        DB %10010000
        DB %00000000
        DB %10010010

fontBitmap:
        INCLUDE topaz-8.asm

backTileMap:
        DUP   CHAR_COUNT, i
        DB    (i % CHAR_COUNT) & $ff
        DB    $1c | (((i % CHAR_COUNT) & $100) >> 8)
        EDUP

textPalette
        RGB_333         0, 0, 0
        RGB_333         0, 0, 4
        RGB_333         0, 4, 0
        RGB_333         0, 4, 4
        RGB_333         4, 0, 0
        RGB_333         4, 0, 4
        RGB_333         4, 4, 0
        RGB_333         4, 4, 4

        SAVENEX OPEN "main.nex", main, $FFFE
        SAVENEX AUTO
        SAVENEX CLOSE
