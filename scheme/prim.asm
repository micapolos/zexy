; ===============================================================
; Calling convention:
; - first argument is passed in DEHL
; - second argument is passed in DEHL'
; - following arguments are passed on the stack in reverse order
; - return value is passed in DEHL
;
; Value encoding:
; - L = value header
;   - bit 7 = GC type: 0 - primitive, 1 - reference
;   - bit 6 = GC mark: 0 - not marked, 1 = marked
;   - bit 5..0 = 6-bit value / reference tag
;     - 000000 - symbol
;     - 000001 - pair
; - H = 8-bit value / bank number
; - DE = 16-bit value / address / symbol
; ===============================================================

        ifndef  SchemePrim_asm
        define  SchemePrim_asm

        module  SchemePrim

REFERENCE       equ %10000000
MARK            equ %01000000

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


        endmodule

        endif
