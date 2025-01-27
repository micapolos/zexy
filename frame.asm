        ifndef  Frame_asm
        define  Frame_asm

        include size.asm
        include coord.asm

        struct  Frame
coord   Coord
size    Size
        ends

        module  Frame

; Input:
;   de - col / row
;   bc - width / height
; Output:
;   de - opposite col / row
;   bc, hl - preserved
Swap
        ld      a, d
        add     b
        dec     a
        ld      d, a

        ld      a, e
        add     c
        dec     a
        ld      e, a

        ret

        endmodule

        endif
