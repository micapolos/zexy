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
;   d - addr
; Output
;   d - incremented
;   other - preserved
BankedIncD
        push    af
        ld      a, d
        inc     a
        test    $1f
        jp      nz, .noBankWrap
.bankWrap
        sub     $20
        ld      d, a
        swapnib
        rrca
        add     Reg.MMU_0
        call    Reg.Inc
        jp      .ret
.noBankWrap
        ld      d, a
.ret
        pop     af
        ret

; =========================================================
; Input
;   hl - src addr
;   de - dst addr
;   b -
;     bit 7..4: startLength, 0 => 16
;     bit 3..0: endLength, 0 => 16
;   c - middleLength, 0 => 256
;   a - flags
;     bit 7: startEnabled
;     bit 6: middleEnabled
;     bit 5: middleOpaque
;     bit 4: startEnabled
;     bit 3..0: unused must be 0
; Output
;   hl - advanced
;   de - advanced
Copy3PatchLine
        push    af
        push    bc
        push    de
        exa
        push    af
        exa

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
        rlca
        jp      nc, .middleTransparent
.middleOpaque
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
        jp      .noMiddle
.middleTransparent
        exa
        ld      a, c
        add     de, a
        inc     hl
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
        exa
        pop     af
        exa

        pop     de
        pop     bc
        pop     af

        jp      BankedIncD

; Same as above, but src addr is restored
Copy3PatchLineRepeat
        push    hl
        call    Copy3PatchLine
        pop     hl
        ret

; Same as above, but skips over single src line
Skip3PatchLine
        push    af
        rlca
        jp      nc, .noStart
.start
        push    af
        ld      a, b
        swapnib
        and     $0f
        add     hl, a
        pop     af
.noStart
        rlca
        jp      nc, .noMiddle
.middle
        push    af
        ld      a, c    ; TODO: What about c=0=256? Is it important?
        add     hl, a
        pop     af
.noMiddle
        rlca            ; skip transparent flag
        rlca
        jp      nc, .noEnd
.end
        push    af
        ld      a, b
        and     $0f
        add     hl, a
        pop     af
.noEnd
        pop     af
        ret

; =========================================================
; Input
;   hl - src addr
;   de - dst addr
;   b -
;     bit 7..4: startLength, 0 => 16
;     bit 3..0: endLength, 0 => 16
;   c - middleLength, 0 => 256
;   a - flags
;     bit 7: startEnabled
;     bit 6: middleEnabled
;     bit 5: middleOpaque
;     bit 4: endEnabled
;     bit 3: unused, must be 0
;   b' -
;     bit 7..4: lineStartLength, 0 => 16
;     bit 3..0: lineEndLength, 0 => 16
;   c' - lineMiddleLength MSB, 0 => 256
;   a' - line flags
;     bit 7: lineStartEnabled
;     bit 6: lineMiddleEnabled
;     bit 5: lineMiddleLength, bit 8
;     bit 4: lineEndEnabled
;     bit 3..0: unused, must be 0
; Output
;   hl - advanced
;   de - advanced
;   bc, af, af' - corrupt
Copy9Patch
        exa
        rlca
        jp      nc, .noStart
.start
        push    bc
        exx : push bc : exx : pop bc    ; ld bc, bc'
        push    af
        ld      a, b
        swapnib
        and     $0f
        ld      b, a
        exa
.startLoop
        push    bc
        exx : push bc : exx : pop bc    ; ld bc, bc'
        call    Copy3PatchLine
        pop     bc
        djnz    .startLoop
        exa
        pop     af
        pop     bc
.noStart
        rlca
        jp      nc, .noMiddle
.middle
        push    bc
        exx : push bc : exx : pop bc    ; ld bc, bc'
        push    af
        ld      b, c
        exa
.middleLoop
        push    bc
        exx : push bc : exx : pop bc    ; ld bc, bc'
        call    Copy3PatchLineRepeat
        pop     bc
        djnz    .middleLoop
        push    bc
        exx : push bc : exx : pop bc    ; ld bc, bc'
        call    Skip3PatchLine
        pop     bc
        exa
        pop     af
        pop     bc
.noMiddle
        rlca
        rlca
        jp      nc, .noEnd
.end
        push    bc
        exx : push bc : exx : pop bc    ; ld bc, bc'
        push    af
        ld      a, b
        and     $0f
        ld      b, a
        exa
.endLoop
        push    bc
        exx : push bc : exx : pop bc    ; ld bc, bc'
        call    Copy3PatchLine
        pop     bc
        djnz    .endLoop
        exa
        pop     af
        pop     bc
.noEnd
        exa
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
