        device zxspectrumnext

        org $8000

        include blit.asm
        include palette.asm
        include color.asm
        include raster.asm
        include printer.asm
        include string.asm
        include tilebuffer.asm
        include dos.asm
        include put.asm
        include cmd/ls.asm
        include cmd/pwd.asm

screenTilebuffer
screenPrinter           Printer { { tileMap, { 32, 80 }, 0 } }

promptString            dz      "ZEXY v0.1 - unit test suite"

Start
        nextreg Reg.CPU_SPEED, 3   ; 28MHz
        nextreg Reg.MMU_6, 34

        nextreg $6b, %11001011  ; enable tilemap, 80x32, 512 tiles, textmode, tilemap over ULA
        nextreg $6c, %00000000  ; Default tilemap attribute
        nextreg $6e, (tileMap - $4000) >> 8
        nextreg $6f, (tileDefs - $4000) >> 8
        nextreg $68, %10000000  ; Disable ULA output

        call    InitTilemapPalette

        ld      ix, screenTilebuffer
        ld      de, $0000
        call    Tilebuffer.Fill

        ld      ix, screenPrinter
        ld      (ix + Printer.attr), %11100010  ; bright green
        ld      hl, promptString
        call    Printer.Println

.loop:
        call    Raster.FrameWait
        jp      .loop

InitTilemapPalette:
        ld      hl, textPalette
        ld      de, tilemapPalette
        call    Palette.InitText

        nextreg $43, %00110000  ; tilemap 1-st palette for write, auto-increment
        nextreg $40, 0          ; start palette index = 0

        ld      hl, tilemapPalette
        ld      b, 0
        call    Palette.Load9Bit
        ret

; =============================================================================

        org $4000

tileMap:
        ds      80 * 32 * 2

tileDefs:
        include topaz-8.asm
        ds      96 * 32

        MMU     6, 34
        org     $c000

tilemapPalette:
        ds      256 * 2

fontBitmap:
        include topaz-8.asm

textPalette
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

; =============================================================================

        SAVENEX OPEN "test.nex", Start, $bfe0
        SAVENEX AUTO
        SAVENEX CLOSE
