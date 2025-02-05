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

; ========================================================
; Blits 256-aligned lines starting from the given bank.
;
; Input
;   h - line address MSB in bank 7, $e0..$ff
;   l - bank number
;   (.blitLineProc) - blit line proc
;     Input
;       h - line address MSB
;       l - bank number
;       de - preserved
;       bc - preserved
;       af - corrupted
;     Output
;       f - z to stop, nz to continue
; Output
;     z - stop
Bank7Lines256UntilZ
.bankLoop
        ; set bank "e" in slot 7
        ld      a, l
        nextreg Reg.MMU_7, a

.lineLoop
        push    hl
.blitLineProc+* call    0
        pop     hl
        ret     z

.nextLine
        inc     h
        ld      a, h
        and     $1f
        jp      nz, .lineLoop

.nextBank
        ld      h, $e0
        inc     l
        jp      .bankLoop

        endmodule

        endif
