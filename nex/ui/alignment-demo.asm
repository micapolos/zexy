        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include ui/frame.asm
        include ui/frame-writer.asm
        include ui/alignment.asm

Main
        call    Terminal.Init

        ; === AlignValue

        WritelnString "start: 1000h"
        WritelnString "length: 2000h"
        WritelnString "value: 0300h"
        WriteString "left aligned: "
        ld      hl, $1000
        ld      de, $2000
        ld      bc, $0300
        xor     a
        call    UIAlignment.AlignValue
        call    Writer.Hex16h
        call    Writer.NewLine

        WriteString "right aligned: "
        ld      hl, $1000
        ld      de, $2000
        ld      bc, $0300
        ld      a, 1
        call    UIAlignment.AlignValue
        call    Writer.Hex16h
        call    Writer.NewLine
        call    Writer.NewLine

        ; === AlignCoord

        ld      hl, frames
        call    UIFrameWriter.Writeln
        WritelnString   "point: $0010 $0008"
        WriteString   "aligned left-top: "

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

frames   UIFrame { $0100, $0200, $0300, $0400 }

        savenex open "built/ui/alignment-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/alignment-demo.map"
