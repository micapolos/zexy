        ifndef  Mem_asm
        define  Mem_asm

        module  Mem

; =========================================================
; Input
;   hl - addr
;   bc - size
Clear
        ld      e, 0
        ; fallthrough

; =========================================================
; Input
;   hl - addr
;   bc - size
;   e - value
Fill
.loop
        ld      (hl), e
        inc     hl
        dec     bc
        ld      a, b
        or      c
        jp      nz, .loop
        ret

        endmodule

        endif
