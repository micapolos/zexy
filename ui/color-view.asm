        ifndef  UIColorView_asm
        define  UIColorView_asm

        module  UIColorView

class   UIViewClass { NeedsDraw, Draw }

        endm

NeedsDraw
        ret

; Input
;   hl - UIView ptr
;   de - x
;   c - y

Draw

        ret

        endmodule

        endif
