        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include color.asm
        include palette.asm
        include blit.asm
        include terminal.asm

        macro   ZexyStripe left, top, color
        L2_320_FillRect left + 2, top    , 2, 2, color
        L2_320_FillRect left + 1, top + 2, 2, 2, color
        L2_320_FillRect left    , top + 4, 2, 2, color
        endm

        macro   ZexyLogo left, top
        ZexyStripe left+0, top, 6
        ZexyStripe left+2, top, 7
        ZexyStripe left+4, top, 8
        ZexyStripe left+6, top, 9
        endm

Main
        call    L2_320.Init
        call    Terminal.Init
        call    InitPalette

        nextreg Reg.GLOB_TRANS, $e3
        nextreg Reg.TM_OFS_Y, 256-12

        ; background
        L2_320_FillRect 0, 0, 320, 0, $e3

        ; Menu bar
        nextreg Reg.MMU_7, 18
        ld      de, $e000
        ld      hl, ninePatch.menuBar
        ld      bc, $3206
        ld      a, %11010000
        exa : exx
        ld      bc, $333a
        ld      a, %11110000
        exa : exx
        call    Blit.Copy9Patch

        ; Menu frame
        nextreg Reg.MMU_7, 22
        ld      de, $e40a
        ld      hl, ninePatch.menuFrame
        ld      bc, $2250
        ld      a, %11010000
        exa : exx
        ld      bc, $2230
        ld      a, %11010000
        exa : exx
        call    Blit.Copy9Patch

        ZexyLogo 6, 2

        L2_320_DrawLabel 22, 1, text, text.width, 4
        L2_320_DrawLabel 294, 1, rightText, rightText.width, 4

        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), %10000010
        ld      a, 'Z'
        call    Printer.Put

        ld      (ix + Printer.attr), %11000010
        ld      a, 'E'
        call    Printer.Put

        ld      (ix + Printer.attr), %01000010
        ld      a, 'X'
        call    Printer.Put

        ld      (ix + Printer.attr), %01100010
        ld      a, 'Y'
        call    Printer.Put

        ld      (ix + Printer.attr), %11100000

        ld      ix, Terminal.writer
        WritelnString " v0.1"
        Writeln
        WritelnString "> ls"
        Writeln
        WritelnString "  <DIR>            ."
        WritelnString "  <DIR>            .."
        WritelnString "  <DIR>            bin"
        WritelnString "  <DIR>            usr"
        WritelnString "         0000ff21h system.bin"
        WritelnString "         00000135h readme.txt"
        Writeln
        WritelnString "> "
.loop
        jr      .loop

InitPalette
        nextreg Reg.PAL_CTRL, Reg.PAL_CTRL.rwL2Pal1
        nextreg Reg.PAL_IDX, 0
        ld      hl, palette
        ld      b, 10
        jp      Palette.Load9Bit

palette
.black  RGB_333 0, 0, 0  ; black
        RGB_333 5, 4, 5  ; white
        RGB_333 4, 3, 4  ; shadow white
        RGB_333 2, 1, 2  ; dark white
        RGB_333 1, 0, 1  ; dark
        RGB_333 0, 0, 1  ; desktop background
.red    RGB_333 7, 0, 0
.yellow RGB_333 7, 7, 0
.green  RGB_333 0, 7, 0
.cyan   RGB_333 0, 7, 7

text
.terminal
        db      %01000000
        db      %01000000
        db      %01111110
        db      %01111110
        db      %01000000
        db      %01000000
        db      0
        db      %00011100
        db      %00111110
        db      %00101010
        db      %00111010
        db      %00011000
        db      0
        db      %00111110
        db      %00111110
        db      %00010000
        db      %00100000
        db      0
        db      %00111110
        db      %00111110
        db      %00100000
        db      %00111110
        db      %00111110
        db      %00100000
        db      %00111110
        db      %00011110
        db      0
        db      %01011110
        db      %01011110
        db      0
        db      %00111110
        db      %00111110
        db      %00100000
        db      %00111110
        db      %00011110
        db      0
        db      %00000100
        db      %00101110
        db      %00101010
        db      %00111110
        db      %00011110
        db      0
        db      %01111100
        db      %01111110
        db      %00000010
        db      0
        db      0
        db      0
        db      0
        db      0
        db      0
.file
        db      %01111110
        db      %01010000
        db      %01010000
        db      %01000000
        db      0
        db      %01011110
        db      0
        db      %01111100
        db      %00000010
        db      0
        db      %00011100
        db      %00101010
        db      %00101010
        db      %00011000
        db      0
        db      0
        db      0
        db      0
        db      0
        db      0
.edit
        db      %01111110
        db      %01010010
        db      %01010010
        db      %01000010
        db      0
        db      %00001100
        db      %00010010
        db      %00010010
        db      %01111110
        db      0
        db      %01011110
        db      0
        db      %01111100
        db      %00100010
        db      0
        db      0
        db      0
        db      0
        db      0
        db      0
.view
        db      %01111000
        db      %00000100
        db      %00000010
        db      %00000100
        db      %01111000
        db      0
        db      %01011110
        db      0
        db      %00011100
        db      %00101010
        db      %00101010
        db      %00011000
        db      0
        db      %00111100
        db      %00000010
        db      %00001100
        db      %00000010
        db      %00111100
        db      0
        db      0
        db      0
        db      0
        db      0
        db      0
.help
        db      %01111110
        db      %00010000
        db      %00010000
        db      %01111110
        db      0
        db      %00011100
        db      %00101010
        db      %00101010
        db      %00011000
        db      0
        db      %01111100
        db      %00000010
        db      0
        db      %00111111
        db      %00100100
        db      %00100100
        db      %00011000
.width  equ     $ - text

rightText
        db      %00111100
        db      %01000010
        db      %01000010
        db      %00111100
        db      0
        db      %01000110
        db      %01001010
        db      %01001010
        db      %00110010
        db      0
        db      %00100100
        db      0
        db      %01110100
        db      %01010010
        db      %01010010
        db      %01001100
        db      0
        db      %00000000
        db      %00100000
        db      %01111110
        db      %00000000
.width  equ     $ - rightText

unusedText
.finder
        db      %01111110
        db      %01111110
        db      %01010000
        db      %01010000
        db      %01000000
        db      0
        db      %01011110
        db      %01011110
        db      0
        db      %00111110
        db      %00111110
        db      %00100000
        db      %00111110
        db      %00011110
        db      0
        db      %00001100
        db      %00011110
        db      %00010010
        db      %01111110
        db      %01111110
        db      0
        db      %00011100
        db      %00111110
        db      %00101010
        db      %00111010
        db      %00011000
        db      0
        db      %00111110
        db      %00111110
        db      %00010000
        db      %00100000
        db      0
        db      0
        db      0
        db      0
        db      0
        db      0


ninePatch
.menuBar
        dh      "000302010200"
        dh      "030101010200"
        dh      "020101010200"
        dh      "010101010200"
        dh      "020101010200"
        dh      "030101010200"
        dh      "000302010200"
.menuFrame
        dh      "0000000000"
        dh      "0002020200"
        dh      "0002010200"
        dh      "0002020200"
        dh      "0000000000"

        savenex open "built/desktop-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/desktop-demo.map"
