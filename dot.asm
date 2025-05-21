        ifndef Dot_asm
        define Dot_asm

        include writer.asm

        module Dot

; --------------------------------------------------
Init
        ld      (oldIY), iy
        ld      hl, PutChar
        ld      (Writer.Char.proc), hl
        ld      a, $0d
        ld      (Writer.NewLine.char), A
        ret

; --------------------------------------------------
@PutChar
        push    iy
        ld      iy, (oldIY)
        rst     $10
        pop     iy
        ret

; --------------------------------------------------
Exit
        ld      iy, (oldIY)
        scf        ; set error flag
        ld a, 1    ; OK message
        ret

; --------------------------------------------------
; Input
;   HL - message (dc string)
Error
        ld      iy, (oldIY)
        scf        ; set error flag
        xor     a  ; custom message in HL
        ret

oldIY   dw      0

        endmodule
        endif
