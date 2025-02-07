        ifndef  UISysMenu_asm
        define  UISysMenu_asm

        include ui/frame.asm
        include struct.asm

        module  UISysMenu

; Input
;    hl - UIFrame ptr
; Output
;    hl - advanced
FrameBackground
        ; background
        ld       a, 1
        call     Frame.Fill
        StructDec UIFrame

        fillrect 0, 0, 320, 0, 5

        ; menu background
        fillrect 0, 0, 320, 9, 1
        fillrect 0, 9, 320, 1, 2
        fillrect 0, 10, 320, 1, 0

        ; rounded corner
        point    0, 0, 0
        point    319, 0, 0

        point    1, 0, 3
        point    318, 0, 3
        point    0, 1, 3
        point    319, 1, 3

        point    2, 0, 2
        point    317, 0, 2
        point    0, 2, 2
        point    319, 2, 2

        end


        endmodule

        endif
