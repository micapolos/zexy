        ifndef Put_asm
        define Put_asm

        include printer.asm

        module Put

; Input
;   ix - printer ptr
;   a - 2 digits
DigitsHiLo
        push    af
        call    DigitHi
        pop     af
        jp      DigitLo

; Input
;   ix - printer ptr
;   a - digit in MSB 4 bits
DigitHi
        swapnib

; Input
;   ix - printer ptr
;   a - digit in LSB 4 bits
DigitLo
        and     $0f
        add     $30
        jp      Printer.Put

        endmodule

        endif
