        device  zxspectrumnext

        org     $8000

        include reg.asm
        include port.asm

Main
        nextreg $c0, (IntTable & %11100000) | %00000001
        nextreg $c4, %10000001   ; exp bus & ULA
        nextreg $c5, %00000001   ; ctc channel 0
        nextreg $c6, %00000000   ;

        ld      a, IntTable >> 8
        ld      i, a

        im      2

        ; reset ctc
        ld      bc, $183b
        ld      a, %00000011
        out     (c), a
        out     (c), a

        ld      a, %10100101
        out     (c), a                   ; int en, timer, /256, time const follows

        ld      a, $0a
        out     (c), a

        ei

.loop   jp      .loop

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

IntEmpty
        ei
        reti

IntCTC
        push    af, bc, de, hl

        ld      a, $07
        out     (Port.ULA), a

        ld      a, (lfo)
        dec     a
        jp      nz, .skip
        ld      a, $8
.skip
        ld      (lfo), a

        jp      nz, .skipEnv
        ld      a, (vol)
        dec     a
        ld      (vol), a

.skipEnv
        ld      hl, (freq)
        ex      de, hl

        ; Advance wave1
        ld      hl, (wave1)
        add     hl, de
        ld      (wave1), hl

        ; Advance wave2
        ld      hl, (wave2)
        add     de, 2
        add     hl, de
        ld      (wave2), hl

        ; Mix wave 1 and 2
        ld      hl, (wave1)
        srl     h
        rr      l
        ex      hl, de

        ld      hl, (wave2)
        srl     h
        rr      l

        add     hl, de

        ; Take MSB for playback
        ld      d, h
        ld      a, (vol)
        ld      e, a
        mul     d, e

        ld      a, d
        nextreg $2d, a

        ld      a, $00
        out     (Port.ULA), a

        pop     hl, de, bc, af
        ei
        reti

wave1   dw      $0000
wave2   dw      $0000
freq    dw      $0200
lfo     db      $00
vol     db      $ff


        savenex open "built/synth.nex", Main, $bfe0
        savenex auto
        savenex close

