        ifndef  UISysFont_asm
        define  UISysFont_asm

        module  UISysFont

        lua allpass
        require("l2-320")
        require("sys-font")
        require("sys-bold-font")
        require("font-gen")
        endlua

        lua allpass

        font_gen("normal", sys_font)
        font_gen("bold", sys_bold_font)

        endlua

        endmodule

        endif
