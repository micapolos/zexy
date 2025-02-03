        ifndef  Blit_asm
        define  Blit_asm

        include call.asm

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
CopyRect8Inc
.nextRow
        push    bc
.nextCell
        dec     b
        ld      c, b
        ld      b, 0
        inc     c
        ldir

        add     hl, a
        add     de, a

        pop     bc
        dec     c
        jp      nz, .nextRow

        ret

; Input:
;   hl - src start
;   de - dst start
;   bc - width / height
;   a - stride
CopyRect8Dec
.nextRow
        push    bc
.nextCell
        dec     b
        ld      c, b
        ld      b, 0
        inc     c
        lddr
        ; at this point, BC = 0

        ld      c, a
        sub     hl, bc
        sub     de, bc

        pop     bc
        dec     c
        jp      nz, .nextRow

        ret

; =========================================================
; Input
;   h - line MSB
;   c - count
;   a, b, de, l - passed to callback
;   iy - BlitLine proc
;     Input
;       h - line MSB
;     Output
;       h, c - preserved
BlitLines
.loop
        calli   iy
        inc     h
        dec     c
        jp      nz, .loop
        ret

        endmodule

        endif
