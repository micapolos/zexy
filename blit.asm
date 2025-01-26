        ifndef  Blit_asm
        define  Blit_asm

        module  Blit

; Input:
;   hl - address
;   bc - width, height
;   de - value
;   a - stride
FillRect16:
.loop
        push    bc
.rowLoop
        ld      (hl), e
        inc     hl
        ld      (hl), d
        inc     hl
        djnz    .rowLoop

        add     hl, a
        add     hl, a

        pop     bc
        dec     c
        jp      nz, .loop

        ret

        macro   MakeCopyRect8  name, ldi_instr, add_instr
; Input:
;   HL - src start
;   DE - dst start
;   BC - width / height
;   ixh - src stride
;   ixl - dst stride
name
.nextRow
        push    bc
        ld      a, b
.nextCell
        ldi
        inc     bc
        djnz    .nextCell
        pop     bc
        ld      b, a

        ld      a, ixh
        add     hl, a
        ld      a, ixl
        add     de, a

        dec     c
        jp      nz, .nextRow

        ret
        endm

        MakeCopyRect8 CopyRect8Inc, ldi, add
        MakeCopyRect8 CopyRect8Dec, ldd, sub

        endmodule

        endif
