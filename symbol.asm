        ifndef  Symbol_asm
        define  Symbol_asm
        module  Symbol

        include esxdos.asm
        include p3dos.asm

bank    db      0

; ======================================================
; Output:
;   FC: 0 = ok, 1 = out of memory
;   E: bank
Init
        ld      hl, $0001  ; alloc standard bank
        exx
        ld      de, P3DOS.IDE_BANK
        rst     $08
        db      EsxDOS.p3dos
        ccf
        ret

        endmodule
        endif
