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
        include cmd/cat.asm

screenTilebuffer
screenPrinter   Printer { { tileMap, { 32, 80 }, 0 } }
leftPrinter     Printer { { tileMap, { 32, 29 }, 51 } }
rightPrinter    Printer { { tileMap + 30 * 2, { 32, 50 }, 30 } }

helloText       dz      "Hello, my friend.\nHow are you doing?\nI hope you're fine."

windowTilebuffer        Tilebuffer { tileMap + $40*2 + $50*2*2, { 2, 8 }, 72 }
subTilebuffer           Tilebuffer

cnt8            db      0
scrollY         db      0
scrollDelta     db      0

zexy:
        di

        nextreg Reg.CPU_SPEED, 3   ; 28MHz
        nextreg Reg.MMU_0, 35
        nextreg Reg.MMU_6, 34

        im      1
        ei

        nextreg $6b, %11001011  ; enable tilemap, 80x32, 512 tiles, textmode, tilemap over ULA
        nextreg $6c, %00000000  ; Default tilemap attribute
        nextreg $6e, (tileMap - $4000) >> 8
        nextreg $6f, (tileDefs - $4000) >> 8
        nextreg $68, %10000000  ; Disable ULA output

        call    InitTilemapPalette

        ld      ix, screenTilebuffer
        ld      de, $205f       ; dark blue underscore
        call    Tilebuffer.Fill

        ld      ix, screenTilebuffer
        ld      de, $2810       ; col / row (middle)
        ld      bc, $e24f       ; attr / char (white O)
        call    Tilebuffer.Set

        ld      ix, windowTilebuffer
        ld      de, $4030       ; attr / char 0
        call    Tilebuffer.Fill

        ld      ix, screenTilebuffer
        ld      de, $4105       ; col / row
        ld      bc, $0602       ; width / height
        ld      hl, $7031       ; attr / char 1
        call    Tilebuffer.FillRect

        ld      ix, screenTilebuffer
        ld      iy, subTilebuffer
        ld      de, $4208       ; col / row
        ld      bc, $0402       ; width / height
        call    Tilebuffer.LoadSubFrame

        ld      ix, subTilebuffer
        ld      de, $3032       ; attr / value
        call    Tilebuffer.Fill

        ld      ix, screenTilebuffer
        ld      hl, $0001
        ld      de, $0000
        ld      bc, $501f
        call    Tilebuffer.CopyRectInc

        ld      ix, screenPrinter
        ld      (ix + Printer.cursor.row), 1
        ld      (ix + Printer.cursor.col), 2
        ld      (ix + Printer.attr), %01000010  ; bright green

        call    PutOsVersion
        call    Printer.NewLine
        call    Printer.NewLine

        ld      ix, screenPrinter
        ld      hl, helloText
        ld      iy, Printer.Put
        call    String.ForEach

        ld      ix, screenTilebuffer
        ld      hl, $0003
        ld      de, $0107
        ld      bc, $0803
        call    Tilebuffer.CopyRect

        ld      ix, rightPrinter
        ld      hl, $0000
        call    Printer.MoveTo
        call    CmdLs.Exec
        call    StatFile

        ld      hl, cattingString
        call    Printer.Print
        ld      hl, catFilename
        call    Printer.Println
        ld      hl, catFilename
        call    CmdCat.Exec

        ld      ix, leftPrinter
        ld      hl, $001e
        call    Printer.MoveTo

        ld      ix, screenTilebuffer
        ld      de, $4f02
        call    Tilebuffer.GetAddr
        ld      (hl), 'A'
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
        ld      ix, leftPrinter
        ld      a, (cnt8)
        add     $20
        call    Printer.Put

        ld      ix, rightPrinter
        call    Printer.PushCursor
        call    Printer.PushAttr
        ld      (ix + Printer.attr), %00011010
        ld      hl, $1c00
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
        call    Printer.Put

        ld      a, c
        call    Printer.Put

        ld      a, d
        call    Put.DigitsHiLo

        ld      a, e
        call    Put.DigitsHiLo

        ld      a, l
        call    Printer.Put

        ld      a, h
        call    Printer.Put

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

StatFile
        push    ix
        ld      ix, leftPrinter
        ld      hl, $000a
        call    Printer.MoveTo

        ld      hl, .openingString
        call    Printer.Print

        ld      ix, leftPrinter
        ld      hl, .filename
        call    Printer.Println

        xor     a
        rst     $08
        db      $89  ; f_getsetdrv
        jp      c, .getDriveError
        ld      (.drive), a

        ld      ix, leftPrinter
        ld      hl, .defaultDriveString
        call    Printer.Print

        ld      a, (.drive)
        and     $f8
        rrca
        rrca
        rrca
        add     'A'
        call    Printer.Put
        call    Printer.NewLine

        ld      a, (.drive)
        ld      ix, .filename
        ld      b, $01
        rst     $08
        db      $9a  ; f_open
        jp      c, .openError
        ld      (.fileHandle), a

        ld      ix, .stat
        rst     $08
        db      $a1  ; f_fstat
        jp      c, .statError

        ld      ix, leftPrinter
        ld      hl, .sizeString
        call    Printer.Print

        ld      ix, leftPrinter
        ld      a, (ix + 7)
        call    Printer.Put
        ld      a, (ix + 8)
        call    Printer.Put
        ld      a, (ix + 9)
        call    Printer.Put
        ld      a, (ix + 10)
        call    Printer.Put
        call    Printer.NewLine

        ld      a, (.fileHandle)
        rst     $08
        db      $9b  ; f_close
        jp      c, .closeError

        ld      ix, leftPrinter
        ld      hl, .okString
        call    Printer.Println
        jp      .end

.getDriveError
        ld      ix, screenPrinter
        ld      hl, .getDriveErrorString
        call    Printer.Println
        jp      .end

.openError
        ld      ix, screenPrinter
        ld      hl, .openErrorString
        call    Printer.Println
        jp      .end

.statError
        ld      ix, screenPrinter
        ld      hl, .statErrorString
        call    Printer.Println
        jp      .end

.closeError
        ld      ix, screenPrinter
        ld      hl, .closeErrorString
        call    Printer.Println
        jp      .end

.end
        pop     ix
        ret

.filename               dz      "zexy.asm"
.fileHandle             db      0
.drive                  db      0
.openingString          dz      "Opening file: "
.getDriveErrorString    dz      "Could not get default drive."
.defaultDriveString     dz      "Default drive is "
.openErrorString        dz      "Could not open."
.statErrorString        dz      "Could not get file info."
.closeErrorString       dz      "Could not close file."
.sizeString             dz      "File size: "
.okString               dz      "OK"
.stat                   ds      11

cattingString           dz      "Printing content of: "
catFilename             dz      "zexy.asm"

; =============================================================================

        org $4000

tileMap:
        ds      80 * 32 * 2

tileDefs:
        include topaz-8.asm
        ;incbin  topan.fnt

        MMU     6, 34
        org     $c000

tilemapPalette:
        ds      256 * 2

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
        di
        push    af, bc, de, hl, ix
        ld      ix, leftPrinter
        ld      a, '.'
        call    Printer.Put
        pop     ix, hl, de, bc, af
        ei
        reti

; =============================================================================

        SAVENEX OPEN "built/zexy.nex", zexy, $bfe0
        SAVENEX AUTO
        SAVENEX CLOSE
