        ifndef  Stack_asm
        define  Stack_asm

        module  Stack

; Input
;   hl - addr
;   b - count, 0 = 256
Push16
        ; de = ret address
        pop     de

        ; hl - end addr
        ld      a, b
        add     hl, a
        add     hl, a

.loop
        dec     hl
        ld      b, (hl)
        dec     hl
        ld      c, (hl)
        push    bc
        dec     a
        jp      nz, .loop

        ex      de, hl
        jp      (hl)

; Input
;   hl - addr
;   b - count, 0 = 256
Pop16
        ; de = ret address
        pop     de
        ld      a, b
.loop
        pop     bc
        ld      (hl), c
        inc     hl
        ld      (hl), b
        inc     hl
        dec     a
        jp      nz, .loop

        ex      de, hl
        jp      (hl)

        endmodule

        endif
