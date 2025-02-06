        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include color.asm
        include palette.asm

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

Main
        call    L2_320.Init
        call    InitPalette

        ; background
        fillrect 0, 0, 320, 0, 4

        ; menu background
        fillrect 0, 0, 320, 10, 1
        fillrect 0, 10, 320, 1, 2
        fillrect 0, 11, 320, 1, 0

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

        savenex open "built/desktop-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/desktop-demo.map"
