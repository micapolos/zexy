        ifndef  SchemeGC_asm
        define  SchemeGC_asm

        include bank.asm

        module  SchemeGC
ENABLED equ     $80
MARK    equ     $40

        module  Pair
Alloc
        endmodule

        module  Page

        module  Type
_MASK   equ     %11
NATIVE  equ     %00
BYTE    equ     %01
CONS    equ     %10
VALUE   equ     %11
        endmodule

; =========================================================
; Input:
;   a - GC.Page.Type
; Output:
;   fc - 0 = OK, 1 = out of memory
;   a - page index
; =========================================================
Alloc
        push    af      ; push page type

        call    Bank.Alloc
        jp      c, .allocError

        pop     bc      ; b = page type
        push    af      ; push page index, fc = 0

        ld      hl, GC.pages
        add     hl, a
        ld      (hl), b ; store page type

        pop     af      ; a = page index, fc = 0
        ret

.allocError
        pop     af      ; pop page type
        ret             ; fc = 1

; =========================================================
; Input:
;   a - page index
; =========================================================
Mark
        ld      hl, GC.pages
        add     hl, a
        ld      b, (hl)     ; b = page
        ld      a, b        ; a = page
        and     GC.ENABLED
        ret     z

        ld      a, b        ; a = page
        and     GC.MARK
        ret     nz

        or      GC.MARK
        ld      (hl), a

        and     GC.Page.Type._MASK
        ld      hl, .table
        add     hl, a
        add     hl, a

        ld      de, (hl)
        ex      de, hl
        jp      (hl)

.table
        dw      0
        dw      0
        dw      MarkCons
        dw      MarkValue
        ret

MarkCons

        ret
MaskValue
        ret

; ========================================================
; Input:
;   a - page
; Output:
;   hl - page ptr
; ========================================================
        macro   GCGetPagePtr
        ld      hl, GC.pages
        add     hl, a
        add     hl, a
        endm

; ========================================================
; Input:
;   hl - page ptr
; Output:
;   hl - page
; ========================================================
        macro   GCPagePtrRef
        ld      de, (hl)
        ex      de, hl
        endm

        endmodule

pages   ds      256

        endmodule

        endif
