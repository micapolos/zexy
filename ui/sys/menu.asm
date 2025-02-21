        ifndef  UISysMenu_asm
        define  UISysMenu_asm

        include l2-320.asm
        include color.asm
        include ../../palette.asm
        include blit.asm
        include terminal.asm
        include ui/sys/font.asm
        include ui/sys/menu.asm
        include ui/sys/palette.asm

        module  UISysMenu

        macro   ZexyStripe left, top, color
        L2_320_FillRect left + 2, top    , 2, 2, color
        L2_320_FillRect left + 1, top + 2, 2, 2, color
        L2_320_FillRect left    , top + 4, 2, 2, color
        endm

        macro   ZexyLogo left, top
        ZexyStripe left+0, top, UISysPalette.color.red
        ZexyStripe left+2, top, UISysPalette.color.yellow
        ZexyStripe left+4, top, UISysPalette.color.green
        ZexyStripe left+6, top, UISysPalette.color.cyan
        endm

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
                "menuBarSelectedNinePatch",
                0, 0,
                "03",
                "04")

        l2_320_nine_patch(
                "menuFrameNinePatch",
                2, 2,
                "0000000000",
                "0002020200",
                "0002010200",
                "0002020200",
                "0000000000")

        endlua

; =========================================================
Draw
        ; Menu
        lua allpass
        l2_320_draw_nine_patch("menuBarNinePatch", 0, 0, 320, 11, 0)
        l2_320_draw_nine_patch("menuBarSelectedNinePatch", 89, 0, 22, 10, 0)
        l2_320_draw_nine_patch("menuFrameNinePatch", 88, 10, 71, 59, 0)
        endlua

        ZexyLogo 6, 2

        L2_320_SetTextColor UISysPalette.color.dark

        L2_320_SetFont UISysFont.bold.index
        L2_320_DrawString 22, 1, string.terminal

        L2_320_SetFont UISysFont.normal.index
        L2_320_DrawString 73, 1, string.file
        L2_320_SetTextColor UISysPalette.color.white
        L2_320_DrawString 93, 1, string.edit
        L2_320_SetTextColor UISysPalette.color.dark
        L2_320_DrawString 113, 1, string.view
        L2_320_DrawString 137, 1, string.help

        L2_320_DrawString 294, 1, string.time

        L2_320_DrawString 93, 14, string.undo
        L2_320_DrawString 93, 24, string.redo
        L2_320_DrawHLine  92, 34, 63, UISysPalette.color.shadowWhite
        L2_320_DrawString 93, 37, string.cut
        L2_320_DrawString 93, 47, string.copy
        L2_320_DrawString 93, 57, string.paste

        L2_320_SetTextColor UISysPalette.color.darkWhite2
        L2_320_DrawString 129, 14, string.ext_z
        L2_320_DrawString 129, 24, string.ext_yy
        L2_320_DrawString 129, 37, string.ext_xx
        L2_320_DrawString 129, 47, string.ext_c
        L2_320_DrawString 129, 57, string.ext_v
        ret

string
.terminal       dz      "Terminal"
.file           dz      "File"
.edit           dz      "Edit"
.view           dz      "View"
.help           dz      "Help"
.time           dz      "02:53"
.undo           dz      "Undo"
.redo           dz      "Redo"
.cut            dz      "Cut"
.copy           dz      "Copy"
.paste          dz      "Paste"
.ext_z          dz      1, "Z"
.ext_yy         dz      1, "Y"
.ext_xx         dz      1, "X"
.ext_c          dz      1, "C"
.ext_v          dz      1, "V"

        endmodule

        endif
