        ifndef POT_asm
        define POT_asm

        module POT

        align   32

table
        dw      %0000000000000001
        dw      %0000000000000010
        dw      %0000000000000100
        dw      %0000000000001000
        dw      %0000000000010000
        dw      %0000000000100000
        dw      %0000000001000000
        dw      %0000000010000000
        dw      %0000000100000000
        dw      %0000001000000000
        dw      %0000010000000000
        dw      %0000100000000000
        dw      %0001000000000000
        dw      %0010000000000000
        dw      %0100000000000000
        dw      %1000000000000000
.end

; ------------------------------------------------------
; Input:
;   A - exponent, 0..15
; Output:
;   DE - power of two
Get
        ld      h, high table
        ld      l, low table
        rlca
        or      a
        ldi     de, (hl)
        ret

        endmodule

        endif
