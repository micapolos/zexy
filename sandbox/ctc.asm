        device  zxspectrumnext

        org     $8000

        include reg.asm
        include port.asm

Boot
        nextreg $50, $20

Main
        nextreg $c0, (IntTable & %11100000) | %00000001
        nextreg $c4, %10000001   ; exp bus & ULA
        nextreg $c5, %00000001   ; ctc channel 0
        nextreg $c6, %00000000   ;

        ld      a, IntTable >> 8
        ld      i, a

        im      2
        ei

        ; reset ctc
        ld      bc, $183b
        ld      a, %00000011
        out     (c), a
        out     (c), a

        ld      a, %10100101
        out     (c), a                   ; int en, timer, /256, time const follows

        ld      a, 97
        out     (c), a

.loop   ld      a, (color)
        out     (Port.ULA), a
        jp      .loop

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
.ula            dw      IntULA
.uart0tx        dw      IntEmpty
.uart1tx        dw      IntEmpty
                dw      IntEmpty
                dw      IntEmpty

IntEmpty
        ei
        reti

IntULA
        push    af
        ld      a, (changeCounter)
        dec     a
        ld      (changeCounter), a
        jp      nz, .noChange
        ld      a, 50
        ld      (changeCounter), a
        ld      a, (color)
        and     $06
        inc     a
        inc     a
        and     $06
        ld      (color), a
.noChange
        pop     af
        ei
        reti

IntCTC
        push    af
        ld      a, (color)
        xor     $01
        ld      (color), a
        pop     af
        ei
        reti

color          db      0
changeCounter  db      50

        savenex open "built/sandbox/ctc.nex", Main, $bfe0
        savenex auto
        savenex close

