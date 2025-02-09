        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include color.asm
        include palette.asm
        include blit.asm
        include terminal.asm

        lua allpass
        require("l2-320")
        require("sys-font")
        require("sys-bold-font")
        require("font-gen")
        endlua

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

        ; Menu
        lua allpass
        l2_320_draw_nine_patch("menuBarNinePatch", 0, 0, 320, 11, 0)
        l2_320_draw_nine_patch("menuFrameNinePatch", 133, 10, 60, 80, 0)
        endlua

        ZexyLogo 6, 2

        L2_320_SetTextColor %00000100

        L2_320_SetFont sysBoldFont.index
        L2_320_DrawString 22, 1, string.terminal

        L2_320_SetFont sysFont.index
        L2_320_DrawString 73, 1, string.file
        L2_320_DrawString 93, 1, string.edit
        L2_320_DrawString 113, 1, string.view
        L2_320_DrawString 137, 1, string.help

        L2_320_DrawString 294, 1, string.time

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

string
.terminal       dz      "Terminal"
.file           dz      "File"
.edit           dz      "Edit"
.view           dz      "View"
.help           dz      "Help"
.time           dz      "02:53"

        lua allpass

        l2_320_nine_patch(
                "menuBarNinePatch",
                3, 3,
                "00030201020300",
                "03010101010103",
                "02010101010102",
                "01010101010101",
                "02020202020202",
                "00000000000000")
        l2_320_nine_patch(
                "menuFrameNinePatch",
                2, 2,
                "0000000000",
                "0002020200",
                "0002010200",
                "0002020200",
                "00000000000")

        font_gen("sysFont", sys_font)
        font_gen("sysBoldFont", sys_bold_font)

        endlua

        savenex open "built/desktop-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/desktop-demo.map"
