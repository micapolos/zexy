        ifndef  KeyTable_asm
        define  KeyTable_asm

        include port.asm
        include reg.asm
        include key-code.asm

        module  KeyTable

; =========================================================
; Input
;   a - key
; Output
;   nz - pressed
IsKeyPressed
        ; de = key ref
        ld      hl, @scanCodes
        rlca
        add     hl, a
        ld      de, (hl)

        ; hl = key line
        ld      hl, lines
        ld      a, d
        add     hl, a

        ; check key bit
        ld      a, (hl)
        and     e

        ret

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

; =========================================================

lines
.zx48   ds      8
.next   ds      2

; =========================================================

@keys
        db      KeyCode.space,  KeyCode.symb, KeyCode.m,  KeyCode.n,  KeyCode.b
        db      KeyCode.enter,  KeyCode.l,    KeyCode.k,  KeyCode.j,  KeyCode.h
        db      KeyCode.p,      KeyCode.o,    KeyCode.i,  KeyCode.u,  KeyCode.y
        db      KeyCode.n0,     KeyCode.n9,   KeyCode.n8, KeyCode.n7, KeyCode.n6
        db      KeyCode.n1,     KeyCode.n2,   KeyCode.n3, KeyCode.n4, KeyCode.n5
        db      KeyCode.q,      KeyCode.w,    KeyCode.e,  KeyCode.r,  KeyCode.t
        db      KeyCode.a,      KeyCode.s,    KeyCode.d,  KeyCode.f,  KeyCode.g
        db      KeyCode.caps,   KeyCode.z,    KeyCode.x,  KeyCode.c,  KeyCode.v

        db      KeyCode.right,  KeyCode.left,    KeyCode.down,   KeyCode.up
        db      KeyCode.dot,    KeyCode.comma,   KeyCode.quotes, KeyCode.colon
        db      KeyCode.extend, KeyCode.capslck, KeyCode.graph,  KeyCode.true
        db      KeyCode.inv,    KeyCode.break,   KeyCode.edit,   KeyCode.delete

; =========================================================

@scanCodes
.n0     db      3, %00001
.n1     db      3, %00010
.n2     db      3, %00100
.n3     db      3, %01000
.n4     db      3, %10000
.n5     db      4, %10000
.n6     db      4, %01000
.n7     db      4, %00100
.n8     db      4, %00010
.n9     db      4, %00001

.a      db      6, %00010
.b      db      0, %10001
.c      db      7, %01000
.d      db      6, %00100
.e      db      5, %00100
.f      db      6, %01000
.g      db      4, %10000
.h      db      1, %10000
.i      db      2, %00100
.j      db      1, %01000
.k      db      1, %00100
.l      db      1, %00010
.m      db      0, %00100
.n      db      0, %01000
.o      db      2, %00010
.p      db      2, %00001
.q      db      5, %00001
.r      db      5, %01000
.s      db      6, %00010
.t      db      5, %10000
.u      db      2, %01000
.v      db      7, %10000
.w      db      5, %00010
.x      db      7, %00100
.y      db      2, %10000
.z      db      7, %00010

.enter  db      1, %00001
.space  db      0, %00001
.caps   db      7, %00001
.symb   db      0, %00010
.left   db      8, %00000010
.right  db      8, %00000001
.up     db      8, %00001000
.down   db      8, %00000100
.dot    db      8, %00010000
.comma  db      8, %00100000
.quotes db      8, %01000000
.graph  db      9, %00000100
.edit   db      9, %01000000
.inv    db      9, %00010000
.true   db      9, %00001000
.delete db      9, %00000001
.break  db      9, %00000100
.colon  db      8, %10000000
.extend db      9, %00000001
.capslk db      9, %00000010

        endmodule

        endif
