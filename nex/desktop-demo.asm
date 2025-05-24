        device  zxspectrumnext

        org     $8000

        include l2-320.asm
        include color.asm
        include palette.asm
        include blit.asm
        include terminal.asm
        include ui/sys/font.asm
        include ui/sys/menu.asm
        include ui/sys/palette.asm

Main
        call    L2_320.Init
        call    Terminal.Init
        call    UISysPalette.Init

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

        _writeln " v0.1"
        _newline
        _writeln "> ls"
        _newline
        _writeln "  <DIR>            ."
        _writeln "  <DIR>            .."
        _writeln "  <DIR>            bin"
        _writeln "  <DIR>            usr"
        _writeln "         0000ff21h system.bin"
        _writeln "         00000135h readme.txt"
        _newline
        _writeln "> "
.loop
        jr      .loop

        savenex open "built/desktop-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/desktop-demo.map"
