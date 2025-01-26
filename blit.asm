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

; Input:
;   hl - src start
;   de - dst start
;   bc - width / height
;   ixh - src stride
;   ixl - dst stride
CopyRect8Inc
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

        endmodule

        endif
