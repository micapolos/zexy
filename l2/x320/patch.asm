        ifndef  L2_X320_Patch_asm
        define  L2_X320_Patch_asm

        include ../../banked-ptr.asm

        module  L2
        module  X320

        struct  Patch
width   dw      0
height  db      0
advance db      0
data    BankedPtr
        ends

        module  Patch

        endmodule
        endmodule
        endmodule

        endif
