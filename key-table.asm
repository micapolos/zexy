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
        ld      hl, @refs
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

@refs
.b               dw     $0010
.n               dw     $0008
.m               dw     $0004
.symb            dw     $0002
.space           dw     $0001

.h               dw     $0110
.j               dw     $0108
.k               dw     $0104
.l               dw     $0102
.enter           dw     $0101

.y               dw     $0210
.u               dw     $0208
.i               dw     $0204
.o               dw     $0202
.p               dw     $0201

.n6              dw     $0310
.n7              dw     $0308
.n8              dw     $0304
.n9              dw     $0302
.n0              dw     $0301

.n5              dw     $0410
.n4              dw     $0408
.n3              dw     $0404
.n2              dw     $0402
.n1              dw     $0401

.t               dw     $0510
.r               dw     $0508
.e               dw     $0504
.w               dw     $0502
.q               dw     $0501

.g               dw     $0610
.f               dw     $0608
.d               dw     $0604
.s               dw     $0602
.a               dw     $0601

.v               dw     $0710
.c               dw     $0708
.x               dw     $0704
.z               dw     $0702
.caps            dw     $0701

.colon           dw     $0880
.quotes          dw     $0840
.comma           dw     $0820
.dot             dw     $0810
.up              dw     $0808
.down            dw     $0804
.left            dw     $0802
.right           dw     $0801

.delete          dw     $0880
.edit            dw     $0840
.break           dw     $0820
.invVideo        dw     $0810
.trueVideo       dw     $0808
.graph           dw     $0804
.capslock        dw     $0802
.extend          dw     $0801

        endmodule

        endif
