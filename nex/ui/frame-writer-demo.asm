        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include ui/frame.asm
        include ui/frame-writer.asm

Main
        call    Terminal.Init

        ld      ix, Terminal.writer
        ld      hl, frames
        call    UIFrameWriter.Writeln
        call    UIFrameWriter.Writeln

.loop   jr      .loop

frames
        UIFrame { $0010, $0020, $0030, $0040 }
        UIFrame { $1000, $2000, $3000, $4000 }

        savenex open "built/ui/frame-writer-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap       "built/ui/frame-writer-demo.map"
