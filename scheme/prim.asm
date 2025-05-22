; ===============================================================
; Value encoding:
; - L = value header
;   - bit 7 = allocation status: 0 = free, 1 = allocated
;   - bit 6 = value type: 0 - primitive (GC leaf), 1 - reference (subject to GC)
;   - bit 5 = GC mark: 0 - not marked, 1 = marked
;   - bit 4 = unused
;   - bit 3..0 = 3-bit value / reference tag
;     - 000000 - symbol
;     - 000001 - pair
; - H = 8-bit value / bank number
; - DE = 16-bit value / address / symbol
;
; Calling convention:
; - first argument passed in DEHL
; - second argument passed in DEHL'
; - following arguments passed on the stack in reverse order
; - return value passed in DEHL
; ===============================================================

        ifndef  SchemePrim_asm
        define  SchemePrim_asm

        include ../reg.asm

        module  SchemePrim

ALLOCATED       equ %10000000
REFERENCE       equ %01000000
MARK            equ %00100000

FALSE_TAG       equ 0
TRUE_TAG        equ 1

; =============================================================
Not1
        ld      a, l
        xor     1
        ld      l, a
        ret

; =============================================================
Zero8
        ld      l, FALSE_TAG
        xor     a
        or      h
        ret     nz
        ld      l, TRUE_TAG
        ret

; =============================================================
Eq8
        ld      l, FALSE_TAG
        ld      a, h
        exx
        or      h
        ret     nz
        ld      l, TRUE_TAG
        ret

; =============================================================
Not8
        ld      a, l
        cpl
        ld      l, a
        ret

; =============================================================
Neg8
        ld      a, l
        neg
        ld      l, a
        ret

; =============================================================
Inc8
        inc     h
        ret

; =============================================================
Dec8
        dec     h
        ret

; =============================================================
Add8
        ld      a, h
        exx
        add     h
        ret

; =============================================================
Sub8
        ld      a, h
        exx
        sub     h
        ret

; =============================================================
Zero16
        ld      l, FALSE_TAG
        xor     a
        or      e
        or      d
        ret     nz
        ld      l, TRUE_TAG
        ret

; =============================================================
Eq16
        ld      l, FALSE_TAG
        ld      a, e
        exx
        or      e
        ret     nz
        ld      a, d
        exx
        or      d
        ret     nz
        ld      l, TRUE_TAG
        ret

; =============================================================
Inc16
        inc     de
        ret

; =============================================================
Dec16
        dec     de
        ret

; =============================================================
Add16
        exx
        push    de
        exx
        pop     hl
        add     de, hl
        ret

; =============================================================
Sub16
        exx
        push    de
        exx
        pop     hl
        or      a  ; clear carry
        sbc     de, hl
        ret

; =============================================================
Eq24
        ld      l, FALSE_TAG
        ld      a, h
        exx
        or      h
        ret     nz
        ld      a, e
        exx
        or      e
        ret     nz
        ld      a, d
        exx
        or      d
        ret     nz
        ld      l, TRUE_TAG
        ret

; =============================================================
Cons
        ; TODO
        ret

; =============================================================
Car
        ld      a, h
        nextreg Reg.MMU_7, a
        ex      de, hl
        jp      Load

; =============================================================
Cdr
        ld      a, h
        nextreg Reg.MMU_7, a
        ex      de, hl
        add     hl, 4
        jp      Load

; =============================================================
; hl - address
Load
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        ld      h, b
        ld      l, c
        ret

        endmodule

        endif
