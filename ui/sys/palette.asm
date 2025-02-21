        ifndef  UISysPalette_asm
        define  UISysPalette_asm

        include ../../reg.asm
        include ../../palette.asm
        include ../../color.asm

        module  UISysPalette

Init
        nextreg Reg.PAL_CTRL, Reg.PAL_CTRL.rwL2Pal1
        nextreg Reg.PAL_IDX, 0
        ld      hl, color
        ld      b, color.count
        jp      Palette.Load9Bit

        macro   cn name, r, g, b
@name   equ     ($ - color) >> 1
        RGB_333 r, g, b
        endm

color
        cn   .black,         0, 0, 0
        cn   .foreground,    5, 4, 5
        cn   .shadowWhite,   4, 3, 4
        cn   .darkWhite,     2, 1, 2
        cn   .dark,          1, 0, 1
        cn   .desktopBg,     0, 0, 1
        cn   .red,           7, 0, 0
        cn   .yellow,        7, 7, 0
        cn   .green,         0, 7, 0
        cn   .cyan,          0, 7, 7
        cn   .white,         6, 5, 6
        cn   .darkWhite2,    3, 2, 3
.count  equ     ($ - color) >> 1

        endmodule

        endif
