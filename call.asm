        ifndef  Call_asm
        define  Call_asm

        module  Call

        macro   calli reg
        push    .ret
        jp      (reg)
.ret
        endm

        endmodule

        endif
