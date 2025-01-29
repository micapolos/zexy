        ifndef  Scheduler_asm
        define  Scheduler_asm

        include process.asm

        module  Scheduler

process
.countBits      equ     3
.count          equ     1 << .countBits
.current        db      0

        align   1 << (Process.bits + process.countBits)
processTable
.first
        align   Process.size
        Process { %00000001 }    ; active
        dup     process.count - 1
        align   Process.size
        Process
        edup

; Input
;   interrupts disabled
IntYield
        break
        ; SP is already on the stack
        ; Push other registers on the stack
        push    af, bc, de, hl
        exx
        ex      af, af
        push    af, bc, de, hl
        ex      af, af
        exx
        push    ix, iy

        ; hl = process table ptr
        ld      a, (currentProcessIndex)
        call    GetProcessPtr
        add     hl, Process.regEnd
        ld      b, Process.regCount
.popLoop
        pop     de
        dec     (hl)
        ld      (hl), d
        dec     (hl)
        ld      (hl), e
        djnz    .popLoop
        break

        ; Select next process
        ld      a, (currentProcessIndex)
        or      a
        jp      nz ,.nonZeroProcess
        ld      a, (processCount)
.nonZeroProcess
        dec     a
        ld      (currentProcessIndex), a
        break

        ; Push process registers on the stack, SP first
        call    GetProcessPtr
        ld      b, Process.regCount
.pushLoop
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl
        push    de
        djnz    .pushLoop

        ; Pop register except SP
        pop     iy, ix
        ex      af, af
        exx
        pop     hl, de, bc, af
        exx
        ex      af, af
        pop     hl, de, bc, af

        ; SP is at the top of the stack
        break
        ei
        reti

; Input
;    a - process index
; Output
;    hl - process ptr
@GetProcessPtr
        ; hl = process table ptr
        ld      hl, processTableMsb
        ld      h, (hl)

        ld      a, (currentProcessIndex)
        rlca
        ld      l, a

        ; hl - process ptr
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        ex      de, hl

        ret

@processTableMsb         db     0

; $01..$80
@processCount            db     0

; bit 7: 1 - idle, 0 - running
; bit 6..0: running process index
@currentProcessIndex     db     0

        endmodule

        endif
