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
;   a - stride
CopyRect8
.nextRow
        push    bc
.nextCell
        dec     b
        ld      c, b
        ld      b, 0
        inc     c
        ldir
        pop     bc

        add     hl, a
        add     de, a

        dec     c
        jp      nz, .nextRow

        ret

        endmodule

        endif
