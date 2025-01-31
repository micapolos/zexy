        device  zxspectrumnext

        org     $8000

        include nextreg.asm
        include int-table.asm
        include scheduler.asm

Main
        nextreg NextReg.ULA_CONTROL, %10000000  ; disable ula
        nextreg NextReg.CPU_SPEED, 0   ; 28MHz

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

        savenex open "sandbox/processes.nex", Main, $bfe0
        savenex auto
        savenex close
