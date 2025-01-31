        ifndef  IntTable_asm
        define  IntTable_asm

        module  IntTable

SIZE            equ     $20

        align   $20
start
line            dw      0
uart0rx         dw      0
uart1rx         dw      0
ctc0            dw      0
ctc1            dw      0
ctc2            dw      0
ctc3            dw      0
ctc4            dw      0
ctc5            dw      0
ctc6            dw      0
ctc7            dw      0
ula             dw      0
uart0tx         dw      0
uart1tx         dw      0
                dw      0
                dw      0
end

        assert  (start & %11111) = 0
        assert  end - start = SIZE

        endmodule

        endif
