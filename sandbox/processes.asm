        device  zxspectrumnext

        org     $8000

        include nextreg.asm
        include process.asm
        include scheduler.asm

Main
        di

        nextreg $c0, (IntTable & %11100000) | %00000001
        nextreg $c4, %10000001   ; exp bus & ULA
        nextreg $c5, %00000001   ; ctc channel 0
        nextreg $c6, %00000000   ;

        ld      a, IntTable >> 8
        ld      i, a

        im      2

        ; reset CTC
        ld      bc, $183b
        ld      a, %00000011
        out     (c), a
        out     (c), a

        ld      a, %10100101
        out     (c), a                   ; int en, timer, /256, time const follows

        ld      a, 190
        out     (c), a

        ld      h, ProcessTable >> 8
        call    Scheduler.Init
        ei

        ld      a, 0
EntryPoint
.loop
        out     ($fe), a
        jp      .loop

        org     $9000
IntTable
.line           dw      IntEmpty
.uart0rx        dw      IntEmpty
.uart1rx        dw      IntEmpty
.ctc0           dw      Scheduler.IntYield
.ctc1           dw      IntEmpty
.ctc2           dw      IntEmpty
.ctc3           dw      IntEmpty
.ctc4           dw      IntEmpty
.ctc5           dw      IntEmpty
.ctc6           dw      IntEmpty
.ctc7           dw      IntEmpty
.ula            dw      IntEmpty
.uart0tx        dw      IntEmpty
.uart1tx        dw      IntEmpty
                dw      IntEmpty
                dw      IntEmpty

        org     $9100
ProcessTable
        ds      $100

IntEmpty
        ei
        reti

        savenex open "sandbox/processes.nex", Main, $a100
        savenex auto
        savenex close

