        ifndef  Process_asm
        define  Process_asm

        module  Process

        struct  Process
regs    ds      8+4+8   ; afbcdehl/ixiy/afbcdehl`
mmu     ds      8       ; slots 0-7
regPc   dw
regSp   dw
        ends

        endmodule

        endif
