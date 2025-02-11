        ifndef  UISysMenu_asm
        define  UISysMenu_asm

        module  UISysMenu

        macro   ZexyStripe left, top, color
        L2_320_FillRect left + 2, top    , 2, 2, color
        L2_320_FillRect left + 1, top + 2, 2, 2, color
        L2_320_FillRect left    , top + 4, 2, 2, color
        endm

        macro   ZexyLogo left, top
        ZexyStripe left+0, top, palette.red
        ZexyStripe left+2, top, palette.yellow
        ZexyStripe left+4, top, palette.green
        ZexyStripe left+6, top, palette.cyan
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
        l2_320_draw_nine_patch("menuBarSelectedNinePatch", 134, 0, 22, 10, 0)
        l2_320_draw_nine_patch("menuFrameNinePatch", 133, 10, 60, 80, 0)
        endlua

        ZexyLogo 6, 2

        L2_320_SetTextColor palette.dark

        L2_320_SetFont UISysFont.bold.index
        L2_320_DrawString 22, 1, string.terminal

        L2_320_SetFont UISysFont.normal.index
        L2_320_DrawString 73, 1, string.file
        L2_320_DrawString 93, 1, string.edit
        L2_320_DrawString 113, 1, string.view
        L2_320_SetTextColor palette.white
        L2_320_DrawString 137, 1, string.help
        L2_320_SetTextColor palette.dark

        L2_320_DrawString 294, 1, string.time

        ret

string
.terminal       dz      "Terminal"
.file           dz      "File"
.edit           dz      "Edit"
.view           dz      "View"
.help           dz      "Help"
.time           dz      "02:53"

        endmodule

        endif
