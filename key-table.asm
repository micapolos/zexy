        ifndef  KeyTable_asm
        define  KeyTable_asm

        include port.asm
        include reg.asm
        include key.asm

        module  KeyTable

lines
.zx48   ds      8
.next   ds      2
keys
        db      Key.space,  Key.symb, Key.m,  Key.n,  Key.b
        db      Key.enter,  Key.l,    Key.k,  Key.j,  Key.h
        db      Key.p,      Key.o,    Key.i,  Key.u,  Key.y
        db      Key.n0,     Key.n9,   Key.n8, Key.n7, Key.n6
        db      Key.n1,     Key.n2,   Key.n3, Key.n4, Key.n5
        db      Key.q,      Key.w,    Key.e,  Key.r,  Key.t
        db      Key.a,      Key.s,    Key.d,  Key.f,  Key.g
        db      Key.caps,   Key.z,    Key.x,  Key.c,  Key.v

        db      Key.right,  Key.left,    Key.down,   Key.up
        db      Key.dot,    Key.comma,   Key.quotes, Key.colon
        db      Key.extend, Key.capslck, Key.graph,  Key.true
        db      Key.inv,    Key.break,   Key.edit,   Key.delete

; =========================================================
; Input
;   iy = callback, where
;     Input
;       a - bit 7: 1 = keydown, 0 = keyup
;           bit 6: unused 0
;           bit 5..0: key
Scan
        ld      hl, keys
        ld      de, lines

        call    ScanZx48Lines

        ld      a, Reg.EXT_KEYS_0
        call    ScanExtLine

        ld      a, Reg.EXT_KEYS_1
        jp      ScanExtLine

; =========================================================
; Input
;   hl = keys ptr
;   de = lines ptr
;   iy = callback, where
;     Input
;       a - bit 7: 1 = keydown, 0 = keyup
;           bit 6: unused 0
;           bit 5..0: key
; Output
;   hl - advanced
;   de - advanced
@ScanZx48Lines
        ld      a, 8            ; 8 lines
        ld      bc, $7ffe       ; starting port
.loop
        push    af
        call    ScanZx48Line
        pop     af
        dec     a
        jp      nz, .loop
        ret

; =========================================================
; Input
;   hl = keys ptr
;   de = lines ptr
;   bc = ULA keyboard port $xxfe
;   iy = callback, where
;     Input
;       a - bit 7: 1 = keydown, 0 = keyup
;           bit 6: unused 0
;           bit 5..0: key
; Output
;   hl - advanced
;   de - advanced
;   bc - advanced
@ScanZx48Line
        push    bc

        in      a, (c)          ; read key state
        cpl                     ; invert: 1=pressed, 0=not pressed
        and     %00011111       ; mask-out unused bits
        ld      c, a            ; c = line

        ld      b, 5            ; 5 bits in line
        call    ScanLine
        pop     bc

        rrc     b               ; next port
        ret

; =========================================================
; Input
;   hl = keys ptr
;   de = lines ptr
;   a = ext keys reg
;   iy = callback, where
;     Input
;       a - bit 7: 1 = keydown, 0 = keyup
;           bit 6: unused 0
;           bit 5..0: key
; Output
;   hl - advanced
;   de - advanced
@ScanExtLine
        call    Reg.Read
        ld      c, a
        ld      b, 8
        jp      ScanLine

; =========================================================
; Input
;   hl = keys ptr
;   de = lines ptr
;   bc = bit count / line
;   iy = callback, where
;     Input
;       a - bit 7: 1 = keydown, 0 = keyup
;           bit 6: unused 0
;           bit 5..0: key
; Output
;   hl - advanced
;   de - advanced
@ScanLine
        ld       a, (de)        ; a = old line

        ex       de, hl
        ldi      (hl), c        ; save new line
        ex       de, hl

        xor      c              ; a = line changes
        jp       nz, .lineChanges
.noLineChanges
        ld       a, b
        add      hl, a          ; skip b keys
        ret
.lineChanges
        push     de

        ld       e, a           ; e = line changes
.loop
        rrc      e              ; next change bit
        jp       nc, .noChange
.change
        push     af
        ldi      a, (hl)
        rrc      c              ; next key-pressed bit
        jp       nc, .keyUp
.keyDown
        or       $80            ; key down, set bit 7 in a
.keyUp
        push     hl
        push     bc
        push     de

        ; call (iy)
        push     .ret
        jp       (iy)

.ret
        pop      de
        pop      bc
        pop      hl
        pop      af
        jp       .nextBit
.noChange
        inc      hl
        rrc      c              ; next key-pressed bit
.nextBit
        djnz     .loop

        pop      de
        ret

        endmodule

        endif
