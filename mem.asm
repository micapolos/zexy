        ifndef  Mem_asm
        define  Mem_asm

        module  Mem

; Input
;   hl - addr
;   bc - size
;   e - value
; Output
;   hl - advanced
;   bc - 0
;   de - preserved
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
