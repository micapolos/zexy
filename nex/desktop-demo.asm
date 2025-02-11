        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include color.asm
        include palette.asm
        include blit.asm
        include terminal.asm
        include ui/sys/font.asm
        include ui/sys/menu.asm

Main
        call    L2_320.Init
        call    Terminal.Init
        call    InitPalette

        nextreg Reg.GLOB_TRANS, $e3
        nextreg Reg.TM_OFS_Y, 256-12

        ; background
        L2_320_FillRect 0, 0, 320, 0, $e3

        call    UISysMenu.Draw

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
        ld      b, palette.count
        jp      Palette.Load9Bit

        macro   color name, r, g, b
@name   equ     ($ - palette) >> 1
        RGB_333 r, g, b
        endm

palette
        color   .black,         0, 0, 0
        color   .foreground,    5, 4, 5
        color   .shadowWhite,   4, 3, 4
        color   .darkWhite,     2, 1, 2
        color   .dark,          1, 0, 1
        color   .desktopBg,     0, 0, 1
        color   .red,           7, 0, 0
        color   .yellow,        7, 7, 0
        color   .green,         0, 7, 0
        color   .cyan,          0, 7, 7
        color   .white,         6, 5, 6
.count          equ     ($ - palette) >> 1

        savenex open "built/desktop-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/desktop-demo.map"
