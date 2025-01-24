        IFNDEF  COLOR_LIB
        DEFINE  COLOR_LIB

        MODULE  Color

        MACRO   RGB_333 r, g, b
        DB      (r << 5) | (g << 2) | (b >> 1)
        DB      b & 1
        ENDM

        MACRO   RGB_332 r, g, b
        DB      (r << 5) | (g << 2) | b
        ENDM

        ENDMODULE

        ENDIF
