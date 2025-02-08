        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include color.asm
        include palette.asm
        include glyph.asm
        include blit.asm

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
        zexy_stripe left+0, top, 6
        zexy_stripe left+2, top, 7
        zexy_stripe left+4, top, 8
        zexy_stripe left+6, top, 9
        endm

        macro   draw_label addr, left, top, width, color
        ld      de, left
        ld      hl, L2_320.DrawLabel.top
        ld      (hl), top
        ld      hl, L2_320.DrawLabel.color
        ld      (hl), color
        ld      hl, addr
        ld      bc, width
        call    L2_320.DrawLabel
        endm

Main
        call    L2_320.Init
        call    InitPalette

        ; background
        fillrect 0, 0, 320, 0, 5

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


        zexy_logo 6, 2

        draw_label text, 22, 1, text.width, 4
        draw_label rightText, 294, 1, rightText.width, 4
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
        RGB_333 1, 0, 1  ; dark
        RGB_333 0, 0, 1  ; desktop background
.red    RGB_333 7, 0, 0
.yellow RGB_333 7, 7, 0
.green  RGB_333 0, 7, 0
.cyan   RGB_333 0, 7, 7

text
        ; F
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
        ;db      0
        db      0
        db      0
        db      0
        db      0
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
        ;db      0
        db      0
        db      0
        db      0
        db      0
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
        ;db      0
        db      0
        db      0
        db      0
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
        ;db      0
        db      0
        db      0
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

ninePatch
.menuBar
        dh      "000302010200"
        dh      "030101010200"
        dh      "020101010200"
        dh      "010101010200"
        dh      "020101010200"
        dh      "030101010200"
        dh      "000302010200"

        savenex open "built/desktop-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/desktop-demo.map"
