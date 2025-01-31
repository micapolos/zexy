PROCESS_COUNT   equ     7
STACK_SIZE      equ     $100

        device  zxspectrumnext

        org     $8000

        include int-table.asm
        include nextreg.asm
        include scheduler.asm

Main
        nextreg NextReg.ULA_CONTROL, %10000000  ; disable ula
        nextreg NextReg.CPU_SPEED, 0

        call    Scheduler.Init

        ld      de, stackTable
        ld      b, PROCESS_COUNT
        ld      a, 0
.launchLoop
        add     a, $17
        add     de, STACK_SIZE

        push    af
        push    bc
        push    de

        ld      bc, Process.entry
        call    Scheduler.Launch

        pop     de
        pop     bc
        pop     af

        djnz    .launchLoop

        xor     a
.mainLoop
        nextreg NextReg.TRANS_COLOR_FALLBACK, a
        inc     a
        jp      .mainLoop

Process
.entry
.loop
        nextreg NextReg.TRANS_COLOR_FALLBACK, a
        jp      .loop

stackTable
        dup     PROCESS_COUNT
        ds      STACK_SIZE
        edup

        savenex         open "sandbox/processes.nex", Main, $bfe0
        savenex         auto
        savenex         close
        cspectmap       "sandbox/processes.map"
