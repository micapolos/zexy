        ifndef  Blit_asm
        define  Blit_asm

        include call.asm
        include reg.asm

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
;   hl - src addr
;   de - dst addr
;   bc - src stride / length
; Output
;   hl - advanced
;   de - advanced
;   bc - preserved
CopyLineStride256
        push    bc
        push    de

        ld      a, b
        ld      b, 0
        ldir

        pop     de
        pop     bc

        add     hl, a           ; hl += srcStride
        inc     d               ; de = next dstLine

        ret

; =========================================================
; Input
;   hl - src addr
;   de - dst addr
;   b -
;     bit 7..4: endLength, 0 => 16
;     bit 3..0: startLength, 0 => 16
;   c - middleLength, 0 => 256
;   a - flags
;     bit 7..3: unused, must be 0
;     bit 2: endEnabled
;     bit 1: middleEnabled
;     bit 0: startEnabled
; Output
;   hl - advanced
;   de - advanced
;   bc, af, af' - corrupt
Copy3PatchLine
        rlca
        jp      nc, .noStart
.start
        exa
        push    bc
        ld      a, b
        swapnib
        and     $0f
        ld      c, a
        ld      b, 0
        ldir
        pop     bc
        exa
.noStart
        rlca
        jp      nc, .noMiddle
.middle
        exa
        push    bc
        ld      b, c
.middleLoop
        ld      a, (hl)
        ldi     (de), a
        djnz    .middleLoop
        inc     hl
        pop     bc
        exa
.noMiddle
        rlca
        jp      nc, .noEnd
.end
        exa
        ld      a, b
        and     $0f
        ld      c, a
        ld      b, 0
        ldir
        exa
.noEnd
        ret

; =========================================================
; Input
;   hl - src addr
;   de - dst addr
;   bc - src stride / length
; Output
;   hl - preserved
;   de - advanced
;   bc - preserved
CopyLineStride256PreserveSrc
        push    hl
        push    bc
        push    de

        ld      a, b
        ld      b, 0
        ldir

        pop     de
        inc     d               ; de = next dstLine

        pop     bc
        pop     hl

        ret

; =========================================================
; Input
;   hl - src addr
;   de - dst addr
;   bc - src stride / length
;   bc' - line count
; Output
;   hl - advanced
;   de - advanced
;   bc - preserved
;   bc' - 0
CopyLinesStride256
.loop
        call    CopyLineStride256

        exx
        dec     bc
        ld      a, b
        or      c
        exx

        jp      nz, .loop
        ret

; =========================================================
; Input
;   hl - src addr
;   de - dst addr
;   bc - src stride / length
;   bc' - line count
; Output
;   hl - advanced
;   de - advanced
;   bc - preserved
CopyLineStride256Repeat
.loop
        call    CopyLineStride256PreserveSrc

        exx
        dec     bc
        ld      a, b
        or      c
        exx

        jp      nz, .loop
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
