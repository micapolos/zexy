        ifndef  Assert_asm
        define  Assert_asm

        module  Assert

Print
        ld      a, 'a'
        rst     $10
        ld      a, 'b'
        rst     $10
        ld      a, 'c'
        rst     $10

        ret

        endmodule

        endif
