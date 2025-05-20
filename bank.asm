        ifndef  Bank_asm
        define  Bank_asm

        include mem.asm
        include reg.asm
        include dma.asm

        include esxdos.asm
        include p3dos.asm

        module  Bank

; =========================================================
; Input
;   a - 8K bank number
Clear
        ld      e, 0
        ; fall-through

; =========================================================
; Input
;   a - 8K bank number
;   e - value
Fill
.loop
        nextreg Reg.MMU_7, a
        ld      a, e
        ld      de, $e000
        ld      bc, $2000
        jp      Dma.Fill

; ======================================================
; Output:
;   FC - 0 = ok, 1 = error
;   A - total bank count
Total
        ld      hl, $0000
        exx
        ld      de, P3DOS.IDE_BANK
        ld      c, 7
        rst     $08
        db      EsxDOS.p3dos
        ccf
        ld      a, e
        ret

; ======================================================
; Output:
;   A - number of available banks
;   FC - 0 = ok, 1 = error
Available
        ld      hl, $0004
        exx
        ld      de, P3DOS.IDE_BANK
        ld      c, 7
        rst     $08
        db      EsxDOS.p3dos
        ccf
        ld      a, e
        ret

; ======================================================
; Output:
;   FC - 0 = ok, 1 = error
;   A - bank
Alloc
        ld      hl, $0001
        exx
        ld      de, P3DOS.IDE_BANK
        ld      c, 7
        rst     $08
        db      EsxDOS.p3dos
        ccf
        ld      a, e
        ret

; ======================================================
; Input:
;   A - bank
; Output:
;   FC - 0 = ok, 1 = error
Free
        ld      e, a
        ld      hl, $0003
        exx
        ld      de, P3DOS.IDE_BANK
        ld      c, 7
        rst     $08
        db      EsxDOS.p3dos
        ccf
        ret

        endmodule
        endif
