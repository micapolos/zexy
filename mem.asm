        ifndef  Mem_asm
        define  Mem_asm

        include zexy.asm

        module  Mem

; =========================================================
; Input
;   hl - addr
;   bc - size
; =========================================================
Clear
        ld      e, 0
        ; fallthrough

; =========================================================
; Input
;   hl - addr
;   bc - size
;   e - value
; =========================================================
Fill
.loop
        ld      (hl), e
        inc     hl
        dec     bc
        ld      a, b
        or      c
        jp      nz, .loop
        ret

; =========================================================
; Input
;   de - lhs addr
;   hl - rhs addr
;   bc - size
; Output
;   fz - 0 = eq, 1 - not eq
; =========================================================
Eq
        ld      a, (de)
        inc     de
        cpi
        ret     nz
        ld      a, b
        or      c
        jp      nz, Eq
        ret

        endmodule

        endif
