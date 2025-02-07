        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include ui/frame.asm
        include ui/frame-writer.asm
        include ui/alignment.asm

Main
        call    Terminal.Init

        ld      ix, Terminal.writer

        WriteStringDZ "start: 1000h\n"
        WriteStringDZ "length: 2000h\n"
        WriteStringDZ "value: 0300h\n"
        WriteStringDZ "left aligned: "
        ld      hl, $1000
        ld      de, $2000
        ld      bc, $0300
        xor     a
        call    UIAlignment.AlignValue
        call    Writer.Hex16h
        call    Writer.NewLine

        WriteStringDZ "right aligned: "
        ld      hl, $1000
        ld      de, $2000
        ld      bc, $0300
        ld      a, 1
        call    UIAlignment.AlignValue
        call    Writer.Hex16h
        call    Writer.NewLine
        call    Writer.NewLine

        ld      hl, frames
        call    UIFrameWriter.Writeln

        ld      hl, frames
        ld      de, $0010
        ld      bc, $0008
        ld      a, UIAlignment.left | UIAlignment.top
        call    UIAlignment.AlignXY

        push    bc
        ld      hl, de
        call    Writer.Hex16h
        WriteChar ','
        pop     hl
        call    Writer.Hex16h
        call    Writer.NewLine

.loop   jr      .loop

frames
        UIFrame { $0100, $0200, $0300, $0400 }

        savenex open "built/ui/alignment-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/alignment-demo.map"
