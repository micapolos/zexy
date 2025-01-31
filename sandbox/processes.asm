        device  zxspectrumnext

        org     $8000

        include nextreg.asm
        include int-table.asm
        include scheduler.asm

Main
        nextreg NextReg.ULA_CONTROL, %10000000  ; disable ula

        call    Scheduler.Init

        ld      bc, Process.entry
        ld      de, Process.stack1
        ld      a, $73
        call    Scheduler.Launch

        ld      bc, Process.entry
        ld      de, Process.stack2
        ld      a, $34
        call    Scheduler.Launch

        ld      bc, Process.entry
        ld      de, Process.stack3
        ld      a, $e7
        call    Scheduler.Launch

        ld      bc, Process.entry
        ld      de, Process.stack4
        ld      a, $27
        call    Scheduler.Launch

        ld      bc, Process.entry
        ld      de, Process.stack5
        ld      a, $d7
        call    Scheduler.Launch

        ld      bc, Process.entry
        ld      de, Process.stack6
        ld      a, $3b
        call    Scheduler.Launch

        ld      bc, Process.entry
        ld      de, Process.stack7
        ld      a, $f1
        call    Scheduler.Launch

        xor     a
.loop
        nextreg NextReg.TRANS_COLOR_FALLBACK, a
        inc     a
        jp      .loop

Process
.entry
.loop
        nextreg NextReg.TRANS_COLOR_FALLBACK, a
        jp      .loop

        ds      $100
.stack1
        ds      $100
.stack2
        ds      $100
.stack3
        ds      $100
.stack4
        ds      $100
.stack5
        ds      $100
.stack6
        ds      $100
.stack7
        ds      $100
.stack8

        savenex open "sandbox/processes.nex", Main, $bfe0
        savenex auto
        savenex close
