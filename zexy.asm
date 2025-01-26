        DEVICE ZXSPECTRUMNEXT

CHAR_COUNT  EQU   96

        ORG $c000

        INCLUDE blit.asm
        INCLUDE surface.asm
        INCLUDE palette.asm
        INCLUDE color.asm
        INCLUDE raster.asm
        INCLUDE printer.asm
        INCLUDE string.asm
        INCLUDE tilebuffer.asm

screenSurface   Surface { tileMap, 80, 32 }
backSurface     Surface { backTileMap, 32, 3 }
screenPrinter   Printer { screenSurface }
helloText       dz      "Hello, my friend.\nHow are you doing?\nI hope you're fine."

screenTilebuffer        Tilebuffer { tileMap, { 32, 80 }, 0 }
windowTilebuffer        Tilebuffer { tileMap + $40*2 , { 2, 8 }, 72 }
subTilebuffer           Tilebuffer

cnt8            db      0
scrollY         db      0
scrollDelta     db      0

zexy:
        di

        nextreg NextReg.CPU_SPEED, 3   ; 28MHz
        nextreg NextReg.MMU_4, 34

        nextreg $6b, %11001011  ; enable tilemap, 80x32, 512 tiles, textmode, tilemap over ULA
        nextreg $6c, %00000000  ; Default tilemap attribute
        nextreg $6e, (tileMap - $4000) >> 8
        nextreg $6f, (tileDefs - $4000) >> 8
        nextreg $68, %10000000  ; Disable ULA output

        call    InitTilemapPalette

        ld      ix, screenTilebuffer
        ld      de, $200e       ; color / value
        call    Tilebuffer.Fill

        ld      ix, windowTilebuffer
        ld      de, $4010
        call    Tilebuffer.Fill

        ld      ix, screenTilebuffer
        ld      de, $4103  ;  col / row
        ld      bc, $0602  ;  width / height
        ld      hl, $7011  ;  attr / char
        call    Tilebuffer.FillRect

        ld      ix, screenTilebuffer
        ld      iy, subTilebuffer
        ld      de, $4206
        ld      bc, $0402
        call    Tilebuffer.LoadSubFrame

        ld      ix, subTilebuffer
        ld      de, $3012
        call    Tilebuffer.Fill

        ld      ix, screenSurface
        ld      iy, backSurface
        ld      hl, $0402       ; dst col / row
        ld      de, $0000       ; src col / row
        ld      bc, $2003       ; width / height
        call    Surface.XCopyRect

        ld      ix, screenPrinter
        ld      (ix + Printer.row), 1
        ld      (ix + Printer.col), 2
        ld      (ix + Printer.attr), %00011010  ; bright inverse yellow
        call    Printer.Init

        ld      hl, helloText
        ld      iy, Printer.Put
        call    String.ForEach

        ld      hl, $001e
        call    Printer.MoveTo

        ld      ix, screenTilebuffer
        ld      de, $4f02
        call    Tilebuffer.CoordAddr
        ld      (hl), 'A' - $20
        inc     hl
        ld      (hl), %11100010

.loop:
        ; Increment counter
        ld      a, (cnt8)
        inc     a
        cp      $60
        jp      nz, .nextCnt8
        ld      a, 0
.nextCnt8
        ld      (cnt8), a

        ; Print some char
        ld      ix, screenPrinter
        ld      a, (cnt8)
        add     $20
        call    Printer.Put

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

        ORG $4000

tileMap:
        ds      80 * 32 * 2

tileDefs:
        INCLUDE topaz-8.asm
        ds      96 * 32

        MMU     4, 34
        ORG     $8000

tilemapPalette:
        ds      256 * 2

fontBitmap:
        INCLUDE topaz-8.asm

backTileMap:
        DUP   CHAR_COUNT, i
        DB    (i % CHAR_COUNT) & $ff
        DB    %11100010 | (((i % CHAR_COUNT) & $100) >> 8)
        EDUP

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

        SAVENEX OPEN "zexy.nex", zexy, $FFFE
        SAVENEX AUTO
        SAVENEX CLOSE
