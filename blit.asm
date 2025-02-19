        ifndef  Blit_asm
        define  Blit_asm

        include ex.asm
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
;   mmu - advanced
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
;     bit 5: middleTransparent
;     bit 4: startEnabled
;     bit 3..0: unused must be 0
; Output
;   hl - advanced
;   de - advanced
;   mmu - advanced
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
        jp      c, .middleTransparent
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
Copy3PatchLineRewind
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
        dec     a
        and     $0f
        inc     a
        add     hl, a
        pop     af
.noStart
        rlca
        jp      nc, .noMiddle
.middle
        inc     hl
.noMiddle
        rlca            ; skip transparent flag
        rlca
        jp      nc, .noEnd
.end
        push    af
        ld      a, b
        dec     a
        and     $0f
        inc     a
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
;     bit 5: middleTransparent
;     bit 4: startEnabled
;     bit 3..0: unused must be 0
;   bc' - width
; Output
;   hl, de, mmu - advanced
;   af, bc - preserved
;   bc' - 0
Copy3PatchLines
        push    af
.loop
        pop     af
        call    Copy3PatchLine
        push    af
        exb
        dec     bc
        ld      a, b
        or      c
        exb
        jp      nz, .loop
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
;     bit 5: middleTransparent
;     bit 4: startEnabled
;     bit 3..0: unused must be 0
;   bc' - width
; Output
;   hl, de, mmu - advanced
;   af, bc - preserved
;   bc' - 0
Copy3PatchLineRepeat
        push    af
.loop
        pop     af
        call    Copy3PatchLineRewind
        push    af
        exb
        dec     bc
        ld      a, b
        or      c
        exb
        jp      nz, .loop
        pop     af
        jp      Skip3PatchLine

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
;     bit 5: middleTransparent
;     bit 4: endEnabled
;     bit 3..0: unused, must be 0
;   b' -
;     bit 7..4: lineStartLength, 0 => 16
;     bit 3..0: lineEndLength, 0 => 16
;   c' - lineMiddleLength MSB, 0 => 256
;   a' - lineFlags
;     bit 7: lineStartEnabled
;     bit 6: lineMiddleEnabled
;     bit 5: lineMiddleLength, bit 8
;     bit 4: lineEndEnabled
;     bit 3..0: unused, must be 0
; Output
;   hl - advanced
;   de - advanced
;   bc, af, af' - corrupt
;   mmu - advanced
Copy9Patch
.init
        exa : exb               ; switch to line widths and flags
.checkStart
        rlca
        jp      nc, .noStart
.start
        push    bc              ; save lineWidths
        push    af              ; b = line width
        ld      a, b
        swapnib
        and     $0f
        ld      b, a
        pop     af
        exa
        push    af              ; save flags
        and      %11011111      ; clear middleTransparent
        exa
.startLoop
        exa : exb
        call    Copy3PatchLine
        exb : exa
        djnz    .startLoop
        exa
        pop     af              ; restore flags
        exa
        pop     bc              ; restore lineWidths
.noStart
.checkMiddle
        rlca
        jp      nc, .noMiddle
.middle
.checkMiddleMsd
        push    bc
        rlca
        jp      nc, .noMiddleMsb
.middleMsb
        ld      b, 1
        jp      .middleMsbDone
.noMiddleMsb
        ld      b, 0
.middleMsbDone
        push    af
.middleLoop
        pop     af
        exa : exb
        call    Copy3PatchLineRewind
        exb : exa
        dec     bc
        push    af
        ld      a, b
        or      c
        jp      nz, .middleLoop
        pop     af
        pop     bc
        exa : exb
        call    Skip3PatchLine
        exb : exa
        jp      .checkEnd
.noMiddle
        rlca    ; skip length MSB
.checkEnd
        rlca
        jp      nc, .noEnd
.end
        push    bc              ; save lineWidths
        push    af              ; b = lineWidth
        ld      a, b
        and     $0f
        ld      b, a
        pop     af
        exa                     ; set middleOpaque
        push    af
        and      %11011111      ; clear middleTransparent
        exa
.endLoop
        exa : exb
        call    Copy3PatchLine
        exb : exa
        djnz    .endLoop
        exa
        pop     af              ; restore flags
        exa
        pop     bc              ; restore lineWidths
.noEnd
.finalize
        exb : exa
        ret

        macro   BlitNinePatch src, dst, start, middle, end, lineStart, lineMiddle, lineEnd, transparent
        ld      hl, src
        ld      de, dst
        ld      a, ((start != 0) & %10000000) | ((middle != 0) & %01000000) | ((transparent != 0) & %00100000) | ((end != 0) & %00010000)
        ld      bc, ((start & $0f) << 12) | ((end & $0f) << 8) | (middle & $ff)
        exa
        ld      a, ((lineStart != 0) & %10000000) | ((lineMiddle != 0) & %01000000) | ((lineMiddle > 255) & %00100000) | ((lineEnd != 0) & %00010000)
        exa
        exb
        ld      bc, ((lineStart & $0f) << 12) | ((lineEnd & $0f) << 8) | (lineMiddle & $ff)
        exb
        call    Blit.Copy9Patch
        endm

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

