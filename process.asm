        ifndef Process_asm
        define Process_asm

        struct Process
sp      dw
af      dw
bc      dw
de      dw
hl      dw
af2     dw
bc2     dw
de2     dw
hl2     dw
ix      dw
iy      dw
regEnd  align   $20
        ends

        assert  (Process == $20)

        module Process

regCount        equ     11

; Input
Save
        ; Save PC and SP in scratch location
        inc     sp
        inc     sp
        ld      (scratchSp), sp
        dec     sp
        dec     sp

        ; Push all registers on the stack
        exx
        push    hl
        push    de
        push    bc
        exx

        ex      af, af
        push    af
        ex      af, af

        push    iy
        push    ix

        push    hl
        push    de
        push    bc
        push    af

        ld      hl, (scratchSp)
        push    hl

        ld      hl, (scratchPc)
        push    hl

        ; Pop registers from the stack and save them to currentProcessPtr
        ld      hl, (currentProcessPtr)
        ld      b, regCount
.loop
        pop     de

        ld      (hl), e
        inc     hl

        ld      (hl), d
        inc     hl

        djnz    .loop

        ret

; Input
;   hl - process ptr
; Output
;   (currentProcessPtr) - process ptr
Load
        ld      (currentProcessPtr), hl
        add     hl, Process.regEnd

        ; Push process registers on the stack
        ld      b, regCount
.loop
        dec     hl
        ld      d, (hl)
        dec     hl
        ld      e, (hl)
        push    de
        djnz    .loop

        ; Pop into registers
        pop     hl
        ld      (scratchSp), hl

        pop     af, bc, de, hl

        ex      af, af
        exx
        pop     af, bc, de, hl
        exx
        ex      af, af

        pop     ix
        pop     iy

        ex      hl, (sp)
        ld      sp, hl

        ld      hl, (scratchHl)

        ; Return into the last remaining item on the stack, which is process PC.
        ei
        reti

currentProcessPtr       dw      0
scratchSp               dw      0

        endmodule

        endif
