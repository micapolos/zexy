        ifndef  Scheduler_asm
        define  Scheduler_asm

        include reg.asm
        include int-table.asm

        module  Scheduler

; =========================================================
Init
        di

        nextreg $c0, (IntTable.start & %11100000) | %00000001
        nextreg $c4, %10000000   ; exp bus, no ULA interrupt
        nextreg $c5, %00000001   ; ctc channel 0
        nextreg $c6, %00000000   ;

        ld      a, IntTable.start >> 8
        ld      i, a

        im      2

        ; Set IntHandler entry in IntTable
        ld      hl, IntTable.ctc0
        ld      (hl), IntHandler & $ff
        inc     hl
        ld      (hl), IntHandler >> 8

        ; reset CTC
        ld      bc, $183b
        ld      a, %00000011
        out     (c), a
        out     (c), a

        ld      a, %10100101
        out     (c), a                   ; int en, timer, /256, time const follows

        ld      a, 220
        out     (c), a

        ei
        ret

; =============================================================
; Input
;   bc - start address
;   de - stack address
;   a - parameter
; Output
;   fc - 0 = success, 1 = error
Launch
        di

        push    af      ; parameter

        ld      a, (processCount)
        cp      MAX_PROCESS_COUNT
        jp      c, .ok
        pop     af
        scf
        ei
        ret
.ok
        inc     a
        ld      (processCount), a

        ; hl = stack pointer
        ex      de, hl

        ; push start address
        dec     hl
        ld      (hl), b
        dec     hl
        ld      (hl), c

        ; pop parameter into BC
        pop     bc

        ; push parameter
        dec     hl
        ld      (hl), b
        dec     hl
        ld      (hl), c

        ; push zeros for other registers
        ld      b, 18
.zeroRegsLoop
        ld      (hl), 0
        dec     hl
        djnz    .zeroRegsLoop

        ; de - process sp
        ex      de, hl

        ; store process SP in the table, at the last index
        ld      a, (processCount)
        dec     a

        ld      hl, processTable
        rlca
        add     hl, a

        ld      (hl), e
        inc     hl
        ld      (hl), d

        or      a       ; clear carry flag
        ei
        ret

; =============================================================
; Interrupt handler, switches to the next process.
@IntHandler
        ; debug
        nextreg Reg.TRANS_COLOR_FALLBACK, 0

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
        ld      a, (processIndex)

        ; hl = process ptr
        ld      hl, processTable
        rlca
        add     hl, a

        ; Save process SP
        ld      (hl), e
        inc     hl
        ld      (hl), d

        ; Switch to new process
        ld      a, (processIndex)
        or      a
        jp      nz, .noProcessIndexWrap
        ld      hl, processCount
        add     (hl)
.noProcessIndexWrap
        dec     a
        ld      (processIndex), a

        ; hl = new process ptr
        ld      hl, processTable
        rlca
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

@MAX_PROCESS_COUNT      equ     32
@processCount           db      1
@processIndex           db      0
@processTable           ds      MAX_PROCESS_COUNT * 2

        endmodule

        endif
