        ifndef Process_asm
        define Process_asm

        struct Process
pc      dw
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
        ends

        module Process

; Input
Save
        ; Save PC and SP in scratch location
        ex      hl, (sp)
        ld      (scratchPc), hl
        ex      hl, (sp)
        ld      (scratchSp), sp

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
        ld      b, 12
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

        ; Pop return address from the stack, as it'll be replaced with process return address
        pop     hl

        ; Push process registers on the stack
        ld      b, 12
.loop
        ld      e, (hl)
        inc     hl

        ld      d, (hl)
        inc     hl

        push    de

        djnz    .loop

        ; Pop into registers
        pop     iy
        pop     ix

        exx
        pop     hl
        pop     de
        pop     bc
        exx
        ex      af, af
        pop     af
        ex      af, af

        pop     hl
        ld      (scratchHl), hl
        pop     de
        pop     bc
        pop     af

        ex      hl, (sp)
        ld      sp, hl

        ld      hl, (scratchHl)

        ; Return into the last remaining item on the stack, which is process PC.
        ret

currentProcessPtr       dw      0
scratchPc               dw      0
scratchSp               dw      0
scratchHl               dw      0

        endmodule

        endif
