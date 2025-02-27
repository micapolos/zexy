        ifndef  L2_X320_Patch_asm
        define  L2_X320_Patch_asm

        include ../../banked-ptr.asm
        include size.asm

        module  L2
        module  X320

        struct  Patch
size    Size
advance db      0
data    BankedPtr
        ends

        module  Patch

        endmodule
        endmodule
        endmodule

        endif
