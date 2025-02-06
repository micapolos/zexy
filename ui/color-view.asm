        ifndef  UIColorView_asm
        define  UIColorView_asm

        include ui/view.asm

        module  UIColorView

class   UIViewClass { NeedsDraw, Draw }

NeedsDraw
        ret

; Input
;   hl - UIView ptr
;   de - UIPainter ptr
Draw
        ret

        endmodule

        endif
