; ===============================================================
; Value encoding:
; - L = value header
;   - bit 7 = allocation status: 0 = free, 1 = allocated
;   - bit 6 = value type: 0 - primitive (GC leaf), 1 - reference (subject to GC)
;   - bit 5 = GC mark: 0 - not marked, 1 = marked
;   - bit 4 = unused
;   - bit 3..0 = 3-bit value / reference tag
;     - 0000 - symbol
;     - 0001 - pair
; - H = 8-bit value / bank number
; - DE = 16-bit value / address / symbol
; ===============================================================

        ifndef  SchemeValue_asm
        define  SchemeValue_asm

        include ../reg.asm

        module  SchemeValue

ALLOCATED       equ %10000000
REFERENCE       equ %01000000
MARK            equ %00100000

FALSE_TAG       equ 0
TRUE_TAG        equ 1

        endmodule

        endif
