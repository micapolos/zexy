        ifndef Put_asm
        define Put_asm

        module Put

; Input
;   A - 2 digits
;
DigitsHiLo
        push    af
        call    DigitHi
        pop     af
        jp      DigitLo

; Input
;   A - digit in MSB 4 bits
DigitHi
        swapnib

; Input
;   A - digit in LSB 4 bits
DigitLo
        and     $0f
        add     $30
        rst     $10
        ret

        endmodule

        endif
