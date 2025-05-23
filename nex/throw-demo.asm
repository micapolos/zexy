        device  zxspectrumnext

        org     $8000

        include terminal.asm
        include throw.asm

Main
        throw_handler Panic
        call    Terminal.Init

        WritelnString "Start"
        try aloc
          WritelnString "Throw"
          throw
        finally aloc
          WritelnString "Finally"
        endtry aloc
        WritelnString "End"

.end    jp      .end

; =========================================================
Panic
        ld      ix, Terminal.printer
        ld      (ix + Printer.attr), %10000000
        WritelnString "Panic attack!!! Guru meditation!!!"
.loop   jp      .loop

        savenex open "built/throw-demo.nex", Main, $bfe0
        savenex auto
        savenex close
        cspectmap    "built/throw-demo.map"
