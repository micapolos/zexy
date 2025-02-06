        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include color.asm
        include palette.asm
        include glyph.asm

        macro   fillrect left, top, width, height, color
        ld      de, left
        ld      bc, width
        ld      hl, (top << 8) | height
        ld      a, color
        call    L2_320.FillRect
        endm

        macro   point left, top, color
        ld      de, left
        ld      l, top
        ld      a, color
        call    L2_320.PutPixel
        endm

        macro   zexy_stripe left, top, color
        fillrect left + 2, top    , 2, 2, color
        fillrect left + 1, top + 2, 2, 2, color
        fillrect left    , top + 4, 2, 2, color
        endm

        macro   zexy_logo left, top
        zexy_stripe left+0, top, 5
        zexy_stripe left+2, top, 6
        zexy_stripe left+4, top, 7
        zexy_stripe left+6, top, 8
        endm

Main
        call    L2_320.Init
        call    InitPalette

        ; background
        fillrect 0, 0, 320, 0, 4

        ; menu background
        fillrect 0, 0, 320, 9, 1
        fillrect 0, 9, 320, 1, 2
        fillrect 0, 10, 320, 1, 0

        ; rounded corner
        point    0, 0, 0
        point    319, 0, 0

        point    1, 0, 3
        point    318, 0, 3
        point    0, 1, 3
        point    319, 1, 3

        point    2, 0, 2
        point    317, 0, 2
        point    1, 1, 2
        point    318, 1, 2
        point    0, 2, 2
        point    319, 2, 2

        zexy_logo 6, 2
.loop
        jr      .loop

InitPalette
        nextreg Reg.PAL_CTRL, Reg.PAL_CTRL.rwL2Pal1
        nextreg Reg.PAL_IDX, 0
        ld      hl, palette
        ld      b, 0
        jp      Palette.Load9Bit

palette
.black  RGB_333 0, 0, 0  ; black
        RGB_333 5, 4, 5  ; white
        RGB_333 4, 3, 4  ; shadow white
        RGB_333 2, 1, 2  ; dark white
        RGB_333 1, 0, 1  ; desktop background
.red    RGB_333 7, 0, 0
.yellow RGB_333 7, 7, 0
.green  RGB_333 0, 7, 0
.cyan   RGB_333 0, 7, 7

text
        db      %00111110
        db      %01001000
        db      %01001000
        db      %00111110
        db      0
        db      %01111110
        db      %01010010
        db      %01010010
        db      %00101100
        db      0
        db      %00111100
        db      %01000010
        db      %01000010
        db      %01000010
        db      0
        db      %01111110
        db      %01000010
        db      %01000010
        db      %00111100
.width  equ     $ - text

        savenex open "built/desktop-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/desktop-demo.map"
