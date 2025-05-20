        ifndef  Scheme_asm
        define  Scheme_asm
        module  Scheme

MARK_MASK       equ $80  ; flag used for mark&sweep
PAIR_MASK       equ $40  ; indicates GC pair
TAG_MASK        equ $30  ; 2 bits of tag
DATA_MASK       equ $0F  ; high bits of data

INT_TAG         equ $00
SYMBOL_TAG      equ $10
PAIR_TAG        equ $20
OTHER_TAG       equ $30

UNDEFINED_VALUE equ (PRIM_KIND | OTHER_TAG | $00) << 8 | 0
NIL_VALUE       equ (PRIM_KIND | OTHER_TAG | $00) << 8 | 1
FALSE_VALUE     equ (PRIM_KIND | OTHER_TAG | $00) << 8 | 2
TRUE_VALUE      equ (PRIM_KIND | OTHER_TAG | $00) << 8 | 3
ERROR_VALUE     equ (PRIM_KIND | OTHER_TAG | $08) << 8

        macro   ErrorValue code
        ld      hl, ERROR_VALUE | code
        endm

; Input
;   HL - object
; Output
;   Z - if int
IsInt:
        ld a, e
        and TAG_MASK
        xor INT_TAG
        ret

; Input
;   HL - object
; Output
;   Z - if error
IsError:
        ld a, e
        and TAG_MASK
        xor ERROR_TAG
        ret

; ------------------------------------------------------------
; Input
;   HL - object
;   BC - object
; Output
;   Z = eq
Eq:
        ld a, h
        xor b
        ret nz
        ld a, l
        xor c
        ret

; ===========================================================

OBJ_SIZE       equ  2

BANK_BITS      equ  13
BANK_SIZE      equ  1 << BANK_BITS
BANK_MASK      equ  BANK_SIZE - 1
BANK_OBJ_COUNT equ  BANK_SIZE / OBJ_SIZE
PAIR_COUNT     equ  BANK_OBJ_COUNT >> 1

HeapBank    db 0
HeapUsed    dw 0

        endmodule
        endif
