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
        call    Process.Load
        break
        ret

        macro   ProcessBody name, index
name    out     ($fe), a
        jp      name
        endm

        org $a000 : ProcessBody Proc0, 0 : org $a0fe : dw $a000
        org $a100 : ProcessBody Proc1, 1 : org $a1fe : dw $a100
        org $a200 : ProcessBody Proc2, 2 : org $a2fe : dw $a200
        org $a300 : ProcessBody Proc3, 3 : org $a3fe : dw $a300
        org $a400 : ProcessBody Proc4, 4 : org $a4fe : dw $a400
        org $a500 : ProcessBody Proc5, 5 : org $a5fe : dw $a500
        org $a600 : ProcessBody Proc6, 6 : org $a6fe : dw $a600
        org $a700 : ProcessBody Proc7, 7 : org $a7fe : dw $a700

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

        org     $9100

ProcessTable
.p0             Process { Proc0 + $fe, $0000, $0100, $0200, $0300, $0400, $0500, $0600, $0700, $0800, $0900 }
.p1             Process { Proc1 + $fe, $0001, $0101, $0201, $0301, $0401, $0501, $0601, $0701, $0801, $0901 }
.p2             Process { Proc2 + $fe, $0002, $0102, $0202, $0302, $0402, $0502, $0602, $0702, $0802, $0902 }
.p3             Process { Proc3 + $fe, $0003, $0103, $0203, $0303, $0403, $0503, $0603, $0703, $0803, $0903 }
.p4             Process { Proc4 + $fe, $0004, $0104, $0204, $0304, $0404, $0504, $0604, $0704, $0804, $0904 }
.p5             Process { Proc5 + $fe, $0005, $0105, $0205, $0305, $0405, $0505, $0605, $0705, $0805, $0905 }
.p6             Process { Proc6 + $fe, $0006, $0106, $0206, $0306, $0406, $0506, $0606, $0706, $0806, $0906 }
.p7             Process { Proc7 + $fe, $0007, $0107, $0207, $0307, $0407, $0507, $0607, $0707, $0807, $0907 }

currentProcessIndex     db      0

IntEmpty
        ei
        reti

IntCTC
        call    Process.Save

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

        break
        ei
        reti

        savenex open "sandbox/scheduler.nex", Main, $a100
        savenex auto
        savenex close

