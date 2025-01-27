        device ZXSPECTRUMNEXT

CHAR_COUNT  equ   96

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

screenPrinter   Printer { { tileMap, 80, 32 }  }
helloText       dz      "Hello, my friend.\nHow are you doing?\nI hope you're fine."

screenTilebuffer        Tilebuffer { tileMap, { 32, 80 }, 0 }
windowTilebuffer        Tilebuffer { tileMap + $40*2 + $50*2*2, { 2, 8 }, 72 }
subTilebuffer           Tilebuffer

cnt8            db      0
scrollY         db      0
scrollDelta     db      0

zexy:
        nextreg NextReg.CPU_SPEED, 3   ; 28MHz
        nextreg NextReg.MMU_0, 35
        nextreg NextReg.MMU_6, 34

        nextreg $6b, %11001011  ; enable tilemap, 80x32, 512 tiles, textmode, tilemap over ULA
        nextreg $6c, %00000000  ; Default tilemap attribute
        nextreg $6e, (tileMap - $4000) >> 8
        nextreg $6f, (tileDefs - $4000) >> 8
        nextreg $68, %10000000  ; Disable ULA output

        call    InitTilemapPalette

        ld      ix, screenTilebuffer
        ld      de, $203f       ; dark blue underscore
        call    Tilebuffer.Fill

        ld      ix, windowTilebuffer
        ld      de, $4010       ; col / row
        call    Tilebuffer.Fill

        ld      ix, screenTilebuffer
        ld      de, $4105       ; col / row
        ld      bc, $0602       ; width / height
        ld      hl, $7011       ; attr / char
        call    Tilebuffer.FillRect

        ld      ix, screenTilebuffer
        ld      iy, subTilebuffer
        ld      de, $4208       ; col / row
        ld      bc, $0402       ; width / height
        call    Tilebuffer.LoadSubFrame

        ld      ix, subTilebuffer
        ld      de, $3012       ; attr / value
        call    Tilebuffer.Fill

        ld      ix, screenTilebuffer
        ld      hl, $8013       ; clear attr / value
        call    Tilebuffer.ScrollUp

        ld      ix, screenPrinter
        ld      (ix + Printer.cursor.row), 1
        ld      (ix + Printer.cursor.col), 2
        ld      (ix + Printer.attr), %01000010  ; bright green

        call    PutOsVersion
        call    Printer.NewLine
        call    Printer.NewLine

        ;call    CmdPwd.Exec

        ld      ix, screenPrinter
        ld      hl, helloText
        ld      iy, Printer.Put
        call    String.ForEach

        ld      ix, screenTilebuffer
        ld      hl, $0003
        ld      de, $0807
        ld      bc, $0803
        call    Tilebuffer.CopyRect

        ld      ix, screenPrinter
        ld      hl, $001e
        call    Printer.MoveTo

        ld      ix, screenTilebuffer
        ld      de, $4f02
        call    Tilebuffer.GetAddrAt
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
        rst     $10

        call    Printer.PushCursor
        call    Printer.PushAttr
        ld      (ix + Printer.attr), %00011010
        ld      hl, $4400
        call    Printer.MoveTo
        call    PutDate
        call    Printer.PopAttr
        call    Printer.PopCursor

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

; Input
;   A - char
PutChar
        push    af, bc, de, hl, ix
        ld      ix, screenPrinter
        call    Printer.Put
        pop     ix, hl, de, bc, af
        ret

PutOsVersion
        rst     $08
        db      $88

        ld      a, b
        rst     $10

        ld      a, c
        rst     $10

        ld      a, d
        call    Put.DigitsHiLo

        ld      a, e
        call    Put.DigitsHiLo

        ld      a, l
        rst     $10

        ld      a, h
        rst     $10

        ret

PutDate
        rst     $08
        db      $8e

        ld      a, b
        call    Put.DigitsHiLo

        ld      a, c
        call    Put.DigitsHiLo

        ld      a, d
        call    Put.DigitsHiLo

        ld      a, e
        call    Put.DigitsHiLo

        ld      a, h
        call    Put.DigitsHiLo

        ld      a, l
        call    Put.DigitsHiLo

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

        mmu     0, 35

        org     $00
        jp      Dos.Reset

        org     $08
        jp      Dos.Call

        org     $10
        jp      PutChar

        org     $18
        ret

        org     $20
        ret

        org     $28
        ret

        org     $30
        ret

        org     $38
        ret

; =============================================================================

        SAVENEX OPEN "zexy.nex", zexy, $bfe0
        SAVENEX AUTO
        SAVENEX CLOSE
