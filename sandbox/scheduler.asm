        device  zxspectrumnext

        org     $8000

        include nextreg.asm
        include process.asm

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

        ld      hl, ProcessTable.p0
        ld      (Process.currentProcessPtr), hl

        ; Init registers with consequent values
        ld      hl, $1011
        push    hl
        pop     af
        ex      af, af
        ld      hl, $2021
        push    hl
        pop     af
        ex      af, af

        ld      bc, $3031
        exx
        ld      bc, $4041
        exx

        ld      de, $5051
        exx
        ld      de, $6061
        exx

        ld      hl, $7071
        exx
        ld      hl, $8081
        exx

        ld      ix, $9091
        ld      iy, $a0a1

        ei
.loop   jp      .loop

        macro   ProcessBody name, index
name    ld      a, index
        push    af
        out     ($fe), a
        push    hl
        pop     de
        pop     bc
        jp      name
        endm

        org     $a000   : ProcessBody Proc0, 0
        org     $a100   : ProcessBody Proc1, 1
        org     $a200   : ProcessBody Proc2, 2
        org     $a300   : ProcessBody Proc3, 3
        org     $a400   : ProcessBody Proc4, 4
        org     $a500   : ProcessBody Proc5, 5
        org     $a600   : ProcessBody Proc6, 6
        org     $a700   : ProcessBody Proc7, 7

        org     $9000
IntTable
.line           dw      IntEmpty
.uart0rx        dw      IntEmpty
.uart1rx        dw      IntEmpty
.ctc0           dw      IntCTC
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

ProcessTable
.p0             Process { Proc0, Proc0 + $100 }
.p1             Process { Proc1, Proc1 + $100 }
.p2             Process { Proc2, Proc2 + $100 }
.p3             Process { Proc3, Proc3 + $100 }
.p4             Process { Proc4, Proc4 + $100 }
.p5             Process { Proc5, Proc5 + $100 }
.p6             Process { Proc6, Proc6 + $100 }
.p7             Process { Proc7, Proc7 + $100 }

ProcessPtrTable
.p0             dw      ProcessTable.p0
.p1             dw      ProcessTable.p1
.p2             dw      ProcessTable.p2
.p3             dw      ProcessTable.p3
.p4             dw      ProcessTable.p4
.p5             dw      ProcessTable.p5
.p6             dw      ProcessTable.p6
.p7             dw      ProcessTable.p7

currentProcessIndex     db      0

IntEmpty
        ei
        reti

IntCTC
        break
        call    Process.Save

        ; TODO: Remove, for debugging
        ld      hl, (Process.currentProcessPtr)
        break

        ld      a, (currentProcessIndex)
        inc     a
        and     $07
        ld      (currentProcessIndex), a

        rlca

        ld      hl, (ProcessPtrTable)
        add     hl, a

        ld      e, (hl)
        inc     hl
        ld      d, (hl)

        ld      h, d
        ld      l, e

        ld      (Process.currentProcessPtr), hl
        call    Process.Load

        savenex open "sandbox/scheduler.nex", Main, $bfe0
        savenex auto
        savenex close

