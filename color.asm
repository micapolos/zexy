        ifndef  Color_asm
        define  Color_asm

        module  Color

        macro   RGB_333 r, g, b
        db      (r << 5) | (g << 2) | (b >> 1)
        db      b & 1
        endm

        macro   RGB_332 r, g, b
        db      (r << 5) | (g << 2) | b
        endm

        endmodule

        endif
