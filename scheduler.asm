        ifndef  Scheduler_asm
        define  Scheduler_asm

        include process.asm

        module  Scheduler

; Initializes scheduler which this process becoming process 0.
; Input
;   h - processTableMsb
Init
        ld      a, h
        ld      (processTableMsb), a

        ld      a, 1
        ld      (processCount), a

        ld      a, 0
        ld      (currentProcessIndex), a

        ret

; Input
;   ix - Process ptr
; Output
;   FC - 1 = error, 0 = ok
Launch:
        di

        ; Increment process count
        ld      a, (processCount)
        inc     a
        and     $80
        jp      z, .countOk

        scf
        jp      .ret

.countOk
        ld      (processCount), a

        ; Store process ptr in the table
        ld      hl, (processTableMsb)
        ld      h, (hl)
        rlca
        ld      l, a

        ld      a, ixl
        ld      (hl), a
        inc     hl
        ld      a, ixh
        ld      (hl), a

        xor     a  ; clear FC
.ret
        ei
        ret

; Input
;   (Process.current) - current process index
@Exit
        ; TODO: Support processes which return
        break

; Input
;   (currentPtr) - Process ptr
;   interrupts disabled
IntYield
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

        ; Select next process
        ld      a, (currentProcessIndex)
        or      a
        jp      nz ,.nonZeroProcess
        ld      a, (processCount)
.nonZeroProcess
        dec     a
        ld      (currentProcessIndex), a

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