; =========================================================
; Input
;   hl - src addr
;   de, mmu - dst addr
;   a - bit 1 color
; Output
;   hl, de, mmu - advanced
;   af - preserved
;   bc - corrupted
Copy8BitLine
        push    af
        push    de

        ld      b, a            ; move color to b
        ldi     a, (hl)         ; use a for 8-bit value
        ex      de, hl          ; use hl for transfer
.loop
.bit7
        rlca
        jp      nc, .bit6
        ld      (hl), b
.bit6
        inc     l
        rlca
        jp      nc, .bit5
        ld      (hl), b
.bit5
        inc     l
        rlca
        jp      nc, .bit4
        ld      (hl), b
.bit4
        inc     l
        rlca
        jp      nc, .bit3
        ld      (hl), b
.bit3
        inc     l
        rlca
        jp      nc, .bit2
        ld      (hl), b
.bit2
        inc     l
        rlca
        jp      nc, .bit1
        ld      (hl), b
.bit1
        inc     l
        rlca
        jp      nc, .bit0
        ld      (hl), b
.bit0
        inc     l
        rlca
        jp      nc, .nextLine
        ld      (hl), b
.nextLine
        ex      de, hl
        pop     de
        pop     af
        jp      BankedIncD

; =========================================================
; Input
;   hl - src addr
;   de, mmu - dst addr
;   bc - width
;   a - bit 1 value
; Output
;   hl, de, mmu - advanced
;   af - preserved
;   bc - 0
Copy8BitLines
        push    af
.loop
        pop     af
        push    bc
        call    Copy8BitLine
        pop     bc
        dec     bc
        push    af
        ld      a, b
        or      c
        jp      nz, .loop
        pop     af
        ret

; =========================================================
; Input
;   d - dst high addr in slot 7
;   bc' - line count
;   e' - dst bank
;   ix - line proc, where
;     Input
;       d - dst high addr
;       hl, bc, e - passed through
;     Output
;       d - preserved
;       hl, bc, e - passed through
ForEachLineMmu7
.setStartBank
        exx
        ld      a, e
        nextreg Reg.MMU_7, a
        exx

.loop
.line
        push    .ret
        jp      (ix)
.ret

.checkBank
        inc     d
        jp      nz, .bankValid
.incBank
        ld      d, $e0
        exx
        inc     e
        ld      a, e
        exx
        nextreg Reg.MMU_7, a

.bankValid
        exx
        dec     bc
        ld      a, b
        or      c
        exx
        jp      nz, .loop

        ret

; =========================================================
@CopyLineCallback
        push    bc
        push    de
        push    hl

        ld      b, 0
        ldir

        pop     hl
        pop     de
        pop     bc

        ld      a, b
        add     hl, a
        ret

; =========================================================
@CopyLineXCallback
        push    bc
        push    de
        push    hl

        exx
        ld      a, d
        exx
        ld      b, 0
        ldirx

        pop     hl
        pop     de
        pop     bc

        ld      a, b
        add     hl, a
        ret

; =========================================================
@FillLineCallback
        ld      a, (hl)

        push    bc
        push    de

        ld      b, c
.lineLoop
        ld      (de), a
        inc     e
        djnz    .lineLoop

        pop     de
        pop     bc

        ld      a, b
        add     hl, a
        ret

; =========================================================
@FillLineXCallback
        ld      a, (hl)
        exx
        cp      d
        exx
        jp      z, .transparent

        push    bc
        push    de

        ld      b, c
.lineLoop
        ld      (de), a
        inc     e
        djnz    .lineLoop

        pop     de
        pop     bc

.transparent
        ld      a, b
        add     hl, a
        ret

; =========================================================
; Input
;   hl - src
;   de - dst in slot 7
;   bc - line increment / line size
;   bc' - line count
;   e' - dst bank
CopyLinesMmu7
        ld      ix, CopyLineCallback
        jp      ForEachLineMmu7

; =========================================================
; Input
;   hl - src
;   de - dst in slot 7
;   bc - line increment / line size
;   bc' - line count
;   de' - transparent color / dst bank
CopyLinesXMmu7
        ld      ix, CopyLineXCallback
        jp      ForEachLineMmu7

; =========================================================
; Input
;   hl - src
;   de - dst
;   bc - line increment / line size
;   bc' - line count
;   e' - dst bank
FillLinesMmu7
        ld      ix, FillLineCallback
        jp      ForEachLineMmu7

; =========================================================
; Input
;   hl - src
;   de - dst
;   bc - line increment / line size
;   bc' - line count
;   de' - transparent color / dst bank
FillLinesXMmu7
        ld      ix, FillLineXCallback
        jp      ForEachLineMmu7

        endmodule

        endif
