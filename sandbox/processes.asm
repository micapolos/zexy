        device  zxspectrumnext

        org     $8000

        include nextreg.asm

Main
        di

        nextreg NextReg.ULA_CONTROL, %10000000  ; disable ula
        nextreg NextReg.CPU_SPEED, 3   ; 28MHz
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

        ld      a, 220
        out     (c), a

        ld      a, $73
        ei

ProcessEntry
.loop
        nextreg NextReg.TRANS_COLOR_FALLBACK, a
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
.ula            dw      IntEmpty
.uart0tx        dw      IntEmpty
.uart1tx        dw      IntEmpty
                dw      IntEmpty
                dw      IntEmpty

IntEmpty
        ei
        reti

IntCTC
        ; debug
        nextreg NextReg.TRANS_COLOR_FALLBACK, 0

        push    af
        push    bc
        push    de
        push    hl
        push    ix
        push    iy
        exx
        ex      af, af
        push    af
        push    bc
        push    de
        push    hl
        ex      af, af
        exx

        ; de = process SP
        ld      hl, 0
        add     hl, sp
        ex      de, hl

        ; a = current process
        ld      a, (CurrentProcess)

        ; hl = process ptr
        ld      hl, ProcessTable
        add     hl, a
        add     hl, a

        ; Save process SP
        ld      (hl), e
        inc     hl
        ld      (hl), d

        ; Switch to new process
        ld      a, (CurrentProcess)
        inc     a
        and     $01
        ld      (CurrentProcess), a

        ; hl = new process ptr
        ld      hl, ProcessTable
        add     hl, a
        add     hl, a

        ; de = new process sp
        ld      e, (hl)
        inc     hl
        ld      d, (hl)

        ; set new process SP
        ex      de, hl
        ld      sp, hl

        ; Pop new process registers
        exx
        ex      af, af
        pop     hl
        pop     de
        pop     bc
        pop     af
        ex      af, af
        exx
        pop     iy
        pop     ix
        pop     hl
        pop     de
        pop     bc
        pop     af

        ei
        reti

ProcessTable
                dw      ProcessStack.p0
                dw      ProcessStack.p1 - 22
CurrentProcess  db      0

ProcessStack
        ds      $100
.p0
        ds      $100 - 4
        dw      $f100   ; af
        dw      ProcessEntry
.p1

        savenex open "sandbox/processes.nex", Main, $bfe0
        savenex auto
        savenex close
